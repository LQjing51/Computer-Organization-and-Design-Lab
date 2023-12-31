# TODO: Change to your Vivado IDE version and installed location
VIVADO_VERSION ?= 2019.1
VIVADO_TOOL_BASE ?= /opt/Xilinx_$(VIVADO_VERSION)

# Vivado and SDK tool executable binary location
VIVADO_TOOL_PATH := $(VIVADO_TOOL_BASE)/Vivado/$(VIVADO_VERSION)/bin
SDK_TOOL_PATH := $(VIVADO_TOOL_BASE)/SDK/$(VIVADO_VERSION)/bin

# Leveraged Vivado tools
VIVADO_BIN := $(VIVADO_TOOL_PATH)/vivado
BOOT_GEN_BIN := $(SDK_TOOL_PATH)/bootgen

# Temporal directory to hold hardware design output files 
# (i.e., bitstream, hardware definition file (HDF))
HW_PLATFORM := $(shell pwd)/hw_plat
BITSTREAM := $(HW_PLATFORM)/system.bit
HW_DESIGN_HDF := $(HW_PLATFORM)/system.hdf

# HW_ACT list
#==========================================
# rtl_chk: 		Checking RTL syntax and synthesizability in this project
# sch_gen:		Generating gate-level schematic of a RTL module
# bhv_sim:		Launching behavioral simulation and 
# 				dumping the waveform file (.wdb)
# wav_chk:		Opening waveform file of behavior or timing simulation
# bit_gen:		Generating the bitstream file (.bit) via automatically 
# 				launching synthesis and implementation
#==========================================
# Default Vivado GUI launching flags if not specified in command line
HW_ACT ?= none
HW_VAL ?= adder

# FPGA Evaluation
# VM
FPGA_RUN := $(shell pwd)/run/fpga_run.sh 
# Gitlab CI
FPGA_RUN_CI := $(shell pwd)/run/ci_run.sh 

CI_RUN ?= n

USER ?= none

BOARD_IP ?= none

.PHONY: FORCE

#==========================================
# Hardware Design
#==========================================
vivado_prj: FORCE
	@echo "Executing $(HW_ACT) for Vivado project..."
	@mkdir -p $(HW_PLATFORM)
ifneq ($(CI_RUN),y)
	@-git checkout -- run/log
	$(MAKE) -C ./hardware VIVADO=$(VIVADO_BIN) HW_ACT=$(HW_ACT) HW_VAL="$(HW_VAL)" CI_RUN=$(CI_RUN) O=$(HW_PLATFORM) $@
	@-git add --all && git commit -m "autocmt: $@ HW_ACT=$(HW_ACT) HW_VAL=\"$(HW_VAL)\""
else
	$(MAKE) -C ./hardware VIVADO=$(VIVADO_BIN) HW_ACT=$(HW_ACT) HW_VAL="$(HW_VAL)" CI_RUN=$(CI_RUN) O=$(HW_PLATFORM) $@
endif

bit_bin:
	@echo '"make bit_bin" is deprecated. Run "make HW_ACT=bit_gen vivado_prj" to generate bit.bin file.'

#==========================================
# Cloud environment usage
#==========================================
cloud_run:
ifneq (${USER},none)
	@mkdir -p ./run/log
	@cd ./run && bash $(FPGA_RUN) $(VIVADO_BIN) n cloud $(USER) | tee ./log/cloud_run.log
	@-git add --all && git commit -m "autocmt: $@ USER=$(USER)"
else
	$(error Please correctly set your user name for cloud environment)
endif

#==========================================
# Local environment usage
#==========================================
local_run:
ifneq (${BOARD_IP},none)
	@mkdir -p ./run/log
	@cd ./run && bash $(FPGA_RUN) $(VIVADO_BIN) n local $(BOARD_IP) | tee ./log/local_run.log
	@-git add --all && git commit -m "autocmt: $@"
else
	$(error Please correctly set IP address of the FPGA board)
endif

#==========================================
# CI pipeline usage
#==========================================
ci_run:
	@mkdir -p ./run/log
	@cd ./run && bash $(FPGA_RUN_CI) | tee ./log/cloud_run.log

help: FORCE
	@cat help

