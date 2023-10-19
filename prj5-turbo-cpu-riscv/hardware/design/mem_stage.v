

`timescale 10ns / 1ns
`include "mycpu.h"
module mem_stage(
    input                          clk           ,
    input                          reset         ,
    //allowin
    input                          wb_allow_in    ,
    output                         mem_allow_in    ,
    //from es
    input                          ex_to_mem_valid,
    input  [`EX_TO_MEM_BUS_WD -1:0] ex_to_mem_bus  ,
	//to id
	output [`READ_AFTER_WRITE_BUS_WD-1:0] mem_read_after_write_bus,
	//to wb
    output                         mem_to_wb_valid,
    output [`MEM_TO_WB_BUS_WD -1:0] mem_to_wb_bus  ,
    //from data-sram
	input Read_data_Valid,
	output Read_data_Ready,
    input  [31                 :0] Read_data
);

	reg         mem_valid;
	wire        mem_ready_go;
	wire write_valid;
	assign write_valid=mem_valid && RF_write_mem;
	assign mem_read_after_write_bus={write_valid,mem_ready_go,RF_waddr_mem,RF_write_data_mem};
	
	assign Read_data_Ready=mem_read_mem && mem_valid && wb_allow_in || reset ;
	assign mem_ready_go=mem_read_mem?Read_data_Valid:1'b1;
	assign mem_allow_in     = !mem_valid || mem_ready_go && wb_allow_in;
	assign mem_to_wb_valid = mem_valid && mem_ready_go;
	always @(posedge clk) begin
		if (reset) begin
			mem_valid <= 1'b0;
		end
		else if (mem_allow_in) begin
			mem_valid <= ex_to_mem_valid;
		end
	end
	reg [`EX_TO_MEM_BUS_WD -1:0] ex_to_mem_bus_r;
	always @(posedge clk)begin
		if (ex_to_mem_valid && mem_allow_in) begin
			ex_to_mem_bus_r <= ex_to_mem_bus;
		end
	end

	wire [31:0]pc_mem;
	wire [2:0]ls_type_mem;
	wire mem_read_mem;
	wire [31:0]alu_result_mem;
	wire [31:0]shift_result_mem;
	wire RF_write_mem;
	wire [4:0]RF_waddr_mem;
	wire [2:0]RF_wdata_src_mem;
	wire [31:0]lui_wdata_mem;
	wire [31:0]auipc_wdata_mem;
	assign {pc_mem,ls_type_mem,mem_read_mem,
	alu_result_mem,shift_result_mem,	RF_write_mem,RF_waddr_mem,RF_wdata_src_mem,lui_wdata_mem,auipc_wdata_mem}=ex_to_mem_bus_r[175:3];


	wire [1:0]n;
	wire [31:0]mem_read_data;
	assign n=alu_result_mem[1:0];
	assign mem_read_data=Read_data;

	//load:Memread
	wire [31:0]lb_data;
	assign lb_data=(n==0)?{{24{mem_read_data[7]}},mem_read_data[7:0]}:
	(n==1)?{{24{mem_read_data[15]}},mem_read_data[15:8]}:
	(n==2)?{{24{mem_read_data[23]}},mem_read_data[23:16]}:
	(n==3)?{{24{mem_read_data[31]}},mem_read_data[31:24]}:31'b0;

	wire [31:0]lh_data;
	assign lh_data=(n==0)?{{16{mem_read_data[15]}},mem_read_data[15:0]}:
	(n==2)?{{16{mem_read_data[31]}},mem_read_data[31:16]}:31'b0;

	wire [31:0]lbu_data;
	assign lbu_data=(n==0)?{24'b0,mem_read_data[7:0]}:
	(n==1)?{24'b0,mem_read_data[15:8]}:
	(n==2)?{24'b0,mem_read_data[23:16]}:
	(n==3)?{24'b0,mem_read_data[31:24]}:31'b0;

	wire [31:0]lhu_data;
	assign lhu_data=(n==0)?{16'b0,mem_read_data[15:0]}:
	(n==2)?{16'b0,mem_read_data[31:16]}:31'b0;

	wire [31:0] modified_read_data;
	assign modified_read_data=(ls_type_mem==3'b000)?lb_data:
	(ls_type_mem==3'b001)?lh_data:
	(ls_type_mem==3'b010)?mem_read_data:
	(ls_type_mem==3'b100)?lbu_data:
	(ls_type_mem==3'b101)?lhu_data:32'b0;
	
	wire [31:0]RF_write_data_mem;
	assign RF_write_data_mem=(RF_wdata_src_mem==3'b000)?alu_result_mem:
	(RF_wdata_src_mem==3'b001)?pc_mem+4:
	(RF_wdata_src_mem==3'b010)?shift_result_mem:
	(RF_wdata_src_mem==3'b011)?lui_wdata_mem:
	(RF_wdata_src_mem==3'b100)?auipc_wdata_mem:
	(RF_wdata_src_mem==3'b101)?modified_read_data:31'b0;

	assign mem_to_wb_bus={
	pc_mem,RF_write_mem,RF_waddr_mem,RF_write_data_mem//32+1+5+32
	};
endmodule
