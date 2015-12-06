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

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
block_diagram_hardware_accelerator_0_0 your_instance_name (
  .aclk(aclk),                            // input wire aclk
  .aresetn(aresetn),                      // input wire aresetn
  .enable(enable),                        // input wire enable
  .ready(ready),                          // output wire ready
  .data_awid(data_awid),                  // output wire [0 : 0] data_awid
  .data_awaddr(data_awaddr),              // output wire [31 : 0] data_awaddr
  .data_awlen(data_awlen),                // output wire [7 : 0] data_awlen
  .data_awsize(data_awsize),              // output wire [2 : 0] data_awsize
  .data_awburst(data_awburst),            // output wire [1 : 0] data_awburst
  .data_awlock(data_awlock),              // output wire data_awlock
  .data_awcache(data_awcache),            // output wire [3 : 0] data_awcache
  .data_awprot(data_awprot),              // output wire [2 : 0] data_awprot
  .data_awqos(data_awqos),                // output wire [3 : 0] data_awqos
  .data_awuser(data_awuser),              // output wire [0 : 0] data_awuser
  .data_awvalid(data_awvalid),            // output wire data_awvalid
  .data_awready(data_awready),            // input wire data_awready
  .data_wdata(data_wdata),                // output wire [63 : 0] data_wdata
  .data_wstrb(data_wstrb),                // output wire [7 : 0] data_wstrb
  .data_wlast(data_wlast),                // output wire data_wlast
  .data_wuser(data_wuser),                // output wire [0 : 0] data_wuser
  .data_wvalid(data_wvalid),              // output wire data_wvalid
  .data_wready(data_wready),              // input wire data_wready
  .data_bid(data_bid),                    // input wire [0 : 0] data_bid
  .data_bresp(data_bresp),                // input wire [1 : 0] data_bresp
  .data_buser(data_buser),                // input wire [0 : 0] data_buser
  .data_bvalid(data_bvalid),              // input wire data_bvalid
  .data_bready(data_bready),              // output wire data_bready
  .data_arid(data_arid),                  // output wire [0 : 0] data_arid
  .data_araddr(data_araddr),              // output wire [31 : 0] data_araddr
  .data_arlen(data_arlen),                // output wire [7 : 0] data_arlen
  .data_arsize(data_arsize),              // output wire [2 : 0] data_arsize
  .data_arburst(data_arburst),            // output wire [1 : 0] data_arburst
  .data_arlock(data_arlock),              // output wire data_arlock
  .data_arcache(data_arcache),            // output wire [3 : 0] data_arcache
  .data_arprot(data_arprot),              // output wire [2 : 0] data_arprot
  .data_arqos(data_arqos),                // output wire [3 : 0] data_arqos
  .data_aruser(data_aruser),              // output wire [0 : 0] data_aruser
  .data_arvalid(data_arvalid),            // output wire data_arvalid
  .data_arready(data_arready),            // input wire data_arready
  .data_rid(data_rid),                    // input wire [0 : 0] data_rid
  .data_rdata(data_rdata),                // input wire [63 : 0] data_rdata
  .data_rresp(data_rresp),                // input wire [1 : 0] data_rresp
  .data_rlast(data_rlast),                // input wire data_rlast
  .data_ruser(data_ruser),                // input wire [0 : 0] data_ruser
  .data_rvalid(data_rvalid),              // input wire data_rvalid
  .data_rready(data_rready),              // output wire data_rready
  .registers_awaddr(registers_awaddr),    // input wire [4 : 0] registers_awaddr
  .registers_awprot(registers_awprot),    // input wire [2 : 0] registers_awprot
  .registers_awvalid(registers_awvalid),  // input wire registers_awvalid
  .registers_awready(registers_awready),  // output wire registers_awready
  .registers_wdata(registers_wdata),      // input wire [31 : 0] registers_wdata
  .registers_wstrb(registers_wstrb),      // input wire [3 : 0] registers_wstrb
  .registers_wvalid(registers_wvalid),    // input wire registers_wvalid
  .registers_wready(registers_wready),    // output wire registers_wready
  .registers_bresp(registers_bresp),      // output wire [1 : 0] registers_bresp
  .registers_bvalid(registers_bvalid),    // output wire registers_bvalid
  .registers_bready(registers_bready),    // input wire registers_bready
  .registers_araddr(registers_araddr),    // input wire [4 : 0] registers_araddr
  .registers_arprot(registers_arprot),    // input wire [2 : 0] registers_arprot
  .registers_arvalid(registers_arvalid),  // input wire registers_arvalid
  .registers_arready(registers_arready),  // output wire registers_arready
  .registers_rdata(registers_rdata),      // output wire [31 : 0] registers_rdata
  .registers_rresp(registers_rresp),      // output wire [1 : 0] registers_rresp
  .registers_rvalid(registers_rvalid),    // output wire registers_rvalid
  .registers_rready(registers_rready)    // input wire registers_rready
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

