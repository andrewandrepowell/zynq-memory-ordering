
`timescale 1 ns / 1 ps

module hardware_accelerator_v1_0 #(
    // Parameters of Axi Slave Bus Interface registers
    parameter integer C_registers_DATA_WIDTH	= 32,
    parameter integer C_registers_ADDR_WIDTH	= 5,

    // Parameters of Axi Master Bus Interface data
    parameter integer C_data_ID_WIDTH	= 1,
    parameter integer C_data_ID = 0,
    parameter integer C_data_ADDR_WIDTH	= 32,
    parameter integer C_data_DATA_WIDTH	= 32,
    parameter integer C_data_AWUSER_WIDTH	= 1,
    parameter integer C_data_ARUSER_WIDTH	= 1,
    parameter integer C_data_WUSER_WIDTH	= 0,
    parameter integer C_data_RUSER_WIDTH	= 0,
    parameter integer C_data_BUSER_WIDTH	= 0,
    
    // Misc
    parameter integer BUFFER_SIZE = 4) (
    
    // Synchronization interface.
    input wire aclk,
    input wire aresetn,
    input wire enable,
    output wire ready,
    
    // Ports of Axi Slave Bus Interface registers
    input wire [C_registers_ADDR_WIDTH-1 : 0] registers_awaddr,
    input wire [2 : 0] registers_awprot,
    input wire  registers_awvalid,
    output wire  registers_awready,
    input wire [C_registers_DATA_WIDTH-1 : 0] registers_wdata,
    input wire [(C_registers_DATA_WIDTH/8)-1 : 0] registers_wstrb,
    input wire  registers_wvalid,
    output wire  registers_wready,
    output wire [1 : 0] registers_bresp,
    output wire  registers_bvalid,
    input wire  registers_bready,
    input wire [C_registers_ADDR_WIDTH-1 : 0] registers_araddr,
    input wire [2 : 0] registers_arprot,
    input wire  registers_arvalid,
    output wire  registers_arready,
    output wire [C_registers_DATA_WIDTH-1 : 0] registers_rdata,
    output wire [1 : 0] registers_rresp,
    output wire  registers_rvalid,
    input wire  registers_rready,

    // Ports of Axi Master Bus Interface data
    output wire [C_data_ID_WIDTH-1 : 0] data_awid,
    output wire [C_data_ADDR_WIDTH-1 : 0] data_awaddr,
    output wire [7 : 0] data_awlen,
    output wire [2 : 0] data_awsize,
    output wire [1 : 0] data_awburst,
    output wire  data_awlock,
    output wire [3 : 0] data_awcache,
    output wire [2 : 0] data_awprot,
    output wire [3 : 0] data_awqos,
    output wire [C_data_AWUSER_WIDTH-1 : 0] data_awuser,
    output wire  data_awvalid,
    input wire  data_awready,
    output wire [C_data_DATA_WIDTH-1 : 0] data_wdata,
    output wire [C_data_DATA_WIDTH/8-1 : 0] data_wstrb,
    output wire  data_wlast,
    output wire [C_data_WUSER_WIDTH-1 : 0] data_wuser,
    output wire  data_wvalid,
    input wire  data_wready,
    input wire [C_data_ID_WIDTH-1 : 0] data_bid,
    input wire [1 : 0] data_bresp,
    input wire [C_data_BUSER_WIDTH-1 : 0] data_buser,
    input wire  data_bvalid,
    output wire  data_bready,
    output wire [C_data_ID_WIDTH-1 : 0] data_arid,
    output wire [C_data_ADDR_WIDTH-1 : 0] data_araddr,
    output wire [7 : 0] data_arlen,
    output wire [2 : 0] data_arsize,
    output wire [1 : 0] data_arburst,
    output wire  data_arlock,
    output wire [3 : 0] data_arcache,
    output wire [2 : 0] data_arprot,
    output wire [3 : 0] data_arqos,
    output wire [C_data_ARUSER_WIDTH-1 : 0] data_aruser,
    output wire  data_arvalid,
    input wire  data_arready,
    input wire [C_data_ID_WIDTH-1 : 0] data_rid,
    input wire [C_data_DATA_WIDTH-1 : 0] data_rdata,
    input wire [1 : 0] data_rresp,
    input wire  data_rlast,
    input wire [C_data_RUSER_WIDTH-1 : 0] data_ruser,
    input wire  data_rvalid,
    output wire  data_rready);
    
    // Nets.
    wire [C_registers_DATA_WIDTH-1:0] burst_size_reg;
    wire [C_registers_DATA_WIDTH-1:0] transfer_size_reg;
    wire [C_registers_DATA_WIDTH-1:0] write_address_reg;
    wire [C_registers_DATA_WIDTH-1:0] read_address_reg;
    wire [C_registers_DATA_WIDTH-1:0] write_coherent_flag_reg;
    wire [C_registers_DATA_WIDTH-1:0] read_coherent_flag_reg;
    wire data_enable;
    wire write_ready;
    wire read_ready;
    wire [C_registers_DATA_WIDTH-1:0] burst_length_con;
    wire [C_registers_DATA_WIDTH-1:0] write_address_con;
    wire [C_registers_DATA_WIDTH-1:0] read_address_con;
    wire [C_registers_DATA_WIDTH-1:0] write_coherency_flag_con;
    wire [C_registers_DATA_WIDTH-1:0] read_coherency_flag_con;
    
    // Controller instantiation.
    controller_module #(
        .C_registers_DATA_WIDTH(C_registers_DATA_WIDTH),
        .C_data_ADDR_WIDTH(C_data_ADDR_WIDTH)) 
    controller_inst (
        .aclk(aclk),
        .aresetn(aresetn),
        .enable(enable),
        .ready(ready),
        .burst_size_reg(burst_size_reg),
        .transfer_size_reg(transfer_size_reg),
        .write_address_reg(write_address_reg),
        .read_address_reg(read_address_reg),
        .write_coherent_flag_reg(write_coherent_flag_reg),
        .read_coherent_flag_reg(read_coherent_flag_reg),
        .data_enable(data_enable),
        .write_ready(write_ready),
        .read_ready(read_ready),
        .burst_length_con(burst_length_con),
        .write_address_con(write_address_con),
        .read_address_con(read_address_con),
        .write_coherency_flag_con(write_coherency_flag_con),
        .read_coherency_flag_con(read_coherency_flag_con));
        
    // Register instantiation.
    registers_module #(
        .C_registers_DATA_WIDTH(C_registers_DATA_WIDTH),
        .C_registers_ADDR_WIDTH(C_registers_ADDR_WIDTH))
    registers_inst (
        .aclk(aclk),
        .aresetn(aresetn),
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
        .registers_rready(registers_rready),
        .burst_size_reg(burst_size_reg),
        .transfer_size_reg(transfer_size_reg),
        .write_address_reg(write_address_reg),
        .read_address_reg(read_address_reg),
        .write_coherent_flag_reg(write_coherent_flag_reg),
        .read_coherent_flag_reg(read_coherent_flag_reg));

    // data_inst
    data_module #(
        .C_registers_DATA_WIDTH(C_registers_DATA_WIDTH),
        .C_data_ID(C_data_ID),
        .C_data_ID_WIDTH(C_data_ID_WIDTH),
        .C_data_ADDR_WIDTH(C_data_ADDR_WIDTH),
        .C_data_DATA_WIDTH(C_data_DATA_WIDTH),
        .C_data_AWUSER_WIDTH(C_data_AWUSER_WIDTH),
        .C_data_ARUSER_WIDTH(C_data_ARUSER_WIDTH),
        .C_data_WUSER_WIDTH(C_data_WUSER_WIDTH),
        .C_data_RUSER_WIDTH(C_data_RUSER_WIDTH),
        .C_data_BUSER_WIDTH(C_data_BUSER_WIDTH),
        .BUFFER_SIZE(BUFFER_SIZE))
    data_inst (
        .aclk(aclk),
        .aresetn(aresetn),
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
        .enable(data_enable),
        .write_ready(write_ready),
        .read_ready(read_ready),
        .write_address_con(write_address_con),
        .read_address_con(read_address_con),
        .write_coherency_flag_con(write_coherency_flag_con),
        .read_coherency_flag_con(read_coherency_flag_con),
        .burst_length_con(burst_length_con));
    
endmodule
