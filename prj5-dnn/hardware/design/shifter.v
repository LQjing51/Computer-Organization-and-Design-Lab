`timescale 10 ns / 1 ns

`define DATA_WIDTH 32

module shifter (
	input [`DATA_WIDTH - 1:0] A,
	input [`DATA_WIDTH - 1:0] B,
	input [1:0] Shiftop,
	output [`DATA_WIDTH - 1:0] Result
);

	// TODO: Please add your logic code here
	wire [63:0] A1;
	wire [63:0] temp;
	wire [31:0] result;
	assign A1={{32{A[31]}},A};
	assign temp=A1>>B;
	assign result=temp[31:0];	
	assign Result= (Shiftop==2'b00) ? A<<B : (Shiftop==2'b11) ? result : (Shiftop==2'b10) ? A>>B : A;//{{B{A[31]}},A[31-B:0]}

endmodule
