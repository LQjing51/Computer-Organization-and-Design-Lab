
`timescale 10ns / 1ns
`include "mycpu.h"


module id_stage(
    	input                          clk           ,
    	input                          reset         ,
    	//allow_in
   	input                          ex_allow_in    ,
    	output                         id_allow_in    ,
    	//from if
    	input                          if_to_id_valid,
    	input  [`IF_TO_ID_BUS_WD-1:0] if_to_id_bus  ,
   	//from ex
	input [`READ_AFTER_WRITE_BUS_WD-1:0] ex_read_after_write_bus,
	input [`READ_AFTER_WRITE_BUS_WD-1:0] mem_read_after_write_bus,
	input [`READ_AFTER_WRITE_BUS_WD-1:0] wb_read_after_write_bus,
    	//to ex
    	output                         id_to_ex_valid,
    	output [`ID_TO_EX_BUS_WD -1:0] id_to_ex_bus  ,
	//to if
	output to_if_valid,
	output [`BR_BUS_WD       -1:0] br_bus        ,
	//to rf: for write back
	input  [`WB_TO_RF_BUS_WD -1:0] wb_to_rf_bus

);

	wire ex_raw_addr_valid;
	wire ex_raw_data_valid;
	wire [4:0] ex_raw_addr;
	wire [31:0]ex_raw_data;

	wire mem_raw_addr_valid;
	wire mem_raw_data_valid;
	wire [4:0] mem_raw_addr;
	wire [31:0]mem_raw_data;

	wire wb_raw_addr_valid;
	wire wb_raw_data_valid;
	wire [4:0] wb_raw_addr;
	wire [31:0]wb_raw_data;
	assign {ex_raw_addr_valid,ex_raw_data_valid,ex_raw_addr,ex_raw_data}=ex_read_after_write_bus;
	assign {mem_raw_addr_valid,mem_raw_data_valid,mem_raw_addr,mem_raw_data}=mem_read_after_write_bus;
	assign {wb_raw_addr_valid,wb_raw_data_valid,wb_raw_addr,wb_raw_data}=wb_read_after_write_bus;

	wire rs1_from_ex;
	wire rs2_from_ex;
	wire rs1_from_mem;
	wire rs2_from_mem;
	wire rs1_from_wb;
	wire rs2_from_wb;
	wire rs1_from_rf;
	wire rs2_from_rf;
	
	assign rs1_from_ex=(|rs1) & ex_raw_addr_valid & (ex_raw_addr==rs1);
	assign rs2_from_ex=(|rs2) & ex_raw_addr_valid & (ex_raw_addr==rs2);
	assign rs1_from_mem=(|rs1) & ~rs1_from_ex & mem_raw_addr_valid & (mem_raw_addr==rs1);
	assign rs2_from_mem=(|rs2) & ~rs2_from_ex & mem_raw_addr_valid & (mem_raw_addr==rs2);
	assign rs1_from_wb=(|rs1) & ~rs1_from_ex & ~rs1_from_mem & wb_raw_addr_valid & (wb_raw_addr==rs1);
	assign rs2_from_wb=(|rs2) & ~rs2_from_ex & ~rs2_from_mem & wb_raw_addr_valid & (wb_raw_addr==rs2);
	assign rs1_from_rf=~(rs1_from_ex | rs1_from_mem | rs1_from_wb);
	assign rs2_from_rf=~(rs2_from_ex | rs2_from_mem | rs2_from_wb);

	wire [31:0]rs1_value;
	assign rs1_value=({32{rs1_from_ex}} & ex_raw_data)|
			({32{rs1_from_mem}} & mem_raw_data)|
			({32{rs1_from_wb}} & wb_raw_data)|
			({32{rs1_from_rf}} & reg_read_data1);

	wire [31:0]rs2_value;
	assign rs2_value=({32{rs2_from_ex}} & ex_raw_data)|
			({32{rs2_from_mem}} & mem_raw_data)|
			({32{rs2_from_wb}} & wb_raw_data)|
			({32{rs2_from_rf}} & reg_read_data2);



	reg         id_valid   ;
	assign to_if_valid=id_valid;
	wire        id_ready_go;
	assign id_ready_go    = 
!(!ex_raw_data_valid && (rs1_from_ex || rs2_from_ex) 
||!mem_raw_data_valid && (rs1_from_mem || rs2_from_mem) 
||!wb_raw_data_valid && (rs1_from_wb || rs2_from_wb) 
);
	assign id_allow_in     = !id_valid || id_ready_go && ex_allow_in;
	assign id_to_ex_valid = id_valid && id_ready_go;
	always @(posedge clk) begin
	    if (reset) begin
		id_valid <= 1'b0;
	    end
	    else if (id_allow_in) begin
		id_valid <= if_to_id_valid;
	    end
	end

	reg  [`IF_TO_ID_BUS_WD -1:0] if_to_id_bus_r;
	always @(posedge clk) begin
	    if (if_to_id_valid && id_allow_in) begin
		if_to_id_bus_r <= if_to_id_bus;
	    end
	end

	wire [31:0] id_inst;
	wire [31:0] id_pc  ;
	assign {id_inst,id_pc} = if_to_id_bus_r;

	wire        rf_we   ;
	wire [ 4:0] rf_waddr;
	wire [31:0] rf_wdata;
	assign {rf_we,rf_waddr,rf_wdata} = wb_to_rf_bus;//1+5+32

	wire        br_taken;
	wire [31:0] br_target;
	assign br_bus       = {br_taken,br_target};//1+32

	wire [6:0]opcode;
	wire [4:0]rd;
	wire [2:0]funct3;
	wire [6:0]funct7;
	wire [4:0]rs1;
	wire [4:0]rs2;
	wire [4:0]shamt;
	wire [11:0]imm;
	wire [19:0]long_imm;

	assign opcode=id_inst[6:0];
	assign rd=id_inst[11:7];
	assign funct3=id_inst[14:12];
	assign rs1=id_inst[19:15];
	assign rs2=id_inst[24:20];
	assign shamt=id_inst[24:20];
	assign funct7=id_inst[31:25];
	assign imm=id_inst[31:20];
	assign long_imm=id_inst[31:12];

	wire [31:0]store_offset;
	assign store_offset={{20{id_inst[31]}},id_inst[31:25],id_inst[11:7]}; 
	
	wire[31:0]sign_extend_imm;
	assign sign_extend_imm={{20{imm[11]}},imm};

	wire [31:0]branch_offset;
	assign branch_offset={{20{id_inst[31]}},id_inst[7],
	id_inst[30:25],id_inst[11:8],1'b0};
	
	wire [31:0]jalr_offset;
	assign jalr_offset=sign_extend_imm+rs1_value;
	
	wire [31:0]jal_offset;
	assign jal_offset={{12{id_inst[31]}},id_inst[19:12],
		id_inst[20],id_inst[30:21],1'b0};
	
	wire[31:0] Jump_address0;
	wire[31:0] Jump_address1;
	wire[31:0] Jump_address2;
	wire[31:0] Jump_address3;
	assign Jump_address0=id_pc+4;//else
	assign Jump_address1=id_pc+jal_offset; //jal
	assign Jump_address2={jalr_offset[31:1],1'b0};//jalr
	assign Jump_address3=id_pc+branch_offset;//blt,bltu,bge,bgeu,beq,bne

	assign br_target=(PC_jal)?Jump_address1:(PC_jalr)?Jump_address2:
	(PC_branch)?Jump_address3:Jump_address0;

	wire equal;
	assign equal=(rs1_value==rs2_value);

	wire less;
	wire [31:0]sub_res;
	assign sub_res=rs1_value-rs2_value;
	assign less=(rs1_value[31]==1 && rs2_value[31]==0) || (((rs1_value[31]==0 && rs2_value[31]==0)||(rs1_value[31]==1 && rs2_value[31]==1)) && sub_res[31]==1);

	wire less_u;
	wire [32:0]sub_res_u;
	wire [32:0]rs1_value_u;
	wire [32:0]rs2_value_u;
	assign rs1_value_u={1'b0,rs1_value};
	assign rs2_value_u={1'b0,rs2_value};
	assign sub_res_u=rs1_value_u-rs2_value_u;
	assign less_u=sub_res_u[32]==1;

	wire PC_jal;
	wire PC_jalr;
	wire PC_branch;
	assign PC_jal=(opcode==7'b1101111);//jal 
	assign PC_jalr=(opcode==7'b1100111);//jalr
	assign PC_branch=
	(opcode==7'b1100011) && 
	((funct3==3'b000 && equal)||(funct3==3'b001 && !equal)
	||(funct3==3'b100 && less)||(funct3==3'b101 && !less)
	||(funct3==3'b110 && less_u) ||(funct3==3'b111 && !less_u)); 
	//beq,bne,blt,bge,bltu,bgeu

	assign br_taken=(PC_jal || PC_jalr || PC_branch) && id_valid;
	
	wire mem_read_id;
	assign mem_read_id=(opcode==7'b0000011);//load

	wire mem_write_id;
	assign mem_write_id=(opcode==7'b0100011);//store

	//register
	wire [4:0]RF_waddr_id;
	wire RF_write_id;
	assign RF_waddr_id=rd;
	assign RF_write_id=(opcode==7'b0110111 //lui
	|| opcode==7'b0010111 //auipc
	|| opcode==7'b1101111 //jal
	|| opcode==7'b1100111 //jalr
	|| opcode==7'b0000011 //load
	|| opcode==7'b0010011//calculate_i
	|| opcode==7'b0110011);//calculate_r

	wire [31:0]lui_wdata_id;
	assign lui_wdata_id={long_imm,12'b0};

	wire [31:0]auipc_wdata_id;
	assign auipc_wdata_id=id_pc+lui_wdata_id;

	wire [2:0]RF_wdata_src_id;
	assign RF_wdata_src_id=(((opcode==7'b0010011) || (opcode==7'b0110011)) && (funct3!=3'b001 && funct3!=3'b101))? 3'b000://calculate_i except shift:alu_result
			((opcode==7'b1101111) || (opcode==7'b1100111))?3'b001://jal or jalr：PC_id+4
			(((opcode==7'b0010011) || (opcode==7'b0110011)) && (funct3==3'b001 || funct3==3'b101))?3'b010: //shift of calculate_i and shift of calculate_r:shift_result
			(opcode==7'b0110111)?3'b011://lui:lui_wdata
			(opcode==7'b0010111)?3'b100://auipc:auipc_wdata
			mem_read_id?3'b101:3'b000;//load:modified_read_data

	wire [31:0]reg_read_data1;//reg_read_data1=R[rs1]
	wire [31:0]reg_read_data2;//reg_read_data2=R[rs2]
	
	reg_file my_reg_file(.clk(clk),.rst(reset),.waddr(rf_waddr),.raddr1(rs1),.raddr2(rs2),
.wen(rf_we),.wdata(rf_wdata),.rdata1(reg_read_data1),.rdata2(reg_read_data2));
	
	//ALU
	//and:000  or:001   add:010  sltu:011 
	//xor:100  nor:101  sub:110 slt:111		
	wire [2:0]ALUop_id;
	assign ALUop_id=
	(funct3==3'b000 && opcode==7'b0110011 && funct7[5])?3'b110://sub
	(funct3==3'b000 || opcode==7'b0000011 || opcode==7'b0100011)?3'b010://add
	(funct3==3'b010)?3'b111://slt
	(funct3==3'b011)?3'b011://sltu
	(funct3==3'b100)?3'b100://xor
	(funct3==3'b110)?3'b001://or
	(funct3==3'b111)?3'b000:3'b000;//and
	//I-type-calculate or R-type-calculate,(opcode==7'b0110011 || opcode==7'b0010011)	

	wire [31:0]B_id;
	assign B_id=(opcode==7'b0100011)?store_offset:
	(opcode==7'b0010011 || opcode==7'b0000011)?sign_extend_imm:
	rs2_value;//store_offset:00;extend_imm:01;reg_read_data2:10
	
	//shift
	wire [1:0]Shiftop_id;
	assign Shiftop_id=(funct3==3'b001)?2'b00:
	(funct3==3'b101 && !funct7[5])?2'b10:
	(funct3==3'b101 && funct7[5])?2'b11:2'b00;//00:left, 11:algorithem right,10:logical right

	wire [31:0]B1_id;
	assign B1_id=(opcode==7'b0010011)? {27'b0,shamt}:
	{27'b0,rs2_value[4:0]};//shamt or r[rs2][4:0]
	
	wire [2:0]ls_type_id;
	assign ls_type_id=funct3;

	assign id_to_ex_bus={
	id_pc,ALUop_id,Shiftop_id,B_id,B1_id,//32+3+2+32+32
	rs1_value,rs2_value,//32+32
	RF_write_id,RF_waddr_id,lui_wdata_id,auipc_wdata_id,RF_wdata_src_id,//1+5+32+32+3
	mem_read_id,mem_write_id,ls_type_id,//1+1+3
	1'b0
	};
	
endmodule

