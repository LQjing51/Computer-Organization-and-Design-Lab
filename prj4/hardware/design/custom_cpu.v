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
		else if(current_state[4] && (opcode==7'b0100011 || opcode==7'b0000011))
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
		else if(current_state[4] && (PC_1 || PC_2 || PC_3))
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
		if(Read_data_Valid && Read_data_Ready)begin//
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
		if(current_state[3])begin//ID
			reg_read_data1_r<=reg_read_data1;
		end
		else begin
			reg_read_data1_r<=reg_read_data1_r;
		end
	end

	//reg_read_data2_r
	always @(posedge clk)begin
		if(current_state[3])begin//ID
			reg_read_data2_r<=reg_read_data2;
		end
		else begin
			reg_read_data2_r<=reg_read_data2_r;
		end
	end

	//alu_result_r
	always @(posedge clk)begin
		if(current_state[4])begin//EX
			alu_result_r<=alu_result;
		end
		else begin
			alu_result_r<=alu_result_r;
		end
	end

	//shift_result_r
	always @(posedge clk)begin
		if(current_state[4])begin//EX
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
	wire EX_WB;
	assign EX_WB=(opcode==7'b0110111 || opcode==7'b0010111 ||opcode==7'b1101111 
	|| opcode==7'b0010011 || opcode==7'b0110011 || opcode==7'b1100111);
	
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
			ID:		next_state=EX;
			EX:	if(opcode==7'b1100011)begin//branch
					next_state=IF;
				end
				else if(EX_WB)begin
					next_state=WB;
			//lui,auipc,jal,jalr,R-type-calculate,I-type-calculate
				end
				else if(opcode==7'b0100011)begin//store
					next_state=ST;
				end
				else if(opcode==7'b0000011)begin//load
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
	assign MemWrite=(current_state[5])?1:0;//ST

	//MemRead
	assign MemRead=(current_state[6])?1:0;//LD

	//Read_data_Ready
	assign Read_data_Ready=(current_state[0] || current_state[7])?1:0;//RST OR RDW


	wire [6:0]opcode;
	wire [4:0]rd;
	wire [2:0]funct3;
	wire [6:0]funct7;
	wire [4:0]rs1;
	wire [4:0]rs2;
	wire [4:0]shamt;
	wire [11:0]imm;
	wire [19:0]long_imm;

	assign opcode=Instruction_r[6:0];
	assign rd=Instruction_r[11:7];
	assign funct3=Instruction_r[14:12];
	assign rs1=Instruction_r[19:15];
	assign rs2=Instruction_r[24:20];
	assign shamt=Instruction_r[24:20];
	assign funct7=Instruction_r[31:25];
	assign imm=Instruction_r[31:20];
	assign long_imm=Instruction_r[31:12];
	

	//extend
	wire[31:0] sign_extend_imm;
	assign sign_extend_imm={{20{imm[11]}},imm};
	

	//probable PC 
	wire[31:0] Jump_address0;
	wire[31:0] Jump_address1;
	wire[31:0] Jump_address2;
	wire[31:0] Jump_address3;

	assign Jump_address0=PC_s+4;//else

	wire [20:0]pc_jal_offset;
	assign pc_jal_offset={Instruction_r[31],Instruction_r[19:12],
		Instruction_r[20],Instruction_r[30:21],1'b0};
	assign Jump_address1=PC_s+{{11{pc_jal_offset[20]}},pc_jal_offset}; //jal
	
	wire [31:0]pc_jalr_offset;
	assign pc_jalr_offset=sign_extend_imm+reg_read_data1_r;
	assign Jump_address2={pc_jalr_offset[31:1],1'b0};//jalr
	
	wire [12:0]pc_branch_offset;
	assign pc_branch_offset={Instruction_r[31],Instruction_r[7],
	Instruction_r[30:25],Instruction_r[11:8],1'b0};
	assign Jump_address3=PC_s+{{19{pc_branch_offset[12]}},pc_branch_offset};
	//blt,bltu,bge,bgeu,beq,bne

	//next PC
	wire PC_1;
	wire PC_2;
	wire PC_3;
	assign PC_1=(opcode==7'b1101111);//jal 
	assign PC_2=(opcode==7'b1100111);//jalr
	assign PC_3=
	(opcode==7'b1100011) && 
	((funct3==3'b000 && zero)||(funct3==3'b001 && !zero)
	||(funct3==3'b100 && !zero)||(funct3==3'b101 && zero)
	||(funct3==3'b110 && !zero) ||(funct3==3'b111 && zero)); 
	//bltz,bgez,beq,bne,blez,bgtz

	wire [31:0] next_PC;
	
	assign next_PC=(PC_1)?Jump_address1:(PC_2)?Jump_address2:
	(PC_3)?Jump_address3:Jump_address0;

	//register

	assign RF_waddr=rd;
	
	assign RF_wen=(opcode==7'b0110111 //lui
	|| opcode==7'b0010111 //auipc
	|| opcode==7'b1101111 //jal
	|| opcode==7'b1100111 //jalr
	|| opcode==7'b0000011 //load
	|| opcode==7'b0010011//calculate_i
	|| opcode==7'b0110011)//calculate_r
	&& current_state[8];
	
	wire alu_result_write;
	wire PC_write;
	wire shift_write;	

	assign alu_result_write=((opcode==7'b0010011) //calculate_i except shift
	|| (opcode==7'b0110011)) && (funct3!=3'b001 && funct3!=3'b101); //calculate_r except shift
	//register write data=alu result:R-type-calculate or I-type-calculate
	
	assign PC_write=(opcode==7'b1101111) //jal
	|| (opcode==7'b1100111);//jalr
	//register write data=PC+4:jalr or jal
	
	
	assign shift_write=((opcode==7'b0010011) //shift of calculate_i
	|| (opcode==7'b0110011)) && (funct3==3'b001 || funct3==3'b101); //shift of calculate_r
	//register write data=shift result

	wire [31:0]lui_wdata;
	assign lui_wdata={long_imm,12'b0};

	wire [31:0]auipc_wdata;
	assign auipc_wdata=PC_s+lui_wdata;

	assign RF_wdata=alu_result_write?alu_result_r://R-type-calculate or I-type-calculate 
	PC_write?PC_s+4://jal or jalr
	shift_write?shift_result_r://R or I shift
	(opcode==7'b0110111)?lui_wdata://lui
	(opcode==7'b0010111)?auipc_wdata://auipc
	modified_read_data;

	
	wire [31:0]reg_read_data1;//reg_read_data1=R[rs1]
	wire [31:0]reg_read_data2;//reg_read_data2=R[rs2]
	
	reg_file my_reg_file(.clk(clk),.rst(rst),.waddr(RF_waddr),.raddr1(rs1),.raddr2(rs2),
.wen(RF_wen),.wdata(RF_wdata),.rdata1(reg_read_data1),.rdata2(reg_read_data2));
	
	//ALU		
	wire [2:0]ALUop;
	wire [2:0]ALUop1;
	wire [2:0]ALUop2;
	
	assign ALUop1=
	(funct3==3'b000 && opcode==7'b0110011 && funct7[5])?3'b110://sub
	(funct3==3'b000)?3'b010://add
	(funct3==3'b010)?3'b111://slt
	(funct3==3'b011)?3'b011://sltu
	(funct3==3'b100)?3'b100://xor
	(funct3==3'b110)?3'b001://or
	(funct3==3'b111)?3'b000:3'b000;//and
	//I-type-calculate or R-type-calculate	

	assign ALUop2=(funct3[2:1]==2'b00)?3'b110://sub//beq,bne
	(funct3[2:1]==2'b10)?3'b111://slt//blt,bge
	(funct3[2:1]==2'b11)?3'b011:3'b000;//sltu//bltu,bgeu
	
	assign ALUop=(opcode==7'b1100011)?ALUop2:
	(opcode==7'b0110011 || opcode==7'b0010011)?ALUop1:3'b000;

	wire [31:0]A;
	wire [31:0]B;

	assign A=reg_read_data1_r;//A=R[rs1]
	assign B=(opcode==7'b0010011)?sign_extend_imm:reg_read_data2_r;//B=R[rs2] or sign_extend_imm

	wire Overflow;
	wire Carryout;
	wire zero;
	wire[31:0] alu_result;
	alu my_alu(.A(A),.B(B),.ALUop(ALUop),.Overflow(Overflow),
.CarryOut(CarryOut),.Zero(zero),.Result(alu_result));
	
	//Data memory
	wire [1:0]n_s;
	wire [31:0]initial_address_s;
	wire [31:0]ef_address_s;
	wire [11:0]offset_s;
	wire [31:0]extend_offset_s;
	assign offset_s={Instruction_r[31:25],Instruction_r[11:7]};
	assign extend_offset_s={{20{offset_s[11]}},offset_s};
	assign initial_address_s=reg_read_data1_r+extend_offset_s;
	assign ef_address_s={initial_address_s[31:2],2'b0};
	assign n_s=initial_address_s[1:0];

	wire [1:0]n_l;
	wire [31:0]initial_address_l;
	wire [31:0]ef_address_l;
	assign initial_address_l=reg_read_data1_r+sign_extend_imm;
	assign ef_address_l={initial_address_l[31:2],2'b0};
	assign n_l=initial_address_l[1:0];

	assign Address=(opcode==7'b0000011)?ef_address_l://load
	(opcode==7'b0100011)?ef_address_s:32'b0;//store

	//load:Memread
	wire [31:0]lb_data;
	assign lb_data=(n_l==0)?{{24{Read_data_r[7]}},Read_data_r[7:0]}:
	(n_l==1)?{{24{Read_data_r[15]}},Read_data_r[15:8]}:
	(n_l==2)?{{24{Read_data_r[23]}},Read_data_r[23:16]}:
	(n_l==3)?{{24{Read_data_r[31]}},Read_data_r[31:24]}:31'b0;

	wire [31:0]lh_data;
	assign lh_data=(n_l==0)?{{16{Read_data_r[15]}},Read_data_r[15:0]}:
	(n_l==2)?{{16{Read_data_r[31]}},Read_data_r[31:16]}:31'b0;

	wire [31:0]lbu_data;
	assign lbu_data=(n_l==0)?{24'b0,Read_data_r[7:0]}:
	(n_l==1)?{24'b0,Read_data_r[15:8]}:
	(n_l==2)?{24'b0,Read_data_r[23:16]}:
	(n_l==3)?{24'b0,Read_data_r[31:24]}:31'b0;

	wire [31:0]lhu_data;
	assign lhu_data=(n_l==0)?{16'b0,Read_data_r[15:0]}:
	(n_l==2)?{16'b0,Read_data_r[31:16]}:31'b0;

	wire [31:0] modified_read_data;
	assign modified_read_data=(funct3==3'b000)?lb_data:
	(funct3==3'b001)?lh_data:
	(funct3==3'b010)?Read_data_r:
	(funct3==3'b100)?lbu_data:
	(funct3==3'b101)?lhu_data:32'b0;

	//store:MemWrite
	
	assign Write_data=
		(funct3==3'b000)?{4{reg_read_data2_r[7:0]}}:
		(funct3==3'b001)?{2{reg_read_data2_r[15:0]}}:
		(funct3==3'b010)?reg_read_data2_r:32'b0;
		
	assign Write_strb=
		(funct3==3'b000)?((n_s==0)?4'b0001:(n_s==1)?4'b0010:
			(n_s==2)?4'b0100:(n_s==3)?4'b1000:4'b0000):
		(funct3==3'b001)?((n_s==0)?4'b0011:(n_s==2)?4'b1100:4'b0000):
		(funct3==3'b010)?4'b1111:4'b0000;
	

	//shifter
	wire [31:0]shift_result;
	wire [1:0]Shiftop;
	wire [31:0]A1;
	wire [31:0]B1;
	
	assign Shiftop=(funct3==3'b001)?2'b00:
	(funct3==3'b101 && !funct7[5])?2'b10:
	(funct3==3'b101 && funct7[5])?2'b11:2'b00;
	//00:left, 11:algorithem right,10:logical right
	
	assign A1=reg_read_data1_r;//R[rs1]
	assign B1=(opcode==7'b0010011)? {27'b0,shamt}:
	{27'b0,reg_read_data2_r[4:0]};//shamt or r[rs2][4:0]
	shifter my_shifter(.A(A1),.B(B1),.Shiftop(Shiftop),.Result(shift_result));

endmodule


