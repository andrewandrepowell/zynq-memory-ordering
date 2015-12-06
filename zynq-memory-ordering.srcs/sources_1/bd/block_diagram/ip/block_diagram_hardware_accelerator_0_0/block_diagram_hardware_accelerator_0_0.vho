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

-- IP VLNV: user.org:user:hardware_accelerator:1.0
-- IP Revision: 8

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT block_diagram_hardware_accelerator_0_0
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    enable : IN STD_LOGIC;
    ready : OUT STD_LOGIC;
    data_awid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_awaddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    data_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    data_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    data_awlock : OUT STD_LOGIC;
    data_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    data_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_awuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_awvalid : OUT STD_LOGIC;
    data_awready : IN STD_LOGIC;
    data_wdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    data_wstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    data_wlast : OUT STD_LOGIC;
    data_wuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_wvalid : OUT STD_LOGIC;
    data_wready : IN STD_LOGIC;
    data_bid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    data_buser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_bvalid : IN STD_LOGIC;
    data_bready : OUT STD_LOGIC;
    data_arid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_araddr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_arlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    data_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    data_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    data_arlock : OUT STD_LOGIC;
    data_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    data_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    data_aruser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_arvalid : OUT STD_LOGIC;
    data_arready : IN STD_LOGIC;
    data_rid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_rdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    data_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    data_rlast : IN STD_LOGIC;
    data_ruser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    data_rvalid : IN STD_LOGIC;
    data_rready : OUT STD_LOGIC;
    registers_awaddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    registers_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    registers_awvalid : IN STD_LOGIC;
    registers_awready : OUT STD_LOGIC;
    registers_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    registers_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    registers_wvalid : IN STD_LOGIC;
    registers_wready : OUT STD_LOGIC;
    registers_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    registers_bvalid : OUT STD_LOGIC;
    registers_bready : IN STD_LOGIC;
    registers_araddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    registers_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    registers_arvalid : IN STD_LOGIC;
    registers_arready : OUT STD_LOGIC;
    registers_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    registers_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    registers_rvalid : OUT STD_LOGIC;
    registers_rready : IN STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : block_diagram_hardware_accelerator_0_0
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    enable => enable,
    ready => ready,
    data_awid => data_awid,
    data_awaddr => data_awaddr,
    data_awlen => data_awlen,
    data_awsize => data_awsize,
    data_awburst => data_awburst,
    data_awlock => data_awlock,
    data_awcache => data_awcache,
    data_awprot => data_awprot,
    data_awqos => data_awqos,
    data_awuser => data_awuser,
    data_awvalid => data_awvalid,
    data_awready => data_awready,
    data_wdata => data_wdata,
    data_wstrb => data_wstrb,
    data_wlast => data_wlast,
    data_wuser => data_wuser,
    data_wvalid => data_wvalid,
    data_wready => data_wready,
    data_bid => data_bid,
    data_bresp => data_bresp,
    data_buser => data_buser,
    data_bvalid => data_bvalid,
    data_bready => data_bready,
    data_arid => data_arid,
    data_araddr => data_araddr,
    data_arlen => data_arlen,
    data_arsize => data_arsize,
    data_arburst => data_arburst,
    data_arlock => data_arlock,
    data_arcache => data_arcache,
    data_arprot => data_arprot,
    data_arqos => data_arqos,
    data_aruser => data_aruser,
    data_arvalid => data_arvalid,
    data_arready => data_arready,
    data_rid => data_rid,
    data_rdata => data_rdata,
    data_rresp => data_rresp,
    data_rlast => data_rlast,
    data_ruser => data_ruser,
    data_rvalid => data_rvalid,
    data_rready => data_rready,
    registers_awaddr => registers_awaddr,
    registers_awprot => registers_awprot,
    registers_awvalid => registers_awvalid,
    registers_awready => registers_awready,
    registers_wdata => registers_wdata,
    registers_wstrb => registers_wstrb,
    registers_wvalid => registers_wvalid,
    registers_wready => registers_wready,
    registers_bresp => registers_bresp,
    registers_bvalid => registers_bvalid,
    registers_bready => registers_bready,
    registers_araddr => registers_araddr,
    registers_arprot => registers_arprot,
    registers_arvalid => registers_arvalid,
    registers_arready => registers_arready,
    registers_rdata => registers_rdata,
    registers_rresp => registers_rresp,
    registers_rvalid => registers_rvalid,
    registers_rready => registers_rready
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

