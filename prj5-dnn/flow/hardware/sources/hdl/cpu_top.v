/* =========================================
* Top module wrapper of an accelerator role
*
* Author: Yisong Chang (changyisong@ict.ac.cn)
* Date: 29/01/2021
* Version: v0.0.1
*===========================================
*/

`timescale 10 ns / 1 ns

module cpu_top (
  input        role_clk,
  input        role_resetn,

  /* AXI4 master: 
  *  to SHELL DDR4 memory controller */
  output [39:0] axi_role_to_mem_araddr,
  output [1:0]  axi_role_to_mem_arburst,
  output [3:0]  axi_role_to_mem_arcache,
  output [7:0]  axi_role_to_mem_arlen,
  output [0:0]  axi_role_to_mem_arlock,
  output [2:0]  axi_role_to_mem_arprot,
  output [3:0]  axi_role_to_mem_arqos,
  input         axi_role_to_mem_arready,
  output [3:0]	axi_role_to_mem_arregion,
  output [2:0]	axi_role_to_mem_arsize,
  output        axi_role_to_mem_arvalid,
  output [39:0]	axi_role_to_mem_awaddr,
  output [1:0]	axi_role_to_mem_awburst,
  output [3:0]	axi_role_to_mem_awcache,
  output [7:0]	axi_role_to_mem_awlen,
  output [0:0]	axi_role_to_mem_awlock,
  output [2:0]	axi_role_to_mem_awprot,
  output [3:0]	axi_role_to_mem_awqos,
  input         axi_role_to_mem_awready,
  output [3:0]	axi_role_to_mem_awregion,
  output [2:0]	axi_role_to_mem_awsize,
  output        axi_role_to_mem_awvalid,
  output        axi_role_to_mem_bready,
  input [1:0]   axi_role_to_mem_bresp,
  input         axi_role_to_mem_bvalid,
  input [63:0] axi_role_to_mem_rdata,
  input         axi_role_to_mem_rlast,
  output        axi_role_to_mem_rready,
  input [1:0]   axi_role_to_mem_rresp,
  input         axi_role_to_mem_rvalid,
  output [63:0] axi_role_to_mem_wdata,
  output        axi_role_to_mem_wlast,
  input         axi_role_to_mem_wready,
  output [7:0]  axi_role_to_mem_wstrb,
  output        axi_role_to_mem_wvalid,

  /* AXI4-lite master: 
  *  to SHELL UART controller and etc. */
  output [31:0] axi_role_to_shell_araddr,
  output [2:0]  axi_role_to_shell_arprot,
  input         axi_role_to_shell_arready,
  output        axi_role_to_shell_arvalid,
  output [31:0] axi_role_to_shell_awaddr,
  output [2:0]  axi_role_to_shell_awprot,
  input         axi_role_to_shell_awready,
  output        axi_role_to_shell_awvalid,
  output        axi_role_to_shell_bready,
  input [1:0]   axi_role_to_shell_bresp,
  input         axi_role_to_shell_bvalid,
  input [31:0]  axi_role_to_shell_rdata,
  output        axi_role_to_shell_rready,
  input [1:0]   axi_role_to_shell_rresp,
  input         axi_role_to_shell_rvalid,
  output [31:0] axi_role_to_shell_wdata,
  input         axi_role_to_shell_wready,
  output [3:0]  axi_role_to_shell_wstrb,
  output        axi_role_to_shell_wvalid,

  /* AXI4-lite slave: 
  *  from SHELL to MMIO registers in role */
  input [19:0]  axi_shell_to_role_araddr,
  input [2:0]   axi_shell_to_role_arprot,
  output        axi_shell_to_role_arready,
  input         axi_shell_to_role_arvalid,
  input [19:0]  axi_shell_to_role_awaddr,
  input [2:0]   axi_shell_to_role_awprot,
  output        axi_shell_to_role_awready,
  input         axi_shell_to_role_awvalid,
  input         axi_shell_to_role_bready,
  output [1:0]  axi_shell_to_role_bresp,
  output        axi_shell_to_role_bvalid,
  output [31:0] axi_shell_to_role_rdata,
  input         axi_shell_to_role_rready,
  output [1:0]  axi_shell_to_role_rresp,
  output        axi_shell_to_role_rvalid,
  input [31:0]  axi_shell_to_role_wdata,
  output        axi_shell_to_role_wready,
  input [3:0]   axi_shell_to_role_wstrb,
  input         axi_shell_to_role_wvalid
);

  wire cpu_clk;
  wire cpu_clk_locked;
  wire cpu_ic_reset_n;
  wire cpu_reset_n;
  wire cpu_reset;

  wire [31:0]cpu_inst_araddr;
  wire [ 1:0]cpu_inst_arburst;
  wire [ 3:0]cpu_inst_arcache;
  wire [ 7:0]cpu_inst_arlen;
  wire [ 0:0]cpu_inst_arlock;
  wire [ 2:0]cpu_inst_arprot;
  wire [ 3:0]cpu_inst_arqos;
  wire [ 0:0]cpu_inst_arready;
  wire [ 2:0]cpu_inst_arsize;
  wire [ 0:0]cpu_inst_arvalid;
  wire [31:0]cpu_inst_rdata;
  wire [ 0:0]cpu_inst_rlast;
  wire [ 0:0]cpu_inst_rready;
  wire [ 1:0]cpu_inst_rresp;
  wire [ 0:0]cpu_inst_rvalid;

  wire [31:0]cpu_mem_araddr;
  wire [ 1:0]cpu_mem_arburst;
  wire [ 3:0]cpu_mem_arcache;
  wire [ 7:0]cpu_mem_arlen;
  wire [ 0:0]cpu_mem_arlock;
  wire [ 2:0]cpu_mem_arprot;
  wire [ 3:0]cpu_mem_arqos;
  wire [ 0:0]cpu_mem_arready;
  wire [ 2:0]cpu_mem_arsize;
  wire [ 0:0]cpu_mem_arvalid;
  wire [31:0]cpu_mem_awaddr;
  wire [ 1:0]cpu_mem_awburst;
  wire [ 3:0]cpu_mem_awcache;
  wire [ 7:0]cpu_mem_awlen;
  wire [ 0:0]cpu_mem_awlock;
  wire [ 2:0]cpu_mem_awprot;
  wire [ 3:0]cpu_mem_awqos;
  wire [ 0:0]cpu_mem_awready;
  wire [ 2:0]cpu_mem_awsize;
  wire [ 0:0]cpu_mem_awvalid;
  wire [ 0:0]cpu_mem_bready;
  wire [ 1:0]cpu_mem_bresp;
  wire [ 0:0]cpu_mem_bvalid;
  wire [31:0]cpu_mem_rdata;
  wire [ 0:0]cpu_mem_rlast;
  wire [ 0:0]cpu_mem_rready;
  wire [ 1:0]cpu_mem_rresp;
  wire [ 0:0]cpu_mem_rvalid;
  wire [31:0]cpu_mem_wdata;
  wire [ 0:0]cpu_mem_wlast;
  wire [ 0:0]cpu_mem_wready;
  wire [ 3:0]cpu_mem_wstrb;
  wire [ 0:0]cpu_mem_wvalid;

  wire [31:0]cpu_perf_cnt_araddr;
  wire [ 2:0]cpu_perf_cnt_arprot;
  wire [ 0:0]cpu_perf_cnt_arready;
  wire [ 0:0]cpu_perf_cnt_arvalid;
  wire [31:0]cpu_perf_cnt_awaddr;
  wire [ 2:0]cpu_perf_cnt_awprot;
  wire [ 0:0]cpu_perf_cnt_awready;
  wire [ 0:0]cpu_perf_cnt_awvalid;
  wire [ 0:0]cpu_perf_cnt_bready;
  wire [ 1:0]cpu_perf_cnt_bresp;
  wire [ 0:0]cpu_perf_cnt_bvalid;
  wire [31:0]cpu_perf_cnt_rdata;
  wire [ 0:0]cpu_perf_cnt_rready;
  wire [ 1:0]cpu_perf_cnt_rresp;
  wire [ 0:0]cpu_perf_cnt_rvalid;
  wire [31:0]cpu_perf_cnt_wdata;
  wire [ 0:0]cpu_perf_cnt_wready;
  wire [ 3:0]cpu_perf_cnt_wstrb;
  wire [ 0:0]cpu_perf_cnt_wvalid;

  wire [31:0]cpu_io_ctrl_araddr;
  wire [ 0:0]cpu_io_ctrl_arready;
  wire [ 0:0]cpu_io_ctrl_arvalid;
  wire [31:0]cpu_io_ctrl_awaddr;
  wire [ 0:0]cpu_io_ctrl_awready;
  wire [ 0:0]cpu_io_ctrl_awvalid;
  wire [ 0:0]cpu_io_ctrl_bready;
  wire [ 1:0]cpu_io_ctrl_bresp;
  wire [ 0:0]cpu_io_ctrl_bvalid;
  wire [31:0]cpu_io_ctrl_rdata;
  wire [ 0:0]cpu_io_ctrl_rready;
  wire [ 1:0]cpu_io_ctrl_rresp;
  wire [ 0:0]cpu_io_ctrl_rvalid;
  wire [31:0]cpu_io_ctrl_wdata;
  wire [ 0:0]cpu_io_ctrl_wready;
  wire [ 3:0]cpu_io_ctrl_wstrb;
  wire [ 0:0]cpu_io_ctrl_wvalid;

  wire [31:0]io_mem_araddr;
  wire [ 1:0]io_mem_arburst;
  wire [ 3:0]io_mem_arcache;
  wire [ 5:0]io_mem_arid;
  wire [ 7:0]io_mem_arlen;
  wire [ 0:0]io_mem_arlock;
  wire [ 2:0]io_mem_arprot;
  wire [ 3:0]io_mem_arqos;
  wire [ 0:0]io_mem_arready;
  wire [ 3:0]io_mem_arregion;
  wire [ 2:0]io_mem_arsize;
  wire [ 0:0]io_mem_arvalid;
  wire [31:0]io_mem_awaddr;
  wire [ 1:0]io_mem_awburst;
  wire [ 3:0]io_mem_awcache;
  wire [ 5:0]io_mem_awid;
  wire [ 7:0]io_mem_awlen;
  wire [ 0:0]io_mem_awlock;
  wire [ 2:0]io_mem_awprot;
  wire [ 3:0]io_mem_awqos;
  wire [ 0:0]io_mem_awready;
  wire [ 3:0]io_mem_awregion;
  wire [ 2:0]io_mem_awsize;
  wire [ 0:0]io_mem_awvalid;
  wire [ 5:0]io_mem_bid;
  wire [ 0:0]io_mem_bready;
  wire [ 1:0]io_mem_bresp;
  wire [ 0:0]io_mem_bvalid;
  wire [63:0]io_mem_rdata;
  wire [ 5:0]io_mem_rid;
  wire [ 0:0]io_mem_rlast;
  wire [ 0:0]io_mem_rready;
  wire [ 1:0]io_mem_rresp;
  wire [ 0:0]io_mem_rvalid;
  wire [63:0]io_mem_wdata;
  wire [ 0:0]io_mem_wlast;
  wire [ 0:0]io_mem_wready;
  wire [ 7:0]io_mem_wstrb;
  wire [ 0:0]io_mem_wvalid;

  wire [31:0]	cpu_perf_cnt_0;
  wire [31:0]	cpu_perf_cnt_1;
  wire [31:0]	cpu_perf_cnt_2;
  wire [31:0]	cpu_perf_cnt_3;
  wire [31:0]	cpu_perf_cnt_4;
  wire [31:0]	cpu_perf_cnt_5;
  wire [31:0]	cpu_perf_cnt_6;
  wire [31:0]	cpu_perf_cnt_7;
  wire [31:0]	cpu_perf_cnt_8;
  wire [31:0]	cpu_perf_cnt_9;
  wire [31:0]	cpu_perf_cnt_10;
  wire [31:0]	cpu_perf_cnt_11;
  wire [31:0]	cpu_perf_cnt_12;
  wire [31:0]	cpu_perf_cnt_13;
  wire [31:0]	cpu_perf_cnt_14;
  wire [31:0]	cpu_perf_cnt_15;

  wire [ 0:0] acc_done;
  wire [ 0:0] gpio_acc_start;

  cpu_fixed		u_cpu_fixed	(
    .axi_role_to_mem_araddr	(axi_role_to_mem_araddr[31:0]),
    .axi_role_to_mem_arburst	(axi_role_to_mem_arburst),
    .axi_role_to_mem_arcache	(axi_role_to_mem_arcache),
    .axi_role_to_mem_arlen	(axi_role_to_mem_arlen),
    .axi_role_to_mem_arlock	(axi_role_to_mem_arlock),
    .axi_role_to_mem_arprot	(axi_role_to_mem_arprot),
    .axi_role_to_mem_arqos	(axi_role_to_mem_arqos),
    .axi_role_to_mem_arready	(axi_role_to_mem_arready	),
    .axi_role_to_mem_arregion	(axi_role_to_mem_arregion	),
    .axi_role_to_mem_arsize	(axi_role_to_mem_arsize	),
    .axi_role_to_mem_arvalid	(axi_role_to_mem_arvalid	),
    .axi_role_to_mem_awaddr	(axi_role_to_mem_awaddr[31:0]),
    .axi_role_to_mem_awburst	(axi_role_to_mem_awburst	),
    .axi_role_to_mem_awcache	(axi_role_to_mem_awcache),
    .axi_role_to_mem_awlen	(axi_role_to_mem_awlen),
    .axi_role_to_mem_awlock	(axi_role_to_mem_awlock),
    .axi_role_to_mem_awprot	(axi_role_to_mem_awprot),
    .axi_role_to_mem_awqos	(axi_role_to_mem_awqos),
    .axi_role_to_mem_awready	(axi_role_to_mem_awready	),
    .axi_role_to_mem_awregion	(axi_role_to_mem_awregion	),
    .axi_role_to_mem_awsize	(axi_role_to_mem_awsize	),
    .axi_role_to_mem_awvalid	(axi_role_to_mem_awvalid	),
    .axi_role_to_mem_bready	(axi_role_to_mem_bready	),
    .axi_role_to_mem_bresp	(axi_role_to_mem_bresp),
    .axi_role_to_mem_bvalid	(axi_role_to_mem_bvalid),
    .axi_role_to_mem_rdata	(axi_role_to_mem_rdata),
    .axi_role_to_mem_rlast	(axi_role_to_mem_rlast),
    .axi_role_to_mem_rready	(axi_role_to_mem_rready),
    .axi_role_to_mem_rresp	(axi_role_to_mem_rresp),
    .axi_role_to_mem_rvalid	(axi_role_to_mem_rvalid),
    .axi_role_to_mem_wdata	(axi_role_to_mem_wdata),
    .axi_role_to_mem_wlast	(axi_role_to_mem_wlast),
    .axi_role_to_mem_wready	(axi_role_to_mem_wready),
    .axi_role_to_mem_wstrb	(axi_role_to_mem_wstrb),
    .axi_role_to_mem_wvalid	(axi_role_to_mem_wvalid ),

    .axi_shell_to_role_araddr	(axi_shell_to_role_araddr	),
    .axi_shell_to_role_arprot	(axi_shell_to_role_arprot	),
    .axi_shell_to_role_arready	(axi_shell_to_role_arready	),
    .axi_shell_to_role_arvalid	(axi_shell_to_role_arvalid	),
    .axi_shell_to_role_awaddr	(axi_shell_to_role_awaddr	),
    .axi_shell_to_role_awprot	(axi_shell_to_role_awprot	),
    .axi_shell_to_role_awready	(axi_shell_to_role_awready	),
    .axi_shell_to_role_awvalid	(axi_shell_to_role_awvalid	),
    .axi_shell_to_role_bready	(axi_shell_to_role_bready	),
    .axi_shell_to_role_bresp		(axi_shell_to_role_bresp		),
    .axi_shell_to_role_bvalid	(axi_shell_to_role_bvalid	),
    .axi_shell_to_role_rdata		(axi_shell_to_role_rdata		),
    .axi_shell_to_role_rready	(axi_shell_to_role_rready	),
    .axi_shell_to_role_rresp		(axi_shell_to_role_rresp		),
    .axi_shell_to_role_rvalid	(axi_shell_to_role_rvalid	),
    .axi_shell_to_role_wdata		(axi_shell_to_role_wdata		),
    .axi_shell_to_role_wready	(axi_shell_to_role_wready	),
    .axi_shell_to_role_wstrb		(axi_shell_to_role_wstrb		),
    .axi_shell_to_role_wvalid	(axi_shell_to_role_wvalid	),

    .axi_role_to_shell_araddr	(axi_role_to_shell_araddr	),
    .axi_role_to_shell_arprot	(axi_role_to_shell_arprot	),
    .axi_role_to_shell_arready	(axi_role_to_shell_arready	),
    .axi_role_to_shell_arvalid	(axi_role_to_shell_arvalid	),
    .axi_role_to_shell_awaddr	(axi_role_to_shell_awaddr	),
    .axi_role_to_shell_awprot	(axi_role_to_shell_awprot	),
    .axi_role_to_shell_awready	(axi_role_to_shell_awready	),
    .axi_role_to_shell_awvalid	(axi_role_to_shell_awvalid	),
    .axi_role_to_shell_bready	(axi_role_to_shell_bready	),
    .axi_role_to_shell_bresp		(axi_role_to_shell_bresp		),
    .axi_role_to_shell_bvalid	(axi_role_to_shell_bvalid	),
    .axi_role_to_shell_rdata		(axi_role_to_shell_rdata		),
    .axi_role_to_shell_rready	(axi_role_to_shell_rready	),
    .axi_role_to_shell_rresp		(axi_role_to_shell_rresp		),
    .axi_role_to_shell_rvalid	(axi_role_to_shell_rvalid	),
    .axi_role_to_shell_wdata		(axi_role_to_shell_wdata		),
    .axi_role_to_shell_wready	(axi_role_to_shell_wready	),
    .axi_role_to_shell_wstrb		(axi_role_to_shell_wstrb		),
    .axi_role_to_shell_wvalid	(axi_role_to_shell_wvalid	),

    .cpu_clk	(cpu_clk),
    .cpu_clk_locked	(cpu_clk_locked),
    .cpu_ic_reset_n	(cpu_ic_reset_n),

    .cpu_inst_araddr	(cpu_inst_araddr),
    .cpu_inst_arburst	(cpu_inst_arburst	),
    .cpu_inst_arcache	('d0),
    .cpu_inst_arlen		(cpu_inst_arlen		),
    .cpu_inst_arlock	('d0),
    .cpu_inst_arprot	('d0),
    .cpu_inst_arqos		('d0),
    .cpu_inst_arready	(cpu_inst_arready	),
    .cpu_inst_arregion	(),
    .cpu_inst_arsize	(cpu_inst_arsize	),
    .cpu_inst_arvalid	(cpu_inst_arvalid	),
    .cpu_inst_rdata		(cpu_inst_rdata		),
    .cpu_inst_rlast		(cpu_inst_rlast		),
    .cpu_inst_rready	(cpu_inst_rready	),
    .cpu_inst_rresp		(cpu_inst_rresp		),
    .cpu_inst_rvalid	(cpu_inst_rvalid	),

    .cpu_mem_araddr		(cpu_mem_araddr),
    .cpu_mem_arburst	(cpu_mem_arburst),
    .cpu_mem_arcache	('d0),
    .cpu_mem_arlen	(cpu_mem_arlen),
    .cpu_mem_arlock	('d0),
    .cpu_mem_arprot	('d0),
    .cpu_mem_arqos	('d0),
    .cpu_mem_arready	(cpu_mem_arready),
    .cpu_mem_arsize		(cpu_mem_arsize	),
    .cpu_mem_arvalid	(cpu_mem_arvalid),
    .cpu_mem_awaddr		(cpu_mem_awaddr),
    .cpu_mem_awburst	(cpu_mem_awburst),
    .cpu_mem_awcache	('d0),
    .cpu_mem_awlen		(cpu_mem_awlen	),
    .cpu_mem_awlock		('d0),
    .cpu_mem_awprot		('d0),
    .cpu_mem_awqos		('d0),
    .cpu_mem_awready	(cpu_mem_awready),
    .cpu_mem_awsize		(cpu_mem_awsize	),
    .cpu_mem_awvalid	(cpu_mem_awvalid),
    .cpu_mem_bready	(cpu_mem_bready),
    .cpu_mem_bresp	(cpu_mem_bresp ),
    .cpu_mem_bvalid	(cpu_mem_bvalid),
    .cpu_mem_rdata	(cpu_mem_rdata ),
    .cpu_mem_rlast	(cpu_mem_rlast ),
    .cpu_mem_rready	(cpu_mem_rready),
    .cpu_mem_rresp	(cpu_mem_rresp ),
    .cpu_mem_rvalid	(cpu_mem_rvalid),
    .cpu_mem_wdata	(cpu_mem_wdata ),
    .cpu_mem_wlast	(cpu_mem_wlast ),
    .cpu_mem_wready	(cpu_mem_wready),
    .cpu_mem_wstrb	(cpu_mem_wstrb ),
    .cpu_mem_wvalid	(cpu_mem_wvalid),

   /* .io_mem_araddr		(io_mem_araddr ),
    .io_mem_arburst		(io_mem_arburst),
    .io_mem_arcache		(io_mem_arcache),
    .io_mem_arid		(io_mem_arid   ),
    .io_mem_arlen		(io_mem_arlen  ),
    .io_mem_arlock		(io_mem_arlock ),
    .io_mem_arprot		(io_mem_arprot ),
    .io_mem_arqos		(io_mem_arqos  ),
    .io_mem_arready		(io_mem_arready),
    .io_mem_arregion	(io_mem_arregion),
    .io_mem_arsize		(io_mem_arsize ),
    .io_mem_arvalid		(io_mem_arvalid),
    .io_mem_awaddr		(io_mem_awaddr ),
    .io_mem_awburst		(io_mem_awburst),
    .io_mem_awcache		(io_mem_awcache),
    .io_mem_awid		(io_mem_awid   ),
    .io_mem_awlen		(io_mem_awlen  ),
    .io_mem_awlock		(io_mem_awlock ),
    .io_mem_awprot		(io_mem_awprot ),
    .io_mem_awqos		(io_mem_awqos  ),
    .io_mem_awready		(io_mem_awready),
    .io_mem_awregion	(io_mem_awregion),
    .io_mem_awsize		(io_mem_awsize	),
    .io_mem_awvalid		(io_mem_awvalid	),
    .io_mem_bid			(io_mem_bid		),
    .io_mem_bready		(io_mem_bready	),
    .io_mem_bresp		(io_mem_bresp	),
    .io_mem_bvalid		(io_mem_bvalid	),
    .io_mem_rdata		(io_mem_rdata	),
    .io_mem_rid			(io_mem_rid		),
    .io_mem_rlast		(io_mem_rlast	),
    .io_mem_rready		(io_mem_rready	),
    .io_mem_rresp		(io_mem_rresp	),
    .io_mem_rvalid		(io_mem_rvalid	),
    .io_mem_wdata		(io_mem_wdata	),
    .io_mem_wlast		(io_mem_wlast	),
    .io_mem_wready		(io_mem_wready	),
    .io_mem_wstrb		(io_mem_wstrb	),
    .io_mem_wvalid		(io_mem_wvalid	),*/

    .cpu_io_ctrl_araddr		(cpu_io_ctrl_araddr),
    .cpu_io_ctrl_arready		(cpu_io_ctrl_arready),
    .cpu_io_ctrl_arvalid		(cpu_io_ctrl_arvalid),
    .cpu_io_ctrl_awaddr		(cpu_io_ctrl_awaddr),
    .cpu_io_ctrl_awready		(cpu_io_ctrl_awready),
    .cpu_io_ctrl_awvalid		(cpu_io_ctrl_awvalid),
    .cpu_io_ctrl_bready		(cpu_io_ctrl_bready),
    .cpu_io_ctrl_bresp		(cpu_io_ctrl_bresp ),
    .cpu_io_ctrl_bvalid		(cpu_io_ctrl_bvalid),
    .cpu_io_ctrl_rdata		(cpu_io_ctrl_rdata ),
    .cpu_io_ctrl_rready		(cpu_io_ctrl_rready),
    .cpu_io_ctrl_rresp		(cpu_io_ctrl_rresp ),
    .cpu_io_ctrl_rvalid		(cpu_io_ctrl_rvalid),
    .cpu_io_ctrl_wdata		(cpu_io_ctrl_wdata ),
    .cpu_io_ctrl_wready		(cpu_io_ctrl_wready),
    .cpu_io_ctrl_wstrb		(cpu_io_ctrl_wstrb ),
    .cpu_io_ctrl_wvalid		(cpu_io_ctrl_wvalid),

    .cpu_perf_cnt_araddr	(cpu_perf_cnt_araddr	),
    .cpu_perf_cnt_arprot	(cpu_perf_cnt_arprot	),
    .cpu_perf_cnt_arready	(cpu_perf_cnt_arready	),
    .cpu_perf_cnt_arvalid	(cpu_perf_cnt_arvalid	),
    .cpu_perf_cnt_awaddr	(cpu_perf_cnt_awaddr	),
    .cpu_perf_cnt_awprot	(cpu_perf_cnt_awprot	),
    .cpu_perf_cnt_awready	(cpu_perf_cnt_awready	),
    .cpu_perf_cnt_awvalid	(cpu_perf_cnt_awvalid	),
    .cpu_perf_cnt_bready	(cpu_perf_cnt_bready	),
    .cpu_perf_cnt_bresp		(cpu_perf_cnt_bresp		),
    .cpu_perf_cnt_bvalid	(cpu_perf_cnt_bvalid	),
    .cpu_perf_cnt_rdata		(cpu_perf_cnt_rdata		),
    .cpu_perf_cnt_rready	(cpu_perf_cnt_rready	),
    .cpu_perf_cnt_rresp		(cpu_perf_cnt_rresp		),
    .cpu_perf_cnt_rvalid	(cpu_perf_cnt_rvalid	),
    .cpu_perf_cnt_wdata		(cpu_perf_cnt_wdata		),
    .cpu_perf_cnt_wready	(cpu_perf_cnt_wready	),
    .cpu_perf_cnt_wstrb		(cpu_perf_cnt_wstrb		),
    .cpu_perf_cnt_wvalid	(cpu_perf_cnt_wvalid	),

    .cpu_reset_n	(cpu_reset_n),
    .cpu_reset		(cpu_reset),
    .sys_port_reset_n	(role_resetn),

    .role_clk	(role_clk),
    .role_resetn	(role_resetn)
  );

  assign axi_role_to_mem_araddr[39:32] = 'd0;
  assign axi_role_to_mem_awaddr[39:32] = 'd0;

  cpu_clk		u_cpu_clk (
    .cpu_clk		(cpu_clk	   ),
    .cpu_clk_locked	(cpu_clk_locked),
    .cpu_ic_reset_n	(cpu_ic_reset_n),

	.acc_done		(acc_done),
	.gpio_acc_start	(gpio_acc_start),

    .cpu_perf_cnt_0	(cpu_perf_cnt_0),
    .cpu_perf_cnt_1	(cpu_perf_cnt_1),
    .cpu_perf_cnt_2	(cpu_perf_cnt_2),
    .cpu_perf_cnt_3	(cpu_perf_cnt_3),
    .cpu_perf_cnt_4	(cpu_perf_cnt_4),
    .cpu_perf_cnt_5	(cpu_perf_cnt_5),
    .cpu_perf_cnt_6	(cpu_perf_cnt_6),
    .cpu_perf_cnt_7	(cpu_perf_cnt_7),
    .cpu_perf_cnt_8	(cpu_perf_cnt_8),
    .cpu_perf_cnt_9	(cpu_perf_cnt_9),
    .cpu_perf_cnt_10	(cpu_perf_cnt_10),
    .cpu_perf_cnt_11	(cpu_perf_cnt_11),
    .cpu_perf_cnt_12	(cpu_perf_cnt_12),
    .cpu_perf_cnt_13	(cpu_perf_cnt_13),
    .cpu_perf_cnt_14	(cpu_perf_cnt_14),
    .cpu_perf_cnt_15	(cpu_perf_cnt_15),

    .cpu_perf_cnt_araddr	(cpu_perf_cnt_araddr ),
    .cpu_perf_cnt_arprot	(cpu_perf_cnt_arprot ),
    .cpu_perf_cnt_arready	(cpu_perf_cnt_arready),
    .cpu_perf_cnt_arvalid	(cpu_perf_cnt_arvalid),
    .cpu_perf_cnt_awaddr	(cpu_perf_cnt_awaddr ),
    .cpu_perf_cnt_awprot	(cpu_perf_cnt_awprot ),
    .cpu_perf_cnt_awready	(cpu_perf_cnt_awready),
    .cpu_perf_cnt_awvalid	(cpu_perf_cnt_awvalid),
    .cpu_perf_cnt_bready	(cpu_perf_cnt_bready),
    .cpu_perf_cnt_bresp		(cpu_perf_cnt_bresp	),
    .cpu_perf_cnt_bvalid	(cpu_perf_cnt_bvalid),
    .cpu_perf_cnt_rdata		(cpu_perf_cnt_rdata	),
    .cpu_perf_cnt_rready	(cpu_perf_cnt_rready),
    .cpu_perf_cnt_rresp		(cpu_perf_cnt_rresp	),
    .cpu_perf_cnt_rvalid	(cpu_perf_cnt_rvalid),
    .cpu_perf_cnt_wdata		(cpu_perf_cnt_wdata	),
    .cpu_perf_cnt_wready	(cpu_perf_cnt_wready),
    .cpu_perf_cnt_wstrb		(cpu_perf_cnt_wstrb	),
    .cpu_perf_cnt_wvalid	(cpu_perf_cnt_wvalid),

    .cpu_io_ctrl_araddr		(cpu_io_ctrl_araddr),
    .cpu_io_ctrl_arready		(cpu_io_ctrl_arready),
    .cpu_io_ctrl_arvalid		(cpu_io_ctrl_arvalid),
    .cpu_io_ctrl_awaddr		(cpu_io_ctrl_awaddr),
    .cpu_io_ctrl_awready		(cpu_io_ctrl_awready),
    .cpu_io_ctrl_awvalid		(cpu_io_ctrl_awvalid),
    .cpu_io_ctrl_bready		(cpu_io_ctrl_bready),
    .cpu_io_ctrl_bresp		(cpu_io_ctrl_bresp ),
    .cpu_io_ctrl_bvalid		(cpu_io_ctrl_bvalid),
    .cpu_io_ctrl_rdata		(cpu_io_ctrl_rdata ),
    .cpu_io_ctrl_rready		(cpu_io_ctrl_rready),
    .cpu_io_ctrl_rresp		(cpu_io_ctrl_rresp ),
    .cpu_io_ctrl_rvalid		(cpu_io_ctrl_rvalid),
    .cpu_io_ctrl_wdata		(cpu_io_ctrl_wdata ),
    .cpu_io_ctrl_wready		(cpu_io_ctrl_wready),
    .cpu_io_ctrl_wstrb		(cpu_io_ctrl_wstrb ),
    .cpu_io_ctrl_wvalid		(cpu_io_ctrl_wvalid),

    .cpu_reset_n		(cpu_reset_n),
    .role_clk				(role_clk),
    .role_resetn		(role_resetn)
  );

  cpu_wrapper	u_cpu_wrapper (
	.cpu_clk			(cpu_clk),
	.cpu_reset		(~cpu_reset),

	.cpu_perf_cnt_0 (cpu_perf_cnt_0),
	.cpu_perf_cnt_1 (cpu_perf_cnt_1),
	.cpu_perf_cnt_2 (cpu_perf_cnt_2),
	.cpu_perf_cnt_3 (cpu_perf_cnt_3),
	.cpu_perf_cnt_4 (cpu_perf_cnt_4),
	.cpu_perf_cnt_5 (cpu_perf_cnt_5),
	.cpu_perf_cnt_6 (cpu_perf_cnt_6),
	.cpu_perf_cnt_7 (cpu_perf_cnt_7),
	.cpu_perf_cnt_8 (cpu_perf_cnt_8),
	.cpu_perf_cnt_9 (cpu_perf_cnt_9),
	.cpu_perf_cnt_10 (cpu_perf_cnt_10),
	.cpu_perf_cnt_11 (cpu_perf_cnt_11),
	.cpu_perf_cnt_12 (cpu_perf_cnt_12),
	.cpu_perf_cnt_13 (cpu_perf_cnt_13),
	.cpu_perf_cnt_14 (cpu_perf_cnt_14),
	.cpu_perf_cnt_15 (cpu_perf_cnt_15),
	                      
	.cpu_inst_araddr  (cpu_inst_araddr ),
	.cpu_inst_arready (cpu_inst_arready),
	.cpu_inst_arvalid (cpu_inst_arvalid),
	.cpu_inst_arsize  (cpu_inst_arsize ),
	.cpu_inst_arburst (cpu_inst_arburst),
	.cpu_inst_arlen   (cpu_inst_arlen  ),
	                      
	.cpu_inst_rdata  (cpu_inst_rdata ),
	.cpu_inst_rready (cpu_inst_rready),
	.cpu_inst_rvalid (cpu_inst_rvalid),
	.cpu_inst_rlast  (cpu_inst_rlast ),
	                      
	.cpu_mem_araddr  (cpu_mem_araddr ),
	.cpu_mem_arready (cpu_mem_arready),
	.cpu_mem_arvalid (cpu_mem_arvalid),
	.cpu_mem_arsize  (cpu_mem_arsize ),
	.cpu_mem_arburst (cpu_mem_arburst),
	.cpu_mem_arlen   (cpu_mem_arlen  ),
	                      
	.cpu_mem_awaddr  (cpu_mem_awaddr ),
	.cpu_mem_awready (cpu_mem_awready),
	.cpu_mem_awvalid (cpu_mem_awvalid),
	.cpu_mem_awsize  (cpu_mem_awsize ),
	.cpu_mem_awburst (cpu_mem_awburst),
	.cpu_mem_awlen   (cpu_mem_awlen  ),
	                      
	.cpu_mem_bready (cpu_mem_bready),
	.cpu_mem_bvalid (cpu_mem_bvalid),
	                      
	.cpu_mem_rdata  (cpu_mem_rdata ),
	.cpu_mem_rready (cpu_mem_rready),
	.cpu_mem_rvalid (cpu_mem_rvalid),
	.cpu_mem_rlast  (cpu_mem_rlast ),
	                      
	.cpu_mem_wdata  (cpu_mem_wdata ),
	.cpu_mem_wready (cpu_mem_wready),
	.cpu_mem_wstrb  (cpu_mem_wstrb ),
	.cpu_mem_wvalid (cpu_mem_wvalid),
	.cpu_mem_wlast  (cpu_mem_wlast )
 );

/*dnn_acc_top		u_dnn_acc_top(
  .user_clk			(cpu_clk),
  .user_reset_n		(~cpu_reset),

  .acc_done_reg		(acc_done),
  .gpio_acc_start	(gpio_acc_start),

  .user_axi_araddr	(io_mem_araddr),
  .user_axi_arburst	(io_mem_arburst),
  .user_axi_arid	(io_mem_arid),
  .user_axi_arlen	(io_mem_arlen),
  .user_axi_arsize	(io_mem_arsize),
  .user_axi_arcache	(io_mem_arcache),
  .user_axi_arvalid	(io_mem_arvalid),
  .user_axi_arready	(io_mem_arready),

  .user_axi_awaddr	(io_mem_awaddr),
  .user_axi_awburst	(io_mem_awburst),
  .user_axi_awid	(io_mem_awid),
  .user_axi_awlen	(io_mem_awlen),
  .user_axi_awsize	(io_mem_awsize),
  .user_axi_awcache	(io_mem_awcache),
  .user_axi_awvalid	(io_mem_awvalid),
  .user_axi_awready	(io_mem_awready),

  .user_axi_bid		(io_mem_bid),
  .user_axi_bresp	(io_mem_bresp),
  .user_axi_bvalid	(io_mem_bvalid),
  .user_axi_bready	(io_mem_bready),

  .user_axi_rdata	(io_mem_rdata),
  .user_axi_rid		(io_mem_rid),
  .user_axi_rlast	(io_mem_rlast),
  .user_axi_rresp	(io_mem_rresp),
  .user_axi_rvalid	(io_mem_rvalid),
  .user_axi_rready	(io_mem_rready),
  
  .user_axi_wdata	(io_mem_wdata),
  .user_axi_wlast	(io_mem_wlast),
  .user_axi_wstrb	(io_mem_wstrb),
  .user_axi_wvalid	(io_mem_wvalid),
  .user_axi_wready	(io_mem_wready)
);*/


 endmodule
