-- (c) Copyright 1995-2015 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:user:axi4_metrics_counter:1.0
-- IP Revision: 3

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT block_diagram_axi4_metrics_counter_0_0
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axi_lite_awaddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_lite_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_lite_awvalid : IN STD_LOGIC;
    s_axi_lite_awready : OUT STD_LOGIC;
    s_axi_lite_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_lite_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_lite_wvalid : IN STD_LOGIC;
    s_axi_lite_wready : OUT STD_LOGIC;
    s_axi_lite_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_lite_bvalid : OUT STD_LOGIC;
    s_axi_lite_bready : IN STD_LOGIC;
    s_axi_lite_araddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_lite_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_lite_arvalid : IN STD_LOGIC;
    s_axi_lite_arready : OUT STD_LOGIC;
    s_axi_lite_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_lite_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_lite_rvalid : OUT STD_LOGIC;
    s_axi_lite_rready : IN STD_LOGIC;
    axi4_monitor_arid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    axi4_monitor_araddr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    axi4_monitor_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    axi4_monitor_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    axi4_monitor_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    axi4_monitor_arlock : IN STD_LOGIC;
    axi4_monitor_arcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    axi4_monitor_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    axi4_monitor_arvalid : IN STD_LOGIC;
    axi4_monitor_arready : IN STD_LOGIC;
    axi4_monitor_awid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    axi4_monitor_awaddr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    axi4_monitor_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    axi4_monitor_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    axi4_monitor_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    axi4_monitor_awlock : IN STD_LOGIC;
    axi4_monitor_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    axi4_monitor_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    axi4_monitor_awvalid : IN STD_LOGIC;
    axi4_monitor_awready : IN STD_LOGIC;
    axi4_monitor_bid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    axi4_monitor_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    axi4_monitor_bvalid : IN STD_LOGIC;
    axi4_monitor_bready : IN STD_LOGIC;
    axi4_monitor_rid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    axi4_monitor_rdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    axi4_monitor_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    axi4_monitor_rlast : IN STD_LOGIC;
    axi4_monitor_rvalid : IN STD_LOGIC;
    axi4_monitor_rready : IN STD_LOGIC;
    axi4_monitor_wid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    axi4_monitor_wdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    axi4_monitor_wstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    axi4_monitor_wlast : IN STD_LOGIC;
    axi4_monitor_wvalid : IN STD_LOGIC;
    axi4_monitor_wready : IN STD_LOGIC;
    counter_start : IN STD_LOGIC;
    counter_finish : IN STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : block_diagram_axi4_metrics_counter_0_0
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    s_axi_lite_awaddr => s_axi_lite_awaddr,
    s_axi_lite_awprot => s_axi_lite_awprot,
    s_axi_lite_awvalid => s_axi_lite_awvalid,
    s_axi_lite_awready => s_axi_lite_awready,
    s_axi_lite_wdata => s_axi_lite_wdata,
    s_axi_lite_wstrb => s_axi_lite_wstrb,
    s_axi_lite_wvalid => s_axi_lite_wvalid,
    s_axi_lite_wready => s_axi_lite_wready,
    s_axi_lite_bresp => s_axi_lite_bresp,
    s_axi_lite_bvalid => s_axi_lite_bvalid,
    s_axi_lite_bready => s_axi_lite_bready,
    s_axi_lite_araddr => s_axi_lite_araddr,
    s_axi_lite_arprot => s_axi_lite_arprot,
    s_axi_lite_arvalid => s_axi_lite_arvalid,
    s_axi_lite_arready => s_axi_lite_arready,
    s_axi_lite_rdata => s_axi_lite_rdata,
    s_axi_lite_rresp => s_axi_lite_rresp,
    s_axi_lite_rvalid => s_axi_lite_rvalid,
    s_axi_lite_rready => s_axi_lite_rready,
    axi4_monitor_arid => axi4_monitor_arid,
    axi4_monitor_araddr => axi4_monitor_araddr,
    axi4_monitor_arlen => axi4_monitor_arlen,
    axi4_monitor_arsize => axi4_monitor_arsize,
    axi4_monitor_arburst => axi4_monitor_arburst,
    axi4_monitor_arlock => axi4_monitor_arlock,
    axi4_monitor_arcache => axi4_monitor_arcache,
    axi4_monitor_arprot => axi4_monitor_arprot,
    axi4_monitor_arvalid => axi4_monitor_arvalid,
    axi4_monitor_arready => axi4_monitor_arready,
    axi4_monitor_awid => axi4_monitor_awid,
    axi4_monitor_awaddr => axi4_monitor_awaddr,
    axi4_monitor_awlen => axi4_monitor_awlen,
    axi4_monitor_awsize => axi4_monitor_awsize,
    axi4_monitor_awburst => axi4_monitor_awburst,
    axi4_monitor_awlock => axi4_monitor_awlock,
    axi4_monitor_awcache => axi4_monitor_awcache,
    axi4_monitor_awprot => axi4_monitor_awprot,
    axi4_monitor_awvalid => axi4_monitor_awvalid,
    axi4_monitor_awready => axi4_monitor_awready,
    axi4_monitor_bid => axi4_monitor_bid,
    axi4_monitor_bresp => axi4_monitor_bresp,
    axi4_monitor_bvalid => axi4_monitor_bvalid,
    axi4_monitor_bready => axi4_monitor_bready,
    axi4_monitor_rid => axi4_monitor_rid,
    axi4_monitor_rdata => axi4_monitor_rdata,
    axi4_monitor_rresp => axi4_monitor_rresp,
    axi4_monitor_rlast => axi4_monitor_rlast,
    axi4_monitor_rvalid => axi4_monitor_rvalid,
    axi4_monitor_rready => axi4_monitor_rready,
    axi4_monitor_wid => axi4_monitor_wid,
    axi4_monitor_wdata => axi4_monitor_wdata,
    axi4_monitor_wstrb => axi4_monitor_wstrb,
    axi4_monitor_wlast => axi4_monitor_wlast,
    axi4_monitor_wvalid => axi4_monitor_wvalid,
    axi4_monitor_wready => axi4_monitor_wready,
    counter_start => counter_start,
    counter_finish => counter_finish
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file block_diagram_axi4_metrics_counter_0_0.vhd when simulating
-- the core, block_diagram_axi4_metrics_counter_0_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

