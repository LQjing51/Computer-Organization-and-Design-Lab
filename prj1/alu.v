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
	wire op_sub=ALUop==3'b110;
	wire op_slt=ALUop==3'b111;	

	wire [`DATA_WIDTH - 1:0] and_res = A&B;
	wire [`DATA_WIDTH - 1:0] or_res = A|B;
	wire [`DATA_WIDTH - 1:0] add_res; 
	//assign {CarryOut,add_res} = op_add? A+B:((op_sub || op_slt)? A+~B+1:{0,32'b0});
	wire [`DATA_WIDTH - 1:0] sub_res;
	//wire temp;
	//assign {temp,sub_res} = A+~B+1;
	wire [`DATA_WIDTH - 1:0] B1;
	wire Cin,cout;
	wire [`DATA_WIDTH - 1:0] res;
	assign B1=ALUop[2]?~B:B;	
	assign Cin=ALUop[2]?1:0;
	assign {cout,res}=A+B1+Cin;
	assign add_res=op_add?res:0;
	assign sub_res=ALUop[2]?res:0;
	assign CarryOut=ALUop[2]? !cout:cout;

	assign Overflow =( (op_add && ((A[31]==1 && B[31]==1 && add_res[31]==0)||(A[31]==0 && B[31]==0 && add_res[31]==1))) || (op_sub && ((A[31]==1 && B[31]==0 && sub_res[31]==0)||(A[31]==0 && B[31]==1 && sub_res[31]==1))) );
	
	wire less = (op_slt && ((A[31]==1 && B[31]==0) || (((A[31]==0 && B[31]==0)||(A[31]==1 && B[31]==1)) && sub_res[31]==1)));
	wire [`DATA_WIDTH - 1:0] slt_res ={31'b0, less};

	assign Result= {32{op_and}} & and_res | {32{op_or}} & or_res | {32{op_add}} & add_res | {32{op_sub}} & sub_res | {32{op_slt}} & slt_res;
	
	assign Zero= (Result==32'b0);  
endmodule
