`timescale 1ns / 1ns

module cpu_test
();

	reg				sys_clk;
    reg				sys_reset_n;

	initial begin
		sys_clk = 1'b0;
		sys_reset_n = 1'b0;
		# 100
		sys_reset_n = 1'b1;
	end

	always begin
		# 5 sys_clk = ~sys_clk;
	end

	always begin
		# 2000000 $display("Simulated %d ns", $time);
	end

	`define RST u_cpu_test.u_cpu_wrapper.u_cpu.rst

	`define MEM_WEN			u_cpu_test.u_cpu_wrapper.u_cpu.MemWrite
	`define MEM_ADDR		u_cpu_test.u_cpu_wrapper.u_cpu.Address
	`define MEM_WSTRB		u_cpu_test.u_cpu_wrapper.u_cpu.Write_strb
	`define MEM_WDATA		u_cpu_test.u_cpu_wrapper.u_cpu.Write_data
	`define MEM_READ		u_cpu_test.u_cpu_wrapper.u_cpu.MemRead
	`define MEM_REQ_READY	u_cpu_test.u_cpu_wrapper.u_cpu.Mem_Req_Ack

	`define RF_WEN	    u_cpu_test.u_cpu_wrapper.u_cpu.RF_wen
	`define RF_WADDR	u_cpu_test.u_cpu_wrapper.u_cpu.RF_waddr
	`define RF_WDATA	u_cpu_test.u_cpu_wrapper.u_cpu.RF_wdata

	`define RF_WEN_GOLDEN   u_cpu_test_golden.u_cpu_wrapper.u_cpu.reg_file.wen
	`define RF_WADDR_GOLDEN u_cpu_test_golden.u_cpu_wrapper.u_cpu.reg_file.waddr
	`define RF_WDATA_GOLDEN	u_cpu_test_golden.u_cpu_wrapper.u_cpu.reg_file.wdata

	`define INST_RETIRE_VALID_GOLDEN    u_cpu_test_golden.u_cpu_wrapper.u_cpu.inst_retire_valid
	`define PC_RETIRE_GOLDEN            u_cpu_test_golden.u_cpu_wrapper.u_cpu.pc_retire

	`define INST_RETIRE_VALID    u_cpu_test.u_cpu_wrapper.u_cpu.inst_retire_valid
	`define INST_RETIRED         u_cpu_test.u_cpu_wrapper.u_cpu.inst_retired

    cpu_test_top    u_cpu_test (
        .sys_clk		(sys_clk),
        .sys_reset_n	(sys_reset_n),

		.inst_retired_fifo_full (inst_retire_fifo_full)
    );

    cpu_test_top_golden    u_cpu_test_golden (
        .sys_clk		(sys_clk),
        .sys_reset_n	(sys_reset_n),

		.inst_retired_fifo_full  (inst_retire_fifo_golden_full)
    );

	wire inst_retire_fifo_full;
	wire inst_retire_fifo_empty;

	wire [133:0] inst_retired;

	fifo#(
		.DATA_WIDTH			(134),
		.ADDR_WIDTH			(8)
	) inst_retire_fifo (
		.clk				(sys_clk),
		.reset				(~sys_reset_n),
		.push				(`INST_RETIRE_VALID),
		.data_in			({$time, `INST_RETIRED}),
		.pop				(fifo_pop_out),
		.data_out			(inst_retired),
		.full				(inst_retire_fifo_full),
		.empty				(inst_retire_fifo_empty)
	);

	wire inst_retire_fifo_golden_full;
	wire inst_retire_fifo_golden_empty;

	wire [69:0] inst_retired_golden;

	fifo#(
		.DATA_WIDTH			(70),
		.ADDR_WIDTH			(8)
	) inst_retire_fifo_golden (
		.clk				(sys_clk),
		.reset				(~sys_reset_n),
		.push				(`INST_RETIRE_VALID_GOLDEN),
		.pop				(fifo_pop_out),
		.data_in			({`PC_RETIRE_GOLDEN, `RF_WEN_GOLDEN, `RF_WADDR_GOLDEN, `RF_WDATA_GOLDEN}),
		.data_out			(inst_retired_golden),
		.full				(inst_retire_fifo_golden_full),
		.empty				(inst_retire_fifo_golden_empty)
	);

	wire fifo_pop_out;
	reg fifo_pop_out_del;

	assign fifo_pop_out = (~inst_retire_fifo_golden_empty) & (~inst_retire_fifo_empty);

	always @(posedge sys_clk)
	begin
		if (sys_reset_n == 1'b0)
			fifo_pop_out_del <= 1'b0;
		else
			fifo_pop_out_del <= fifo_pop_out;
	end

	always @(posedge sys_clk)
	begin
		if (!`RST)
		begin
			if (fifo_pop_out_del == 1'b1)
			begin
				//compare retired PC first
				if (inst_retired_golden[69:38] !== inst_retired[69:38])
				begin
					$display("=================================================");
					$display("ERROR: at %dns.", inst_retired[133:70]);
					$display("Your retired inst.      PC = 0x%h", inst_retired[69:38]);
					$display("Reference retired inst. PC = 0x%h", inst_retired_golden[69:38]);
					$display("=================================================");
					$finish;
				end
				
				else if (inst_retired_golden[37] !== inst_retired[37])
				begin
					$display("=================================================");
					$display("ERROR: at %dns.", inst_retired[133:70]);
					$display("Your RF_wen in retired inst.      = 0x%h", inst_retired[37]);
					$display("Reference RF_wen in retired inst. = 0x%h", inst_retired_golden[37]);
					$display("=================================================");
					$finish;
				end

				else if ( inst_retired[37] & (inst_retired_golden[36:32] !== inst_retired[36:32]) )
				begin
					$display("=================================================");
					$display("ERROR: at %dns.", inst_retired[133:70]);
					$display("Your RF_waddr in retired inst.      = 0x%h", inst_retired[36:32]);
					$display("Reference RF_waddr in retired inst. = 0x%h", inst_retired_golden[36:32]);
					$display("=================================================");
					$finish;
				end

				else if ( inst_retired[37] & (inst_retired_golden[31:0] !== inst_retired[31:0] && inst_retired[31:0]!=32'bx) )
				begin
					$display("=================================================");
					$display("ERROR: at %dns.", inst_retired[133:70]);
					$display("Your RF_wdata in retired inst.      = 0x%h", inst_retired[31:0]);
					$display("Reference RF_wdata in retired inst. = 0x%h", inst_retired_golden[31:0]);
					$display("=================================================");
					$finish;
				end
			end
		end
	end

    reg [7:0] fifo_full_cnt; 
	always @(posedge sys_clk)
	begin
		if (sys_reset_n == 1'b0)
			fifo_full_cnt <= 'd0;

		else if ((~fifo_pop_out) & (inst_retire_fifo_golden_full | inst_retire_fifo_full))
		begin
			if (&fifo_full_cnt)
			begin
				fifo_full_cnt <= 'd0;
				$display("=================================================");
				$display("ERROR: Inst. retired FIFO of either DUT or golden model has been fully blocked for 256 cycles");
				$display("=================================================");
				$finish;
			end

			else
				fifo_full_cnt <= fifo_full_cnt + 'd1;
		end

		else
			fifo_full_cnt <= 'd0;
	end

	always @(posedge sys_clk)
	begin
		if(!`RST)
		begin
			if ((`MEM_WEN == 1'b1) & (`MEM_ADDR == 32'h0C) & (`MEM_WDATA == 32'h0))
			begin
`ifdef BHV_UART_SIMU
				# 30000000;
`endif
				$display("=================================================");
				$display("Benchmark simulation passed");
				$display("=================================================");
				$finish;
			end
		end
	end

