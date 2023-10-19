`timescale 10 ns / 1 ns
module mul(
	input clk,
	input rst,
	input [31:0]A,
	input [31:0]B,
	input run,
	output [31:0]result,
	output reg done
);
parameter INIT=		4'b0001,
	  ADD=		4'b0010,
	  SHIFT=	4'b0100,
	  OUTPUT=	4'b1000;
reg [3:0] current_state,next_state;
reg [65:0] a_reg,s_reg,p_reg,sum_reg;
reg [63:0] product;
reg [5:0] cnt;
wire[31:0] A_neg;

assign A_neg=~A+1;



always @(posedge clk)begin
	if(rst) current_state<=INIT;
	else current_state<=next_state;
end

always @(*)begin
	case(current_state)
		INIT:if(run) next_state=ADD;
			else next_state=INIT;
		ADD:next_state=SHIFT;
		SHIFT:if(cnt==32) next_state=OUTPUT;
			else next_state=ADD;
		OUTPUT:next_state=INIT;
		default:next_state=current_state;
	endcase
end

always @(posedge clk)begin
	if(rst)begin
		{a_reg,s_reg,p_reg,sum_reg,product,cnt,done}<=335'b0;
	end
	else begin
		if(current_state[0])begin
			a_reg<={A[31],A,{33{1'b0}}};
			s_reg<={A_neg[31],A_neg,{33{1'b0}}};
			p_reg<={{33{1'b0}},B,1'b0};
			cnt<=0;
			done<=1'b0;
		end
		else if(current_state[1])begin
			if(p_reg[1:0]==2'b01)
				sum_reg<=p_reg+a_reg;//add
			else if(p_reg[1:0]==2'b10)
				sum_reg<=p_reg+s_reg;//sub
			else if(p_reg[1:0]==2'b00)
				sum_reg<=p_reg;
			else if(p_reg[1:0]==2'b11)
				sum_reg<=p_reg;
			cnt<=cnt+1;
			
		end
		else if(current_state[2])begin
			p_reg<={sum_reg[65],sum_reg[65:1]};
		end
		else if(current_state[3])begin
			product<=p_reg[64:1];
			done<=1'b1;
		end
		
	end
end
assign result=product[31:0];

	
endmodule

