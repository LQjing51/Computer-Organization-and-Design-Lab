`timescale 10ns / 1ns
`include "mycpu.h"
module if_stage(
    input                          clk            ,
    input                          reset          ,
    //allwoin
    input                          id_allow_in     ,
    //brbus
	input				id_valid,
    input  [`BR_BUS_WD       -1:0] br_bus         ,
    //to ds
    output                         if_to_id_valid ,
    output [`IF_TO_ID_BUS_WD-1:0] if_to_id_bus   ,
    // inst sram interface
	output Inst_Ready,
	input Inst_Valid,
	output Inst_Req_Valid,
	input Inst_Req_Ready,
    output [31:0] PC,
	input [31:0] Instruction
    
);

	reg         if_valid;
	wire        if_ready_go;
	wire        if_allow_in;
	wire        to_if_valid;

	assign to_if_valid  = ~reset;
	assign if_ready_go    = Inst_Valid && req_suc; 
	assign if_allow_in     = !if_valid || if_ready_go && id_allow_in;
	assign if_to_id_valid =  if_valid && if_ready_go && !br_en_r;
	always @(posedge clk) begin
		if (reset) begin
		    if_valid <= 1'b0;
		end
		else if (if_allow_in) begin
		    if_valid <= to_if_valid && Inst_Req_Ready;
		end
	end

	assign Inst_Req_Valid=to_if_valid && if_allow_in ;
	assign Inst_Ready=id_allow_in && req_suc || reset;
	reg req_suc;
	always @(posedge clk)begin
		if(if_allow_in)begin
			req_suc<=Inst_Req_Valid && Inst_Req_Ready;
		end
	end
	
	assign PC=nextpc_r;
		
	wire         br_en;
	wire [ 31:0] br_target;
	assign {br_en,br_target} = br_bus;

	wire [31:0] seq_pc;
	wire [31:0] nextpc;
	assign seq_pc       = if_pc + 4;
	assign nextpc       =  (br_en) ? br_target : seq_pc; 

	reg br_en_r;
	reg br_en_t;
	always@(posedge clk)begin
		if(reset)begin
			br_en_r<=1'b0;
		end
		else if(id_valid || if_allow_in)begin
			br_en_r<=br_en;
		end
	end
	always @(posedge clk)begin
		br_en_t<=br_en_r;
	end

	reg [31:0]nextpc_r;
	always @(posedge clk)begin
		if(reset)begin
			nextpc_r<=seq_pc;
		end
		else if(id_valid  || !br_en_r && br_en_t ||(~|if_pc))begin
			nextpc_r<=nextpc;
		end
	end
	wire [31:0] if_inst;
	assign if_inst=Instruction;
	reg  [31:0] if_pc;
	assign if_to_id_bus = {if_inst,if_pc};


	always @(posedge clk)begin
		if (reset) begin
		    if_pc <= 32'hfffffffc;  //trick: to make nextpc be 0x00000000 during reset 
		end
		else if (Inst_Req_Valid && Inst_Req_Ready) begin
		    if_pc <= nextpc_r;
		end
	end
	endmodule
