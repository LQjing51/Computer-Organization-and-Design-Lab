#========================================================
# Vivado BD design auto run script for MPSoC in ZCU102
# Based on Vivado 2017.2
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 22/12/2017
#========================================================

namespace eval mpsoc_bd_val {
	set design_name cpu_fixed
	set bd_prefix ${mpsoc_bd_val::design_name}_

}

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${mpsoc_bd_val::design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne ${mpsoc_bd_val::design_name} } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <${mpsoc_bd_val::design_name}> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq ${mpsoc_bd_val::design_name} } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <${mpsoc_bd_val::design_name}> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${mpsoc_bd_val::design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <${mpsoc_bd_val::design_name}> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <${mpsoc_bd_val::design_name}> in project, so creating one..."

   create_bd_design ${mpsoc_bd_val::design_name}

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <${mpsoc_bd_val::design_name}> as current_bd_design."
   current_bd_design ${mpsoc_bd_val::design_name}

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"${mpsoc_bd_val::design_name}\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

#=============================================
# Create IP blocks
#=============================================

  # CPU instruction port interconnect
  set cpu_inst_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 cpu_inst_ic ]
  set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $cpu_inst_ic

  # CPU memory port interconnect (seperated to data and mmio)
  set cpu_mem_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 cpu_mem_ic ]
  set_property -dict [list CONFIG.NUM_MI {2} CONFIG.NUM_SI {1}] $cpu_mem_ic

  # DDR access interconnect
  set cpu_ddr_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 cpu_ddr_ic ]
  set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {2}] $cpu_ddr_ic

  set cpu_ddr_upsizer [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 cpu_ddr_upsizer ]
  set_property -dict [list CONFIG.MI_DATA_WIDTH.VALUE_SRC {USER}] $cpu_ddr_upsizer

  # CPU mmio interconnect 
  set cpu_mmio_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 cpu_mmio_ic ]
  set_property -dict [list CONFIG.NUM_MI {2} CONFIG.NUM_SI {1}] $cpu_mmio_ic

  # CPU AXI interconnect to Zynq PS
  set axi_shell_to_role_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_shell_to_role_ic ]
  set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_shell_to_role_ic

  # Create instance: Reset infrastructure for CPU sub systems
  set cpu_reset_infra [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 cpu_reset_infra ]
	  
  set cpu_reset_io [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 cpu_reset_io ]
  set_property -dict [ list CONFIG.C_ALL_INPUTS {0} \
			CONFIG.C_ALL_OUTPUTS {1} \
			CONFIG.C_GPIO_WIDTH {1} ] $cpu_reset_io

#=============================================
# Clock ports
#=============================================
  # CPU clock output
  create_bd_port -dir I -type clk role_clk

  create_bd_port -dir I -type clk cpu_clk

#==============================================
# Reset ports
#==============================================
  # system reset_n
  create_bd_port -dir I -type rst role_resetn
  create_bd_port -dir I -type rst sys_port_reset_n

  set_property CONFIG.ASSOCIATED_RESET {role_resetn:sys_port_reset_n} \
		[get_bd_ports role_clk]

  create_bd_port -dir O -type rst cpu_reset_n
  create_bd_port -dir O -type rst cpu_ic_reset_n
  create_bd_port -dir O -type rst cpu_reset

#==============================================
# Other ports
#==============================================
  create_bd_port -dir I cpu_clk_locked

