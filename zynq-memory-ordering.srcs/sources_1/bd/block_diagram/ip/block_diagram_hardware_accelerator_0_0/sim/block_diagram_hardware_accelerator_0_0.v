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


// IP VLNV: user.org:user:hardware_accelerator:1.0
// IP Revision: 8

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module block_diagram_hardware_accelerator_0_0 (
  aclk,
  aresetn,
  enable,
  ready,
  data_awid,
  data_awaddr,
  data_awlen,
  data_awsize,
  data_awburst,
  data_awlock,
  data_awcache,
  data_awprot,
  data_awqos,
  data_awuser,
  data_awvalid,
  data_awready,
  data_wdata,
  data_wstrb,
  data_wlast,
  data_wuser,
  data_wvalid,
  data_wready,
  data_bid,
  data_bresp,
  data_buser,
  data_bvalid,
  data_bready,
  data_arid,
  data_araddr,
  data_arlen,
  data_arsize,
  data_arburst,
  data_arlock,
  data_arcache,
  data_arprot,
  data_arqos,
  data_aruser,
  data_arvalid,
  data_arready,
  data_rid,
  data_rdata,
  data_rresp,
  data_rlast,
  data_ruser,
  data_rvalid,
  data_rready,
  registers_awaddr,
  registers_awprot,
  registers_awvalid,
  registers_awready,
  registers_wdata,
  registers_wstrb,
  registers_wvalid,
  registers_wready,
  registers_bresp,
  registers_bvalid,
  registers_bready,
  registers_araddr,
  registers_arprot,
  registers_arvalid,
  registers_arready,
  registers_rdata,
  registers_rresp,
  registers_rvalid,
  registers_rready
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
input wire aclk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
input wire aresetn;
input wire enable;
output wire ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWID" *)
output wire [0 : 0] data_awid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWADDR" *)
output wire [31 : 0] data_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWLEN" *)
output wire [7 : 0] data_awlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWSIZE" *)
output wire [2 : 0] data_awsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWBURST" *)
output wire [1 : 0] data_awburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWLOCK" *)
output wire data_awlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWCACHE" *)
output wire [3 : 0] data_awcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWPROT" *)
output wire [2 : 0] data_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWQOS" *)
output wire [3 : 0] data_awqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWUSER" *)
output wire [0 : 0] data_awuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWVALID" *)
output wire data_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data AWREADY" *)
input wire data_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data WDATA" *)
output wire [63 : 0] data_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data WSTRB" *)
output wire [7 : 0] data_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data WLAST" *)
output wire data_wlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data WUSER" *)
output wire [0 : 0] data_wuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data WVALID" *)
output wire data_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data WREADY" *)
input wire data_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data BID" *)
input wire [0 : 0] data_bid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data BRESP" *)
input wire [1 : 0] data_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data BUSER" *)
input wire [0 : 0] data_buser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data BVALID" *)
input wire data_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data BREADY" *)
output wire data_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARID" *)
output wire [0 : 0] data_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARADDR" *)
output wire [31 : 0] data_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARLEN" *)
output wire [7 : 0] data_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARSIZE" *)
output wire [2 : 0] data_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARBURST" *)
output wire [1 : 0] data_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARLOCK" *)
output wire data_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARCACHE" *)
output wire [3 : 0] data_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARPROT" *)
output wire [2 : 0] data_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARQOS" *)
output wire [3 : 0] data_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARUSER" *)
output wire [0 : 0] data_aruser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARVALID" *)
output wire data_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data ARREADY" *)
input wire data_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data RID" *)
input wire [0 : 0] data_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data RDATA" *)
input wire [63 : 0] data_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data RRESP" *)
input wire [1 : 0] data_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data RLAST" *)
input wire data_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data RUSER" *)
input wire [0 : 0] data_ruser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data RVALID" *)
input wire data_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 data RREADY" *)
output wire data_rready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers AWADDR" *)
input wire [4 : 0] registers_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers AWPROT" *)
input wire [2 : 0] registers_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers AWVALID" *)
input wire registers_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers AWREADY" *)
output wire registers_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers WDATA" *)
input wire [31 : 0] registers_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers WSTRB" *)
input wire [3 : 0] registers_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers WVALID" *)
input wire registers_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers WREADY" *)
output wire registers_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers BRESP" *)
output wire [1 : 0] registers_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers BVALID" *)
output wire registers_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers BREADY" *)
input wire registers_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers ARADDR" *)
input wire [4 : 0] registers_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers ARPROT" *)
input wire [2 : 0] registers_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers ARVALID" *)
input wire registers_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers ARREADY" *)
output wire registers_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers RDATA" *)
output wire [31 : 0] registers_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers RRESP" *)
output wire [1 : 0] registers_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers RVALID" *)
output wire registers_rvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 registers RREADY" *)
input wire registers_rready;

  hardware_accelerator_v1_0 #(
    .C_data_ID_WIDTH(1),  // Thread ID Width
    .C_data_ADDR_WIDTH(32),  // Width of Address Bus
    .C_data_DATA_WIDTH(64),  // Width of Data Bus
    .C_data_AWUSER_WIDTH(1),  // Width of User Write Address Bus
    .C_data_ARUSER_WIDTH(1),  // Width of User Read Address Bus
    .C_data_WUSER_WIDTH(1),  // Width of User Write Data Bus
    .C_data_RUSER_WIDTH(1),  // Width of User Read Data Bus
    .C_data_BUSER_WIDTH(1),  // Width of User Response Bus
    .C_registers_DATA_WIDTH(32),  // Width of S_AXI data bus
    .C_registers_ADDR_WIDTH(5),  // Width of S_AXI address bus
    .C_data_ID(0),
    .BUFFER_SIZE(4)
  ) inst (
    .aclk(aclk),
    .aresetn(aresetn),
    .enable(enable),
    .ready(ready),
    .data_awid(data_awid),
    .data_awaddr(data_awaddr),
    .data_awlen(data_awlen),
    .data_awsize(data_awsize),
    .data_awburst(data_awburst),
    .data_awlock(data_awlock),
    .data_awcache(data_awcache),
    .data_awprot(data_awprot),
    .data_awqos(data_awqos),
    .data_awuser(data_awuser),
    .data_awvalid(data_awvalid),
    .data_awready(data_awready),
    .data_wdata(data_wdata),
    .data_wstrb(data_wstrb),
    .data_wlast(data_wlast),
    .data_wuser(data_wuser),
    .data_wvalid(data_wvalid),
    .data_wready(data_wready),
    .data_bid(data_bid),
    .data_bresp(data_bresp),
    .data_buser(data_buser),
    .data_bvalid(data_bvalid),
    .data_bready(data_bready),
    .data_arid(data_arid),
    .data_araddr(data_araddr),
    .data_arlen(data_arlen),
    .data_arsize(data_arsize),
    .data_arburst(data_arburst),
    .data_arlock(data_arlock),
    .data_arcache(data_arcache),
    .data_arprot(data_arprot),
    .data_arqos(data_arqos),
    .data_aruser(data_aruser),
    .data_arvalid(data_arvalid),
    .data_arready(data_arready),
    .data_rid(data_rid),
    .data_rdata(data_rdata),
    .data_rresp(data_rresp),
    .data_rlast(data_rlast),
    .data_ruser(data_ruser),
    .data_rvalid(data_rvalid),
    .data_rready(data_rready),
    .registers_awaddr(registers_awaddr),
    .registers_awprot(registers_awprot),
    .registers_awvalid(registers_awvalid),
    .registers_awready(registers_awready),
    .registers_wdata(registers_wdata),
    .registers_wstrb(registers_wstrb),
    .registers_wvalid(registers_wvalid),
    .registers_wready(registers_wready),
    .registers_bresp(registers_bresp),
    .registers_bvalid(registers_bvalid),
    .registers_bready(registers_bready),
    .registers_araddr(registers_araddr),
    .registers_arprot(registers_arprot),
    .registers_arvalid(registers_arvalid),
    .registers_arready(registers_arready),
    .registers_rdata(registers_rdata),
    .registers_rresp(registers_rresp),
    .registers_rvalid(registers_rvalid),
    .registers_rready(registers_rready)
  );
endmodule
