`timescale 10ns / 1ns

module custom_cpu(
	input  rst,
	input  clk,

	//Instruction request channel
	output reg [31:0] PC,
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
	wire			RF_wen;
	wire [4:0]		RF_waddr;
	wire [31:0]		RF_wdata;
  //TODO: Please add your RISC-V CPU code here
	localparam RST =9'b000000001;//0
	localparam IF  =9'b000000010;//1
	localparam IW  =9'b000000100;//2
	localparam ID  =9'b000001000;//3
	localparam EX  =9'b000010000;//4
	localparam ST  =9'b000100000;//5
	localparam LD  =9'b001000000;//6
	localparam RDW =9'b010000000;//7
	localparam WB  =9'b100000000;//8

	wire [5:0]opcode;
	wire [4:0]rs;
	wire [4:0]rt;
	wire [4:0]rd;
	wire [4:0]shamt;
	wire [5:0]func;
	wire [15:0]imm;

	assign opcode=Instruction_r[31:26];
	assign rs=Instruction_r[25:21];
	assign rt=Instruction_r[20:16];
	assign rd=Instruction_r[15:11];
	assign shamt=Instruction_r[10:6];
	assign func=Instruction_r[5:0];
	assign imm=Instruction_r[15:0];
	
	reg [31:0] cycle_cnt;
	always @(posedge clk)
	begin
		if(rst==1'b1)
			cycle_cnt <=32'd0;
		else
			cycle_cnt<=cycle_cnt+32'd1;
	end
	assign cpu_perf_cnt_0=cycle_cnt;
	
	reg [31:0] instruction_cnt;
	always @(posedge clk)
	begin
		if(rst==1'b1)
			instruction_cnt <=32'd0;
		else if(current_state[3])
			instruction_cnt<=instruction_cnt+32'd1;
		else
			instruction_cnt<=instruction_cnt;		
	end
	assign cpu_perf_cnt_1=instruction_cnt;

	
	reg [31:0] store_or_load_cnt;
	always @(posedge clk)
	begin
		if(rst==1'b1)
			store_or_load_cnt <=32'd0;
		else if(current_state[4] && ((opcode[5] && opcode[3]) || (opcode[5] && ~opcode[3])))
			store_or_load_cnt<=store_or_load_cnt+32'd1;
		else
			store_or_load_cnt<=store_or_load_cnt;
	end
	assign cpu_perf_cnt_2=store_or_load_cnt;


	reg [31:0] pc_change_cnt;
	always @(posedge clk)
	begin
		if(rst==1'b1)
			pc_change_cnt <=32'd0;
		else if(current_state[4] && (PC_r || PC_1 || PC_2))
			pc_change_cnt<=pc_change_cnt+32'd1;
		else
			pc_change_cnt<=pc_change_cnt;
	end
	assign cpu_perf_cnt_3=pc_change_cnt;

	//state
	reg [8:0] current_state;
	reg [8:0] next_state;
	
	
	reg [31:0]Instruction_r;
	reg [31:0]Read_data_r;
	reg [31:0]PC_s;
	reg [31:0]reg_read_data1_r;
	reg [31:0]reg_read_data2_r;
	reg [31:0]alu_result_r;
	reg [31:0]shift_result_r;
	
	//PC
	always @(posedge clk)begin
		if(rst)begin
			PC<=32'b0;
		end
		else if(current_state[4]) begin//EX
			PC<=next_PC;
		end
		else if(current_state[3]) begin//ID
			PC<=(Instruction_r==32'b0)?PC+4:PC;
		end	
		else begin
			PC<=PC;
		end
	end

	//Instruction_r
	always @(posedge clk)begin
		if(Inst_Valid && Inst_Ready)begin
			Instruction_r<=Instruction;
		end
		else begin
			Instruction_r<=Instruction_r;
		end	
	end

	//Read_data_r
	always @(posedge clk)begin
		if(Read_data_Valid && Read_data_Ready)begin
			Read_data_r<=Read_data;
		end
		else begin
			Read_data_r<=Read_data_r;
		end
	end

	//PC_s
	always @(posedge clk)begin
		if(current_state[1])begin//IF
			 PC_s<=PC;
		end
		else begin
			PC_s<=PC_s;
		end
	end
	
	//reg_read_data1_r
	always @(posedge clk)begin
		if(current_state[3])begin
			reg_read_data1_r<=reg_read_data1;
		end
		else begin
			reg_read_data1_r<=reg_read_data1_r;
		end
	end

	//reg_read_data2_r
	always @(posedge clk)begin
		if(current_state[3])begin
			reg_read_data2_r<=reg_read_data2;
		end
		else begin
			reg_read_data2_r<=reg_read_data2_r;
		end
	end

	//alu_result_r
	always @(posedge clk)begin
		if(current_state[4])begin
			alu_result_r<=alu_result;
		end
		else begin
			alu_result_r<=alu_result_r;
		end
	end

	//shift_result_r
	always @(posedge clk)begin
		if(current_state[4])begin
			shift_result_r<=shift_result;
		end
		else begin
			shift_result_r<=shift_result_r;
		end
	end
	//state 
	always @(posedge clk)begin
		if(rst)begin
			current_state<=RST;
		end
		else begin
			current_state<=next_state;
		end
	end

	//next_state
	wire EX_IF;;
	assign EX_IF=(opcode[5:0]==6'b000001 || opcode[5:2]==4'b0001 || opcode[5:0]==6'b000010);
	wire EX_WB;
	assign EX_WB=(opcode[5:0]==6'b000000 || opcode[5:3]==3'b001 ||opcode[5:0]==6'b000011);
	
	always @(*)begin
		case(current_state)
			RST:	next_state=IF;
			IF:	if(Inst_Req_Ready)begin
					next_state=IW;
				end
				else begin
					next_state=IF;
				end
			IW:	if(Inst_Valid)begin
					next_state=ID;
				end
				else begin
					next_state=IW;
				end
			ID:	if(Instruction_r==32'b0)begin
					next_state=IF;
				end
				else begin
					next_state=EX;
				end
			EX:	if(EX_IF)begin
					next_state=IF;
				end
				else if(EX_WB)begin
					next_state=WB;
				end
				else if(opcode[5] && opcode[3])begin
					next_state=ST;
				end
				else if(opcode[5] && ~opcode[3])begin
					next_state=LD;
				end
			ST:	if(Mem_Req_Ready)begin
					next_state=IF;
				end
				else begin 
					next_state=ST;
				end
			LD:	if(Mem_Req_Ready)begin
					next_state=RDW;
				end
				else begin
					next_state=LD;
				end
			RDW:	if(Read_data_Valid)begin
					next_state=WB;
				end
				else begin
					next_state=RDW;
				end
			WB:	next_state=IF;
			default:next_state=current_state;
		endcase
	end
	wire Inst_Req_Valid;
	wire Inst_Ready;
	wire MemWrite;
	wire MemRead;
	wire Read_data_Ready;
	
	//Inst_Req_Valid
	assign Inst_Req_Valid=(current_state[1])?1:0;//IF

	//Inst_Ready
	assign Inst_Ready=(current_state[0] || current_state[2])?1:0;//RST OR IW
	
	//MemWrite
	assign MemWrite=(current_state[5] && opcode[5] && opcode[3])?1:0;//ST

	//MemRead
	assign MemRead=(current_state[6] && opcode[5] && ~opcode[3])?1:0;//LD

	//Read_data_Ready
	assign Read_data_Ready=(current_state[0] || current_state[7])?1:0;//RST OR RDW

	//extend
	wire[31:0] sign_extend_imm;
	wire[31:0] zero_extend_imm;	
	assign sign_extend_imm={{16{imm[15]}},imm};
	assign zero_extend_imm={16'b0,imm};

	//probable PC 
	wire[31:0] Jump_address0;
	wire[31:0] Jump_address1;
	wire[31:0] Jump_address2;
	assign Jump_address0=PC_s+4;//else
	assign Jump_address1={Jump_address0[31:28],Instruction_r[25:0],2'b00}; //j,jal
	assign Jump_address2=Jump_address0+{{14{imm[15]}},imm,2'b00};
	//bltz,bgez,beq,bne,blez,bgtz

	//next PC
	wire PC_r;
	wire PC_1;
	wire PC_2;
	assign PC_r=(opcode==6'b000000 && {func[5:3],func[1]}==4'b0010);//jr,jalr
	assign PC_1=(opcode[5:1]==5'b00001);//j,jal
	assign PC_2=
	(opcode==6'b000001 && ((rt[0]==0 && !zero)||(rt[0]==1 && zero))) 
	|| (opcode==6'b000100 && zero) 
	|| (opcode==6'b000101 && !zero) 
	|| (opcode==6'b000110 && (!zero || reg_read_data1_r==32'b0)) 
	|| (opcode==6'b000111 && (zero && reg_read_data1_r!=32'b0));
	//bltz,bgez,beq,bne,blez,bgtz

	wire [31:0]next_PC;
	
	assign next_PC=(PC_r)?reg_read_data1_r:(PC_1)?Jump_address1:(PC_2)?Jump_address2:Jump_address0;


	wire rd_write;
	wire rt_write;
	
	assign rd_write=(opcode==6'b000000 && func!=6'b001000);
	// register write address=rd:all R-type instruction except jr
	
	assign rt_write=(opcode[5:3]==3'b001 || (opcode[5]&(~opcode[3])) );
	//register write address=rt:load or I-type-calculate
	
	assign RF_waddr=
	rd_write?rd:
	rt_write?rt:
	(opcode==6'b000011)?5'b11111:5'b00000;//rd or rt or 31(jal)

	assign RF_wen=
	((rd_write && (({func[5:3],func[1]}!=4'b0011) 
	|| (func[0]==0 && zero==1) || (func[0]==1 && zero==0))) 
	|| (rt_write) 
	|| (opcode==6'b000011))
	&& current_state[8];
	//R-type(when it is move instruction,write when:movez when zero=1;moven when zero=0) 
	//or load or I-type-calculate or jal
	
	wire alu_result_write;
	wire PC_write;
	wire reg_data_write;
	wire shift_write;	

	assign alu_result_write=(opcode==6'b000000 && func[5]==1'b1) 
	|| (opcode[5:3]==3'b001 && opcode!=6'b001111); 
	//register write data=alu result:R-type-calculate or I-type-calculate except lui
	
	assign PC_write=(opcode==6'b000000 && func==6'b001001) 
	|| (opcode==6'b000011);
	//register write data=PC:jalr or jal
	
	assign reg_data_write=(opcode==6'b000000 && {func[5:3],func[1]}==4'b0011);
	//register write data=R[rs]:R-type-move(movez,moven)
	
	assign shift_write=(opcode==6'b000000 && func[5:3]==3'b000);
	//register write data=shift result:R-type-shift

	assign RF_wdata=alu_result_write?alu_result_r:
	PC_write?PC_s+8:
	reg_data_write?reg_read_data1_r:
	shift_write?shift_result_r:
	(opcode==6'b001111)?{imm,16'b0}:
	modified_read_data;
	//alu_result_r or PC+8 or R[rs] or shift_result_r or lui or Memory_read_data
	
	wire [31:0]reg_read_data1;//reg_read_data1=R[rs]
	wire [31:0]reg_read_data2;//reg_read_data2=R[rt]
	
	reg_file my_reg_file(.clk(clk),.rst(rst),.waddr(RF_waddr),.raddr1(rs),.raddr2(rt),
.wen(RF_wen),.wdata(RF_wdata),.rdata1(reg_read_data1),.rdata2(reg_read_data2));
	
	//ALU		
	wire [2:0]ALUop;
	wire [2:0]ALUop1;
	wire [2:0]ALUop2;
	
	assign ALUop1=(func[3:2]==2'b00)?{func[1],2'b10}:
	(func[3:2]==2'b01)?{func[1],1'b0,func[0]}:
	(func[3:2]==2'b10)?{~func[0],2'b11}:3'b000;
	//R-type-calculate code

	assign ALUop2=(opcode[2:1]==2'b00)?{opcode[1],2'b10}:
	(opcode[2]==1'b1)?{opcode[1],1'b0,opcode[0]}:
	(opcode[2:1]==2'b01)?{~opcode[0],2'b11}:3'b000;
	//I-type-calculate code

	assign ALUop=(opcode==6'd000000 && func[5]==1'b1)?ALUop1:
	(opcode[5:3]==3'b001)?ALUop2:
	(opcode==6'b000001 || opcode[5:1]==5'b00011)?3'b111:
	(opcode[5:1]==5'b00010 
	|| (opcode==6'd000000 && {func[5:3],func[1]}==4'b0011))?3'b110:	
	(opcode[5])?3'b010:3'b000;
	//R-type-calculate or I-type-calculate or bltz,bgez,blez,bgtz 
	//or beq,bne,movez,moven or load,store

	wire sign_in;
	wire zero_in;
	wire move;
	wire b_rt_0;
	wire [31:0]A;
	wire [31:0]B;

	assign sign_in=(opcode[5] || opcode[5:2]==4'b0010);//store or load or slti,sltiu,addiu
	assign zero_in=opcode[5:2]==4'b0011; //andi,ori,xori
	assign move=(opcode==6'b000000 && {func[5:3],func[1]}==4'b0011);//R-type-move
	assign b_rt_0=(opcode[5:1]==5'b00011 || opcode[5:0]==6'b000001);
	assign A=move?reg_read_data2_r:reg_read_data1_r;//if move A=R[rt] else A=R[rs]
	assign B=sign_in?sign_extend_imm:
		zero_in?zero_extend_imm:
		(move || b_rt_0)?32'b0:
		reg_read_data2_r;

	wire Overflow;
	wire Carryout;
	wire zero;
	wire[31:0] alu_result;
	alu my_alu(.A(A),.B(B),.ALUop(ALUop),.Overflow(Overflow),
.CarryOut(CarryOut),.Zero(zero),.Result(alu_result));
	
	//Data memory
	wire [1:0]n;
	assign n=alu_result_r[1:0];

	assign Address={alu_result_r[31:2],2'b00};

	wire [3:0]mask;//lw,lwl,lwr
	assign mask=
		(opcode[2]==1'b0)?((n==0)?4'b1000:(n==1)?4'b1100:(n==2)?4'b1110:(n==3)?4'b1111:4'b0000):
		(opcode[2]==1'b1)?((n==0)?4'b1111:(n==1)?4'b0111:(n==2)?4'b0011:(n==3)?4'b0001:4'b0000):4'b0000;
	
	wire[31:0]shift_read_data;
	assign shift_read_data=
		(opcode[2]==1'b0)?((n==0)?Read_data_r<<24:(n==1)?Read_data_r<<16:(n==2)?Read_data_r<<8:(n==3)?Read_data_r:32'b0):
		(opcode[2]==1'b1)?((n==0)?Read_data_r:(n==1)?Read_data_r>>8:(n==2)?Read_data_r>>16:(n==3)?Read_data_r>>24:32'b0):32'b0;

	//lw,lwl,lwr	
	wire[7:0] byte_0;
	wire[7:0] byte_1;
	wire[7:0] byte_2;
	wire[7:0] byte_3;
	assign byte_0=mask[0]?shift_read_data[7:0]:reg_read_data2_r[7:0];
	assign byte_1=mask[1]?shift_read_data[15:8]:reg_read_data2_r[15:8];
	assign byte_2=mask[2]?shift_read_data[23:16]:reg_read_data2_r[23:16];
	assign byte_3=mask[3]?shift_read_data[31:24]:reg_read_data2_r[31:24];
	
	wire [7:0]select_byte;//lb,lbu,
	assign select_byte=(n==0)?Read_data_r[7:0]:(n==1)?Read_data_r[15:8]:
			(n==2)?Read_data_r[23:16]:(n==3)?Read_data_r[31:24]:8'b0;

	wire [15:0]select_half;//lh,lhu
	assign select_half=(n==0)?Read_data_r[15:0]:(n==2)?Read_data_r[31:16]:16'b0;
	
	wire [31:0] modified_read_data;
	assign modified_read_data=
		(opcode[1:0]==2'b11)?Read_data_r:
		(opcode[2:0]==3'b000)?{{24{select_byte[7]}},select_byte}:	
                (opcode[2:0]==3'b001)?{{16{select_half[15]}},select_half}:
		(opcode[2:0]==3'b100)?{24'b0,select_byte}:
		(opcode[2:0]==3'b101)?{16'b0,select_half}: 
		{byte_3,byte_2,byte_1,byte_0};

	//MemWrite
	
	assign Write_data=
		(opcode[1:0]==2'b00)?{4{reg_read_data2_r[7:0]}}:
		(opcode[1:0]==2'b01)?{2{reg_read_data2_r[15:0]}}:
		(opcode[1:0]==2'b11)?reg_read_data2_r:
		(opcode[2]==0)?((n==0)?reg_read_data2_r>>24:(n==1)?reg_read_data2_r>>16:
			(n==2)?reg_read_data2_r>>8:(n==3)?reg_read_data2_r:32'b0):
		(opcode[2]==1)?((n==0)?reg_read_data2_r:(n==1)?reg_read_data2_r<<8:
			(n==2)?reg_read_data2_r<<16:(n==3)?reg_read_data2_r<<24:32'b0):32'b0;

	assign Write_strb=
		(opcode[1:0]==2'b00)?((n==0)?4'b0001:(n==1)?4'b0010:
			(n==2)?4'b0100:(n==3)?4'b1000:4'b0000):
		(opcode[1:0]==2'b01)?((n==0)?4'b0011:(n==2)?4'b1100:4'b0000):
		(opcode[1:0]==2'b11)?4'b1111:
		(opcode[2]==0)?((n==0)?4'b0001:(n==1)?4'b0011:
			(n==2)?4'b0111:(n==3)?4'b1111:4'b0000):
		(opcode[2]==1)?((n==0)?4'b1111:(n==1)?4'b1110:
			(n==2)?4'b1100:(n==3)?4'b1000:4'b0000):4'b0000;


	//shifter
	wire [31:0]shift_result;
	wire [1:0]Shiftop;
	wire [31:0]A1;
	wire [31:0]B1;
	
	assign Shiftop=(opcode==6'd000000 && func[5:3]==3'b000) ? func[1:0]:2'b01;
	//00:left, 11:algorithem right,10:logical right
	
	assign A1=reg_read_data2_r;//r[rt]
	assign B1=(func[2]==0)? {27'b0,shamt}:{27'b0,reg_read_data1_r[4:0]};//shamt or r[rs]
	shifter my_shifter(.A(A1),.B(B1),.Shiftop(Shiftop),.Result(shift_result));

endmodule