#==============================================
# Export AXI Interface
#==============================================
  # CPU Inst port
  set cpu_inst [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cpu_inst]
  set_property -dict [ list CONFIG.READ_WRITE_MODE {READ_ONLY} \
				CONFIG.ID_WIDTH {0} \
				CONFIG.HAS_CACHE {0} \
				CONFIG.HAS_LOCK {0} \
				CONFIG.HAS_PROT {0} \
				CONFIG.HAS_REGION {0} \
				CONFIG.HAS_QOS {0} ] $cpu_inst

  # CPU mem port
  set cpu_mem [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cpu_mem]
  set_property -dict [ list CONFIG.ID_WIDTH {0} \
				CONFIG.HAS_CACHE {0} \
				CONFIG.HAS_LOCK {0} \
				CONFIG.HAS_PROT {0} \
				CONFIG.HAS_REGION {0} \
				CONFIG.HAS_QOS {0} ] $cpu_mem

  set axi_role_to_shell [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_role_to_shell]
  set_property -dict [ list CONFIG.PROTOCOL {AXI4Lite} ] $axi_role_to_shell

  set cpu_perf_cnt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 cpu_perf_cnt]
  set_property -dict [ list CONFIG.PROTOCOL {AXI4Lite} ] $cpu_perf_cnt

  # Connect to CPU AXI-Lite slave
  set axi_shell_to_role [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_shell_to_role]
  set_property -dict [ list CONFIG.PROTOCOL {AXI4Lite} ] $axi_shell_to_role

  set_property CONFIG.ASSOCIATED_BUSIF {axi_shell_to_role:axi_role_to_shell:axi_role_to_mem} [get_bd_ports role_clk]

  set_property CONFIG.ASSOCIATED_BUSIF {cpu_inst:cpu_mem:cpu_perf_cnt} [get_bd_ports cpu_clk]

