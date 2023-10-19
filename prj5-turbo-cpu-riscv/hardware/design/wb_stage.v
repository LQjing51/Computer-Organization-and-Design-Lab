

`timescale 10ns / 1ns
`include "mycpu.h"


module wb_stage(
    input                           clk           ,
    input                           reset         ,
	//BHV
	`ifdef BHV_SIM
	input inst_retired_fifo_full,
	output inst_retire_valid,
	output [69:0]inst_retired,
	`endif
    //allowin
    output                          wb_allow_in    ,
	//to id
	output [`READ_AFTER_WRITE_BUS_WD-1:0] wb_read_after_write_bus,
    //from mem
    input                           mem_to_wb_valid,
    input  [`MEM_TO_WB_BUS_WD -1:0]  mem_to_wb_bus  ,
    //to rf: for write back
    output [`WB_TO_RF_BUS_WD -1:0]  wb_to_rf_bus 
	
);

	reg         wb_valid;
	wire        wb_ready_go;
	wire write_valid;
	assign write_valid=wb_valid && RF_write_wb;
	assign wb_read_after_write_bus={write_valid,1'b1,RF_waddr_wb,RF_write_data_wb};
	
	`ifdef BHV_SIM
		assign wb_ready_go = !inst_retired_fifo_full;
	`else 
		assign wb_ready_go = 1'b1;	
	`endif
	assign wb_allow_in  = !wb_valid || wb_ready_go;
	always @(posedge clk) begin
		if (reset) begin
			wb_valid <= 1'b0;
		end
		else if (wb_allow_in) begin
			wb_valid <= mem_to_wb_valid;
		end

		if (mem_to_wb_valid && wb_allow_in) begin
			mem_to_wb_bus_r <= mem_to_wb_bus;
		end
	end

	reg [`MEM_TO_WB_BUS_WD -1:0] mem_to_wb_bus_r;
	wire [31:0]pc_wb;
	wire RF_write_wb;
	wire [31:0]RF_write_data_wb;
	wire [4:0]RF_waddr_wb;
	assign {pc_wb,RF_write_wb,RF_waddr_wb,RF_write_data_wb}=mem_to_wb_bus_r;
	
	assign wb_to_rf_bus={RF_write_wb && wb_valid,RF_waddr_wb,RF_write_data_wb};
	
	
	`ifdef BHV_SIM
		assign inst_retire_valid=wb_valid && !inst_retired_fifo_full;
		assign inst_retired={pc_wb,RF_write_wb,RF_waddr_wb,RF_write_data_wb};
	`endif

endmodule
