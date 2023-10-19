`timescale 10ns / 1ns
`include "mycpu.h"
module custom_cpu(
	input  rst,
	input  clk,

`ifdef BHV_SIM
	input  inst_retired_fifo_full,
`endif

	//Instruction request channel
	output [31:0] PC,
	output Inst_Req_Valid,
	input Inst_Req_Ready,

	//Instruction response channel
	input  [31:0] Instruction,
	input Inst_Valid,
	output Inst_Ready,

	//Memory request channel
	output [31:0] Address,
	output MemWrite,
	output [31:0] Write_data,
	output [3:0] Write_strb,
	output MemRead,
	input Mem_Req_Ready,

	//Memory data response channel
	input  [31:0] Read_data,
	input Read_data_Valid,
	output Read_data_Ready, 

    output [31:0]	cpu_perf_cnt_0,
    output [31:0]	cpu_perf_cnt_1,
    output [31:0]	cpu_perf_cnt_2,
    output [31:0]	cpu_perf_cnt_3,
    output [31:0]	cpu_perf_cnt_4,
    output [31:0]	cpu_perf_cnt_5,
    output [31:0]	cpu_perf_cnt_6,
    output [31:0]	cpu_perf_cnt_7,
    output [31:0]	cpu_perf_cnt_8,
    output [31:0]	cpu_perf_cnt_9,
    output [31:0]	cpu_perf_cnt_10,
    output [31:0]	cpu_perf_cnt_11,
    output [31:0]	cpu_perf_cnt_12,
    output [31:0]	cpu_perf_cnt_13,
    output [31:0]	cpu_perf_cnt_14,
    output [31:0]	cpu_perf_cnt_15

);

/* The following two signals are leveraged for behavioral simulation, 
* both of which are delivered to testbench.
*
* STUDENTS MUST CONTROL LOGICAL BEHAVIORS of BOTH SIGNALS.
*
* inst_retire_valid (1-bit): setting to 1 for one-cycle 
* when inst_retired_fifo_full from testbench is low,  
* indicating that one instruction is being retired from
* the WB stage. 
*
* inst_retired (70-bit): detailed information of the retired instruction,
* mainly including (in order) 
* { 
*   retired PC (32-bit), 
*   reg_file write-back enable (1-bit), 
*   reg_file write-back address (5-bit), 
*   reg_file write-back data (32-bit) 
* }
*
*/
`ifdef BHV_SIM
	wire inst_retire_valid;
	wire [69:0] inst_retired;
`endif

  //TODO: Please add your Turbo CPU code here
	reg [31:0] cycle_cnt;
	always @(posedge clk)
	begin
		if(rst==1'b1)
			cycle_cnt <=32'd0;
		else
			cycle_cnt<=cycle_cnt+32'd1;
	end
	assign cpu_perf_cnt_0=cycle_cnt;




	wire         id_allow_in;
	wire         ex_allow_in;
	wire         mem_allow_in;
	wire         wb_allow_in;
	wire         if_to_id_valid;
	wire         id_to_ex_valid;
	wire         ex_to_mem_valid;
	wire         mem_to_wb_valid;
	wire [`IF_TO_ID_BUS_WD -1:0] if_to_id_bus;
	wire [`ID_TO_EX_BUS_WD -1:0] id_to_ex_bus;
	wire [`EX_TO_MEM_BUS_WD -1:0] ex_to_mem_bus;
	wire [`MEM_TO_WB_BUS_WD -1:0] mem_to_wb_bus;
	wire [`WB_TO_RF_BUS_WD -1:0] wb_to_rf_bus;
	wire [`BR_BUS_WD       -1:0] br_bus;
	wire id_valid;
	wire [`READ_AFTER_WRITE_BUS_WD-1:0] ex_read_after_write_bus;
	wire [`READ_AFTER_WRITE_BUS_WD-1:0] mem_read_after_write_bus;
	wire [`READ_AFTER_WRITE_BUS_WD-1:0] wb_read_after_write_bus;

	if_stage if_stage(
	.clk(clk),
	.reset(rst),
	.id_allow_in(id_allow_in),
	.id_valid(id_valid),
	.br_bus(br_bus),
	.if_to_id_valid(if_to_id_valid),
	.if_to_id_bus(if_to_id_bus),
	.Inst_Ready(Inst_Ready),
	.Inst_Valid(Inst_Valid),
	.Inst_Req_Valid(Inst_Req_Valid),
	.Inst_Req_Ready(Inst_Req_Ready),
	.PC(PC),
	.Instruction(Instruction)
	);

	id_stage id_stage(
	.clk(clk),
	.reset(rst),
	.ex_allow_in(ex_allow_in),
	.id_allow_in(id_allow_in),
	.if_to_id_valid(if_to_id_valid),
	.if_to_id_bus(if_to_id_bus),
	.ex_read_after_write_bus(ex_read_after_write_bus),
	.mem_read_after_write_bus(mem_read_after_write_bus),
	.wb_read_after_write_bus(wb_read_after_write_bus),
	.id_to_ex_valid(id_to_ex_valid),
	.id_to_ex_bus(id_to_ex_bus),
	.to_if_valid(id_valid),
	.br_bus(br_bus),
	.wb_to_rf_bus(wb_to_rf_bus)
	);

	ex_stage ex_stage(
	.clk(clk),
	.reset(rst),
	.mem_allow_in(mem_allow_in),
	.ex_allow_in(ex_allow_in),
	.id_to_ex_valid(id_to_ex_valid),
	.id_to_ex_bus(id_to_ex_bus),
	.ex_read_after_write_bus(ex_read_after_write_bus),
	.ex_to_mem_valid(ex_to_mem_valid),
	.ex_to_mem_bus(ex_to_mem_bus),
	.Mem_Req_Ready(Mem_Req_Ready),
	.MemWrite(MemWrite),
	.MemRead(MemRead),
	.Address(Address),
	.Write_data(Write_data),
	.Write_strb(Write_strb)
	);

	mem_stage mem_stage(
	.clk(clk),
	.reset(rst),
	.wb_allow_in(wb_allow_in),
	.mem_allow_in(mem_allow_in),
	.ex_to_mem_valid(ex_to_mem_valid),
	.ex_to_mem_bus(ex_to_mem_bus),
	.mem_read_after_write_bus(mem_read_after_write_bus),
	.mem_to_wb_valid(mem_to_wb_valid),
	.mem_to_wb_bus(mem_to_wb_bus),
	.Read_data_Valid(Read_data_Valid),
	.Read_data_Ready(Read_data_Ready),
	.Read_data(Read_data)
	);
	
	
	wb_stage wb_stage(
	.clk(clk),
	.reset(rst),
	`ifdef BHV_SIM
	.inst_retired_fifo_full(inst_retired_fifo_full),
	.inst_retire_valid(inst_retire_valid),
	.inst_retired(inst_retired),
	`endif
	.wb_allow_in(wb_allow_in),
	.mem_to_wb_valid(mem_to_wb_valid),
	.mem_to_wb_bus(mem_to_wb_bus),
	.wb_read_after_write_bus(wb_read_after_write_bus),
	.wb_to_rf_bus(wb_to_rf_bus)
	);
	

endmodule