#=============================================
# System clock connection
#=============================================
  connect_bd_net -net cpu_clk [get_bd_ports cpu_clk] \
			[get_bd_pins cpu_reset_infra/slowest_sync_clk] \
			[get_bd_pins cpu_inst_ic/ACLK] \
			[get_bd_pins cpu_inst_ic/S00_ACLK] \
			[get_bd_pins cpu_mem_ic/ACLK] \
			[get_bd_pins cpu_mem_ic/S00_ACLK] \
			[get_bd_pins cpu_mem_ic/M01_ACLK] \
			[get_bd_pins cpu_mmio_ic/ACLK] \
			[get_bd_pins cpu_mmio_ic/S00_ACLK] \
			[get_bd_pins cpu_mmio_ic/M01_ACLK] \
			[get_bd_pins axi_shell_to_role_ic/ACLK] \
			[get_bd_pins axi_shell_to_role_ic/M00_ACLK] \
			[get_bd_pins cpu_reset_io/s_axi_aclk]

  connect_bd_net -net role_clk [get_bd_ports role_clk] \
			[get_bd_pins cpu_inst_ic/M00_ACLK] \
			[get_bd_pins cpu_mem_ic/M00_ACLK] \
			[get_bd_pins cpu_mmio_ic/M00_ACLK] \
			[get_bd_pins cpu_ddr_ic/*ACLK] \
			[get_bd_pins cpu_ddr_upsizer/s_axi_aclk] \
			[get_bd_pins axi_shell_to_role_ic/S00_ACLK]

#=============================================
# System reset connection
#=============================================
  connect_bd_net -net ps_user_reset_n [get_bd_ports role_resetn] \
			[get_bd_pins cpu_reset_infra/ext_reset_in]

  connect_bd_net -net cpu_resetn [get_bd_pins cpu_reset_infra/peripheral_aresetn] \
			[get_bd_pins cpu_inst_ic/S00_ARESETN] \
			[get_bd_pins cpu_mem_ic/S00_ARESETN] \
			[get_bd_pins cpu_mem_ic/M01_ARESETN] \
			[get_bd_pins cpu_mmio_ic/S00_ARESETN] \
			[get_bd_pins cpu_mmio_ic/M01_ARESETN] \
			[get_bd_pins axi_shell_to_role_ic/M00_ARESETN] \
			[get_bd_ports cpu_reset_n] \
			[get_bd_pins cpu_reset_io/s_axi_aresetn]

  connect_bd_net -net sys_perip_resetn [get_bd_ports sys_port_reset_n] \
			[get_bd_pins cpu_inst_ic/M00_ARESETN] \
			[get_bd_pins cpu_mem_ic/M00_ARESETN] \
			[get_bd_pins cpu_ddr_ic/*ARESETN] \
			[get_bd_pins cpu_ddr_upsizer/s_axi_aresetn] \
			[get_bd_pins cpu_mmio_ic/M00_ARESETN] \
			[get_bd_pins axi_shell_to_role_ic/S00_ARESETN]

  connect_bd_net -net cpu_ic_resetn [get_bd_pins cpu_reset_infra/interconnect_aresetn] \
			[get_bd_pins cpu_inst_ic/ARESETN] \
			[get_bd_pins cpu_mem_ic/ARESETN] \
			[get_bd_pins cpu_mmio_ic/ARESETN] \
			[get_bd_pins axi_shell_to_role_ic/ARESETN] \
			[get_bd_pins cpu_ic_reset_n]

  connect_bd_net [get_bd_pins cpu_reset_infra/dcm_locked] [get_bd_ports cpu_clk_locked]

  connect_bd_net [get_bd_pins cpu_reset_io/gpio_io_o] [get_bd_ports cpu_reset]

#==============================================
# AXI Interface Connection
#==============================================
  # CPU instruction ports
  connect_bd_intf_net -intf_net cpu_inst [get_bd_intf_pins cpu_inst_ic/S00_AXI] \
			[get_bd_intf_ports cpu_inst]

  connect_bd_intf_net -intf_net cpu_axi_inst [get_bd_intf_pins cpu_inst_ic/M00_AXI] \
			[get_bd_intf_pins cpu_ddr_ic/S00_AXI]

  # CPU memory ports
  connect_bd_intf_net -intf_net cpu_mem [get_bd_intf_pins cpu_mem_ic/S00_AXI] \
			[get_bd_intf_ports cpu_mem]

  connect_bd_intf_net -intf_net cpu_data [get_bd_intf_pins cpu_mem_ic/M00_AXI] \
			[get_bd_intf_pins cpu_ddr_ic/S01_AXI]

  connect_bd_intf_net -intf_net cpu_mmio [get_bd_intf_pins cpu_mem_ic/M01_AXI] \
			[get_bd_intf_pins cpu_mmio_ic/S00_AXI]

  # CPU DDR port
  connect_bd_intf_net -intf_net cpu_ddr [get_bd_intf_pins cpu_ddr_ic/M00_AXI] \
			[get_bd_intf_pins cpu_ddr_upsizer/S_AXI]

  make_bd_intf_pins_external -name axi_role_to_mem [get_bd_intf_pins cpu_ddr_upsizer/M_AXI]

  # CPU MMIO ports
  connect_bd_intf_net -intf_net cpu_uart [get_bd_intf_pins cpu_mmio_ic/M00_AXI] \
			[get_bd_intf_pins axi_role_to_shell]

  connect_bd_intf_net -intf_net cpu_perf_cnt [get_bd_intf_pins cpu_mmio_ic/M01_AXI] \
			[get_bd_intf_pins cpu_perf_cnt]

  # CPU AXI MMIO ports (to Zynq PS)
  connect_bd_intf_net -intf_net zynq_axi_mmio [get_bd_intf_pins axi_shell_to_role_ic/M00_AXI] \
			[get_bd_intf_pins cpu_reset_io/S_AXI]

  connect_bd_intf_net -intf_net zynq_axi_shell_to_role [get_bd_intf_pins axi_shell_to_role_ic/S00_AXI] \
			[get_bd_intf_pins axi_shell_to_role]

#=============================================
# Create address segments
#=============================================

  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces cpu_inst] [get_bd_addr_segs axi_role_to_mem/Reg] CPU_INST
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces cpu_mem] [get_bd_addr_segs axi_role_to_mem/Reg] CPU_DATA
  create_bd_addr_seg -range 0x1000 -offset 0x40010000 [get_bd_addr_spaces cpu_mem] [get_bd_addr_segs axi_role_to_shell/Reg] CPU_UART
  create_bd_addr_seg -range 0x8000 -offset 0x40020000 [get_bd_addr_spaces cpu_mem] [get_bd_addr_segs cpu_perf_cnt/Reg] CPU_PERF

  create_bd_addr_seg -range 0x1000 -offset 0x00020000 [get_bd_addr_spaces axi_shell_to_role] [get_bd_addr_segs cpu_reset_io/S_AXI/Reg] CPU_RESET_REG

#=============================================
# Finish BD creation 
#=============================================

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

