`timescale 10 ns / 1 ns

`define DATA_WIDTH 32

module alu(
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [2:0] ALUop,
	output Overflow,
	output CarryOut,
	output Zero,
	output [`DATA_WIDTH - 1:0] Result
);

	// TODO: Please add your logic code here
	wire op_and=ALUop==3'b000;
	wire op_or=ALUop==3'b001;
	wire op_add=ALUop==3'b010;
	wire op_sltu=ALUop==3'b011;
	wire op_xor=ALUop==3'b100;
	wire op_nor=ALUop==3'b101;
	wire op_sub=ALUop==3'b110;
	wire op_slt=ALUop==3'b111;	

	wire [`DATA_WIDTH - 1:0] and_res = A&B;
	wire [`DATA_WIDTH - 1:0] or_res = A|B;
	wire [`DATA_WIDTH - 1:0] xor_res = A^B;
	wire [`DATA_WIDTH - 1:0] nor_res = ~(A|B);
	wire [`DATA_WIDTH - 1:0] add_res; 
	wire [`DATA_WIDTH - 1:0] sub_res;
	wire [`DATA_WIDTH - 1:0] B1;
	wire Cin,cout;
	wire [`DATA_WIDTH - 1:0] res;
	assign B1=(ALUop[2]) ? ~B:B;	
	assign Cin=(ALUop[2]) ? 1:0;
	assign {cout,res}=A+B1+Cin;
	assign add_res=op_add?res:0;
	assign sub_res=(ALUop[2]) ? res:0;
	assign CarryOut=(ALUop[2]) ? !cout:cout;
	assign Overflow =( (op_add && ((A[31]==1 && B[31]==1 && add_res[31]==0)||(A[31]==0 && B[31]==0 && add_res[31]==1))) || (op_sub && ((A[31]==1 && B[31]==0 && sub_res[31]==0)||(A[31]==0 && B[31]==1 && sub_res[31]==1))) );
	
	wire less = (op_slt && ((A[31]==1 && B[31]==0) || (((A[31]==0 && B[31]==0)||(A[31]==1 && B[31]==1)) && sub_res[31]==1)));

	wire [32:0]A2;
	wire [32:0]B2;
	wire coutu;
	wire [32:0]resu;
	assign A2={1'b0,A};
	assign B2={1'b0,B};
	assign {coutu,resu}= A2+~B2+1;
	wire lessu = (op_sltu && resu[32]==1);
	wire [`DATA_WIDTH - 1:0] slt_res ={31'b0, less};
	wire [`DATA_WIDTH - 1:0] sltu_res ={31'b0, lessu};

	assign Result= {32{op_and}} & and_res | {32{op_or}} & or_res | {32{op_add}} & add_res | {32{op_sub}} & sub_res | {32{op_slt}} & slt_res | {32{op_nor}} & nor_res | {32{op_xor}} & xor_res | {32{op_sltu}} & sltu_res;
	
	assign Zero= (Result==32'b0);  
endmodule


