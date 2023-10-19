
`timescale 10ns / 1ns
`include "mycpu.h"


module ex_stage(
	    input                          clk           ,
	    input                          reset         ,
	    //allowin
	    input                          mem_allow_in    ,
	    output                         ex_allow_in    ,
	    //from id
	    input                          id_to_ex_valid,
	    input  [`ID_TO_EX_BUS_WD -1:0] id_to_ex_bus  ,
		//to id
		output [`READ_AFTER_WRITE_BUS_WD-1:0] ex_read_after_write_bus,
	    //to mem
	    output                         ex_to_mem_valid,
	    output [`EX_TO_MEM_BUS_WD -1:0] ex_to_mem_bus  ,
	    // data sram interface
		input Mem_Req_Ready,
		output MemWrite,
		output MemRead,
		output [31:0]Address,
		output [31:0]Write_data,
		output [3:0]Write_strb
);

	reg         ex_valid      ;
	wire        ex_ready_go   ;
	assign MemWrite=mem_write_ex && ex_valid && !req_suc;
	assign MemRead=mem_read_ex && ex_valid && !req_suc;
	assign ex_ready_go=req_suc || !mem_write_ex && !mem_read_ex;
	assign ex_allow_in     = !ex_valid || ex_ready_go && mem_allow_in;
	assign ex_to_mem_valid =  ex_valid && ex_ready_go;
	reg req_suc;
	always @(posedge clk)begin
		if(!req_suc || ex_allow_in)begin
			req_suc<=Mem_Req_Ready && (MemWrite || MemRead);
		end
	end

	wire write_valid;
	assign write_valid=ex_valid && RF_write_ex;
	
	assign ex_read_after_write_bus={write_valid,~mem_read_ex,RF_waddr_ex,useful_result_ex};
	wire [31:0]useful_result_ex;
	assign useful_result_ex=(ls_type_ex==3'b001 || ls_type_ex==3'b101)?shift_result_ex:alu_result_ex;//sll:001,srl or sra:101

	always @(posedge clk) begin
	    if (reset) begin
		ex_valid <= 1'b0;
	    end
	    else if (ex_allow_in) begin
		ex_valid <= id_to_ex_valid;
		end

	    if (id_to_ex_valid && ex_allow_in) begin
		id_to_ex_bus_r <= id_to_ex_bus;
	    end
	end

	reg  [`ID_TO_EX_BUS_WD -1:0] id_to_ex_bus_r;
	wire [31:0]pc_ex;
	wire [31:0]reg_read_data1_ex;
	wire [31:0]reg_read_data2_ex;
	wire mem_read_ex;
	wire mem_write_ex;
	wire [31:0]B_ex;
	wire [31:0]B1_ex;
	wire [2:0]ALUop_ex;
	wire [1:0]Shiftop_ex;
	wire [2:0]ls_type_ex;
	wire RF_write_ex;
	wire [4:0]RF_waddr_ex;
	wire [2:0]RF_wdata_src_ex;
	wire [31:0]lui_wdata_ex;
	wire [31:0]auipc_wdata_ex;
	assign{pc_ex,ALUop_ex,Shiftop_ex,B_ex,B1_ex,
	reg_read_data1_ex,reg_read_data2_ex,
	RF_write_ex,RF_waddr_ex,lui_wdata_ex,auipc_wdata_ex,RF_wdata_src_ex,
	mem_read_ex,mem_write_ex,ls_type_ex}=id_to_ex_bus_r[243:1];

	//alu
	wire [31:0]A;
	wire [31:0]B;
	assign A=reg_read_data1_ex;//A=R[rs1]
	assign B=B_ex;

	wire Overflow;
	wire Carryout;
	wire zero;
	wire[31:0] alu_result_ex;
	alu my_alu(.A(A),.B(B),.ALUop(ALUop_ex),.Overflow(Overflow),
.CarryOut(CarryOut),.Zero(zero),.Result(alu_result_ex));

	//shifter
	wire [31:0]shift_result_ex;
	wire [31:0]A1;
	wire [31:0]B1;
	assign A1=reg_read_data1_ex;//R[rs1]
	assign B1=B1_ex;
	shifter my_shifter(.A(A1),.B(B1),.Shiftop(Shiftop_ex),.Result(shift_result_ex));
	
	 //store:MemWrite
	wire [1:0]n;
	assign Address={alu_result_ex[31:2],2'b00};
	assign n=alu_result_ex[1:0];
	assign Write_data=
		(ls_type_ex==3'b000)?{4{reg_read_data2_ex[7:0]}}:
		(ls_type_ex==3'b001)?{2{reg_read_data2_ex[15:0]}}:
		(ls_type_ex==3'b010)?reg_read_data2_ex:32'b0;
		
	assign Write_strb=
		(ls_type_ex==3'b000)?((n==0)?4'b0001:(n==1)?4'b0010:
			(n==2)?4'b0100:(n==3)?4'b1000:4'b0000):
		(ls_type_ex==3'b001)?((n==0)?4'b0011:(n==2)?4'b1100:4'b0000):
		(ls_type_ex==3'b010)?4'b1111:4'b0000;

	assign ex_to_mem_bus={
	pc_ex,ls_type_ex,mem_read_ex,//mem_write_ex,//32+3+1+1
	/*reg_read_data2_ex,*/alu_result_ex,shift_result_ex,//32+32+32
	RF_write_ex,RF_waddr_ex,RF_wdata_src_ex,//1+5+3
	lui_wdata_ex,auipc_wdata_ex,//32+32
	3'b000};

endmodule
