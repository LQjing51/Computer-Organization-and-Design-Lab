`timescale 10 ns / 1 ns

`define DATA_WIDTH 32
`define ADDR_WIDTH 5

module reg_file(
	input clk,
	input rst,
	input [`ADDR_WIDTH - 1:0] waddr,
	input [`ADDR_WIDTH - 1:0] raddr1,
	input [`ADDR_WIDTH - 1:0] raddr2,
	input wen,
	input [`DATA_WIDTH - 1:0] wdata,
	output [`DATA_WIDTH - 1:0] rdata1,
	output [`DATA_WIDTH - 1:0] rdata2
);

	// TODO: Please add your logic code here

	reg [`DATA_WIDTH- 1:0] r [`DATA_WIDTH - 1:0];

	always @(posedge clk) begin
		//r[0]<=32'd0;
		if(wen && waddr!=5'd0)
			r[waddr] <= wdata;
	end

	assign rdata1 =raddr1==0?32'b0:r[raddr1];
	assign rdata2 =raddr2==0?32'b0:r[raddr2];	

endmodule
