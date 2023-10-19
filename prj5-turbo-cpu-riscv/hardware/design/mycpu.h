`ifndef MYCPU_H
	`define MYCPU_H

	`define IF_TO_ID_BUS_WD 64
	`define ID_TO_EX_BUS_WD 244
	`define EX_TO_MEM_BUS_WD 176
	`define MEM_TO_WB_BUS_WD 70//32+1+5+32
	`define WB_TO_RF_BUS_WD 38//1+5+32
	`define BR_BUS_WD 33//1+32
	`define READ_AFTER_WRITE_BUS_WD 39//1+1+5+32
`endif
