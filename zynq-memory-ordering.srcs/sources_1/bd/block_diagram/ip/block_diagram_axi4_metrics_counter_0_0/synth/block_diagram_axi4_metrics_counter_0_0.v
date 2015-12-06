// (c) Copyright 1995-2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:user:axi4_metrics_counter:1.0
// IP Revision: 3

(* X_CORE_INFO = "axi4_metrics_counter_v1_0,Vivado 2015.3" *)
(* CHECK_LICENSE_TYPE = "block_diagram_axi4_metrics_counter_0_0,axi4_metrics_counter_v1_0,{}" *)
(* CORE_GENERATION_INFO = "block_diagram_axi4_metrics_counter_0_0,axi4_metrics_counter_v1_0,{x_ipProduct=Vivado 2015.3,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=axi4_metrics_counter,x_ipVersion=1.0,x_ipCoreRevision=3,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_s_axi_lite_DATA_WIDTH=32,C_s_axi_lite_ADDR_WIDTH=8,C_axi4_monitor_ID_WIDTH=1,C_axi4_monitor_DATA_WIDTH=64,C_axi4_monitor_ADDR_WIDTH=6}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module block_diagram_axi4_metrics_counter_0_0 (
  aclk,
  aresetn,
  s_axi_lite_awaddr,
  s_axi_lite_awprot,
  s_axi_lite_awvalid,
  s_axi_lite_awready,
  s_axi_lite_wdata,
  s_axi_lite_wstrb,
  s_axi_lite_wvalid,
  s_axi_lite_wready,
  s_axi_lite_bresp,
  s_axi_lite_bvalid,
  s_axi_lite_bready,
  s_axi_lite_araddr,
  s_axi_lite_arprot,
  s_axi_lite_arvalid,
  s_axi_lite_arready,
  s_axi_lite_rdata,
  s_axi_lite_rresp,
  s_axi_lite_rvalid,
  s_axi_lite_rready,
  axi4_monitor_arid,
  axi4_monitor_araddr,
  axi4_monitor_arlen,
  axi4_monitor_arsize,
  axi4_monitor_arburst,
  axi4_monitor_arlock,
  axi4_monitor_arcache,
  axi4_monitor_arprot,
  axi4_monitor_arvalid,
  axi4_monitor_arready,
  axi4_monitor_awid,
  axi4_monitor_awaddr,
  axi4_monitor_awlen,
  axi4_monitor_awsize,
  axi4_monitor_awburst,
  axi4_monitor_awlock,
  axi4_monitor_awcache,
  axi4_monitor_awprot,
  axi4_monitor_awvalid,
  axi4_monitor_awready,
  axi4_monitor_bid,
  axi4_monitor_bresp,
  axi4_monitor_bvalid,
  axi4_monitor_bready,
  axi4_monitor_rid,
  axi4_monitor_rdata,
  axi4_monitor_rresp,
  axi4_monitor_rlast,
  axi4_monitor_rvalid,
  axi4_monitor_rready,
  axi4_monitor_wid,
  axi4_monitor_wdata,
  axi4_monitor_wstrb,
  axi4_monitor_wlast,
  axi4_monitor_wvalid,
  axi4_monitor_wready,
  counter_start,
  counter_finish
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
input wire aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
input wire aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite AWADDR" *)
input wire [7 : 0] s_axi_lite_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite AWPROT" *)
input wire [2 : 0] s_axi_lite_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite AWVALID" *)
input wire s_axi_lite_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite AWREADY" *)
output wire s_axi_lite_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite WDATA" *)
input wire [31 : 0] s_axi_lite_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite WSTRB" *)
input wire [3 : 0] s_axi_lite_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite WVALID" *)
input wire s_axi_lite_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite WREADY" *)
output wire s_axi_lite_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite BRESP" *)
output wire [1 : 0] s_axi_lite_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite BVALID" *)
output wire s_axi_lite_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite BREADY" *)
input wire s_axi_lite_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite ARADDR" *)
input wire [7 : 0] s_axi_lite_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite ARPROT" *)
input wire [2 : 0] s_axi_lite_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite ARVALID" *)
input wire s_axi_lite_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite ARREADY" *)
output wire s_axi_lite_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite RDATA" *)
output wire [31 : 0] s_axi_lite_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite RRESP" *)
output wire [1 : 0] s_axi_lite_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite RVALID" *)
output wire s_axi_lite_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_lite RREADY" *)
input wire s_axi_lite_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARID" *)
input wire [0 : 0] axi4_monitor_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARADDR" *)
input wire [5 : 0] axi4_monitor_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARLEN" *)
input wire [7 : 0] axi4_monitor_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARSIZE" *)
input wire [2 : 0] axi4_monitor_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARBURST" *)
input wire [1 : 0] axi4_monitor_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARLOCK" *)
input wire axi4_monitor_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARCACHE" *)
input wire [3 : 0] axi4_monitor_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARPROT" *)
input wire [2 : 0] axi4_monitor_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARVALID" *)
input wire axi4_monitor_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor ARREADY" *)
input wire axi4_monitor_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWID" *)
input wire [0 : 0] axi4_monitor_awid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWADDR" *)
input wire [5 : 0] axi4_monitor_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWLEN" *)
input wire [7 : 0] axi4_monitor_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWSIZE" *)
input wire [2 : 0] axi4_monitor_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWBURST" *)
input wire [1 : 0] axi4_monitor_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWLOCK" *)
input wire axi4_monitor_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWCACHE" *)
input wire [3 : 0] axi4_monitor_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWPROT" *)
input wire [2 : 0] axi4_monitor_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWVALID" *)
input wire axi4_monitor_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor AWREADY" *)
input wire axi4_monitor_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor BID" *)
input wire [0 : 0] axi4_monitor_bid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor BRESP" *)
input wire [1 : 0] axi4_monitor_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor BVALID" *)
input wire axi4_monitor_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor BREADY" *)
input wire axi4_monitor_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor RID" *)
input wire [0 : 0] axi4_monitor_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor RDATA" *)
input wire [63 : 0] axi4_monitor_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor RRESP" *)
input wire [1 : 0] axi4_monitor_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor RLAST" *)
input wire axi4_monitor_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor RVALID" *)
input wire axi4_monitor_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor RREADY" *)
input wire axi4_monitor_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor WID" *)
input wire [0 : 0] axi4_monitor_wid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor WDATA" *)
input wire [63 : 0] axi4_monitor_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor WSTRB" *)
input wire [7 : 0] axi4_monitor_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor WLAST" *)
input wire axi4_monitor_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor WVALID" *)
input wire axi4_monitor_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi4_monitor WREADY" *)
input wire axi4_monitor_wready;
input wire counter_start;
input wire counter_finish;

  axi4_metrics_counter_v1_0 #(
    .C_s_axi_lite_DATA_WIDTH(32),
    .C_s_axi_lite_ADDR_WIDTH(8),
    .C_axi4_monitor_ID_WIDTH(1),
    .C_axi4_monitor_DATA_WIDTH(64),
    .C_axi4_monitor_ADDR_WIDTH(6)
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axi_lite_awaddr(s_axi_lite_awaddr),
    .s_axi_lite_awprot(s_axi_lite_awprot),
    .s_axi_lite_awvalid(s_axi_lite_awvalid),
    .s_axi_lite_awready(s_axi_lite_awready),
    .s_axi_lite_wdata(s_axi_lite_wdata),
    .s_axi_lite_wstrb(s_axi_lite_wstrb),
    .s_axi_lite_wvalid(s_axi_lite_wvalid),
    .s_axi_lite_wready(s_axi_lite_wready),
    .s_axi_lite_bresp(s_axi_lite_bresp),
    .s_axi_lite_bvalid(s_axi_lite_bvalid),
    .s_axi_lite_bready(s_axi_lite_bready),
    .s_axi_lite_araddr(s_axi_lite_araddr),
    .s_axi_lite_arprot(s_axi_lite_arprot),
    .s_axi_lite_arvalid(s_axi_lite_arvalid),
    .s_axi_lite_arready(s_axi_lite_arready),
    .s_axi_lite_rdata(s_axi_lite_rdata),
    .s_axi_lite_rresp(s_axi_lite_rresp),
    .s_axi_lite_rvalid(s_axi_lite_rvalid),
    .s_axi_lite_rready(s_axi_lite_rready),
    .axi4_monitor_arid(axi4_monitor_arid),
    .axi4_monitor_araddr(axi4_monitor_araddr),
    .axi4_monitor_arlen(axi4_monitor_arlen),
    .axi4_monitor_arsize(axi4_monitor_arsize),
    .axi4_monitor_arburst(axi4_monitor_arburst),
    .axi4_monitor_arlock(axi4_monitor_arlock),
    .axi4_monitor_arcache(axi4_monitor_arcache),
    .axi4_monitor_arprot(axi4_monitor_arprot),
    .axi4_monitor_arvalid(axi4_monitor_arvalid),
    .axi4_monitor_arready(axi4_monitor_arready),
    .axi4_monitor_awid(axi4_monitor_awid),
    .axi4_monitor_awaddr(axi4_monitor_awaddr),
    .axi4_monitor_awlen(axi4_monitor_awlen),
    .axi4_monitor_awsize(axi4_monitor_awsize),
    .axi4_monitor_awburst(axi4_monitor_awburst),
    .axi4_monitor_awlock(axi4_monitor_awlock),
    .axi4_monitor_awcache(axi4_monitor_awcache),
    .axi4_monitor_awprot(axi4_monitor_awprot),
    .axi4_monitor_awvalid(axi4_monitor_awvalid),
    .axi4_monitor_awready(axi4_monitor_awready),
    .axi4_monitor_bid(axi4_monitor_bid),
    .axi4_monitor_bresp(axi4_monitor_bresp),
    .axi4_monitor_bvalid(axi4_monitor_bvalid),
    .axi4_monitor_bready(axi4_monitor_bready),
    .axi4_monitor_rid(axi4_monitor_rid),
    .axi4_monitor_rdata(axi4_monitor_rdata),
    .axi4_monitor_rresp(axi4_monitor_rresp),
    .axi4_monitor_rlast(axi4_monitor_rlast),
    .axi4_monitor_rvalid(axi4_monitor_rvalid),
    .axi4_monitor_rready(axi4_monitor_rready),
    .axi4_monitor_wid(axi4_monitor_wid),
    .axi4_monitor_wdata(axi4_monitor_wdata),
    .axi4_monitor_wstrb(axi4_monitor_wstrb),
    .axi4_monitor_wlast(axi4_monitor_wlast),
    .axi4_monitor_wvalid(axi4_monitor_wvalid),
    .axi4_monitor_wready(axi4_monitor_wready),
    .counter_start(counter_start),
    .counter_finish(counter_finish)
  );
endmodule
