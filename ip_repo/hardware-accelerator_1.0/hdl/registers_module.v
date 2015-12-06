`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2015 09:42:43 PM
// Design Name: 
// Module Name: registers_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module registers_module #(
    // Parameters of Axi Slave Bus Interface registers
    parameter integer C_registers_DATA_WIDTH	= 32,
    parameter integer C_registers_ADDR_WIDTH	= 5)(

    // Synchronization interface.
    input wire  aclk,
    input wire  aresetn,

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
    output reg [C_registers_DATA_WIDTH-1 : 0] registers_rdata = 0,
    output wire [1 : 0] registers_rresp,
    output wire  registers_rvalid,
    input wire  registers_rready,
    
    // Register interface.
    output reg [C_registers_DATA_WIDTH-1 : 0] burst_size_reg = 0,
    output reg [C_registers_DATA_WIDTH-1 : 0] transfer_size_reg = 0,
    output reg [C_registers_DATA_WIDTH-1 : 0] write_address_reg = 0,
    output reg [C_registers_DATA_WIDTH-1 : 0] read_address_reg = 0,
    output reg [C_registers_DATA_WIDTH-1 : 0] write_coherent_flag_reg = 0,
    output reg [C_registers_DATA_WIDTH-1 : 0] read_coherent_flag_reg = 0);
    
    // Information needed for all state machines.
    localparam BITS_PER_BYTE = 8;
    localparam BYTES_PER_WORD = C_registers_DATA_WIDTH/8;
    localparam REG_BURST_SIZE=0,REG_TRANSFER_SIZE=1,
        REG_WRITE_ADDRESS=2,REG_READ_ADDRESS=3,
        REG_WRITE_COHERENT_FLAG=4,REG_READ_COHERENT_FLAG=5;
    integer each_bit;
    
    // Write state machine.
    localparam WS_ADDRESS=0,WS_CHECK=1,WS_DATA=2,WS_RESPONSE=3;
    reg [1:0] write_state = WS_ADDRESS;
    reg registers_awready_buff = 0;
    reg [C_registers_ADDR_WIDTH-1 : 0] registers_awaddr_buff = 0;
    reg [2 : 0] registers_awprot_buff = 0;
    reg registers_wready_buff = 0;
    reg registers_bvalid_buff = 0;
    reg [1 : 0] registers_bresp_buff = 0;
    wire [(C_registers_ADDR_WIDTH-2)-1 : 0] registers_awaddr_select;
    assign registers_awready = registers_awready_buff;
    assign registers_wready = registers_wready_buff;
    assign registers_bvalid = registers_bvalid_buff;
    assign registers_bresp = registers_bresp_buff;
    assign registers_awaddr_select = registers_awaddr_buff[C_registers_ADDR_WIDTH-1:2];
    always @(posedge aclk) 
        if (aresetn==0) begin
            write_state <= WS_ADDRESS;
            registers_awready_buff <= 0;
            registers_awaddr_buff <= 0;
            registers_awprot_buff <= 0;
            registers_wready_buff <= 0;
            registers_bvalid_buff <= 0;
            registers_bresp_buff <= 0;
            burst_size_reg <= 0;
            transfer_size_reg <= 0;
            write_address_reg <= 0;
            read_address_reg <= 0;
            write_coherent_flag_reg <= 0;
            read_coherent_flag_reg <= 0;
        end else
            case (write_state)
            WS_ADDRESS: 
                // Sample from address channel.
                if (registers_awready_buff==1 && registers_awvalid==1) begin
                    registers_awready_buff <= 0;
                    registers_awaddr_buff <= registers_awaddr;
                    registers_awprot_buff <= registers_awprot;
                    write_state <= WS_CHECK;
                end else begin
                    registers_awready_buff <= 1;
                end
            WS_CHECK:
                // Determine if there are any errors. 
                begin
                    if ((registers_awaddr_buff[1:0]!=2'b00) || 
                            (registers_awprot_buff[2]!=0)) begin
                        registers_bresp_buff <= 2'b10;
                    end else begin
                        registers_bresp_buff <= 2'b00;
                    end 
                    write_state <= WS_DATA;
                end
            WS_DATA:
                // Check for valid data in the data channel.
                if (registers_wready_buff==1 && registers_wvalid==1) begin
                    // Only store data for each valid byte.
                    for (each_bit=0; each_bit<BYTES_PER_WORD; each_bit=each_bit+1) begin
                        if (registers_wstrb[each_bit]==1) begin
                            // Update the register corresponding to the address.
                            if (registers_awaddr_select==REG_BURST_SIZE) begin
                                burst_size_reg[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE] <=
                                    registers_wdata[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE];
                            end else if (registers_awaddr_select==REG_TRANSFER_SIZE) begin
                                transfer_size_reg[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE] <=
                                    registers_wdata[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE];
                            end else if (registers_awaddr_select==REG_WRITE_ADDRESS) begin
                                write_address_reg[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE] <=
                                    registers_wdata[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE];
                            end else if (registers_awaddr_select==REG_READ_ADDRESS) begin
                                read_address_reg[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE] <=
                                    registers_wdata[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE];
                            end else if (registers_awaddr_select==REG_WRITE_COHERENT_FLAG) begin
                                write_coherent_flag_reg[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE] <=
                                    registers_wdata[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE];
                            end else if (registers_awaddr_select==REG_READ_COHERENT_FLAG) begin
                                read_coherent_flag_reg[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE] <=
                                    registers_wdata[BITS_PER_BYTE*each_bit +: BITS_PER_BYTE];
                            end
                        end
                    end
                    registers_wready_buff <= 0;
                    write_state <= WS_RESPONSE;
                end else begin
                    registers_wready_buff <= 1;
                end
            WS_RESPONSE:
                // Transmit the write response over the response channel.
                if (registers_bvalid_buff==1 && registers_bready==1) begin
                    registers_bvalid_buff <= 0;
                    write_state <= WS_ADDRESS;
                end else begin
                    registers_bvalid_buff <= 1;
                end
            default: write_state <= WS_ADDRESS;
            endcase
            
    // Read state machine
    localparam RS_ADDRESS=0,RS_CHECK=1,RS_DATA=2;
    reg [1:0] read_state = RS_ADDRESS;
    reg registers_arready_buff = 0;
    reg [C_registers_ADDR_WIDTH-1 : 0] registers_araddr_buff = 0;
    reg [2 : 0] registers_arprot_buff = 0;
    reg registers_rvalid_buff = 0;
    reg [1 : 0] registers_rresp_buff = 0;
    wire [(C_registers_ADDR_WIDTH-2)-1 : 0] registers_araddr_select;
    assign registers_arready = registers_arready_buff;
    assign registers_rvalid = registers_rvalid_buff;
    assign registers_rresp = registers_rresp_buff;
    assign registers_araddr_select = registers_araddr_buff[C_registers_ADDR_WIDTH-1:2];
    always @(posedge aclk) 
        if (aresetn==0) begin
            read_state <= RS_ADDRESS;
            registers_arready_buff <= 0;
            registers_araddr_buff <= 0;
            registers_arprot_buff <= 0;
            registers_rvalid_buff <= 0;
            registers_rdata <= 0;
        end else 
            case (read_state)
            RS_ADDRESS:
                // Sample from the address channel.
                if (registers_arready_buff==1 && registers_arvalid==1) begin
                    registers_arready_buff <= 0;
                    registers_araddr_buff <= registers_araddr;
                    registers_arprot_buff <= registers_arprot;
                    read_state <= RS_CHECK;
                end else begin
                    registers_arready_buff <= 1;
                end
            RS_CHECK:
                begin
                    // Check for errors.
                    if ((registers_araddr_buff[1:0] != 2'b00) ||
                            (registers_arprot_buff[2]!=0)) begin
                        registers_rresp_buff <= 2'b10;
                    end else begin
                        registers_rresp_buff <= 2'b00;
                    end
                    // Get the data ready for reading.
                    if (registers_araddr_select==REG_BURST_SIZE) begin
                         registers_rdata <= burst_size_reg;
                    end else if (registers_araddr_select==REG_TRANSFER_SIZE) begin
                        registers_rdata <= transfer_size_reg;
                    end else if (registers_araddr_select==REG_WRITE_ADDRESS) begin
                        registers_rdata <= write_address_reg;
                    end else if (registers_araddr_select==REG_READ_ADDRESS) begin
                        registers_rdata <= read_address_reg;
                    end else if (registers_araddr_select==REG_WRITE_COHERENT_FLAG) begin
                        registers_rdata <= write_coherent_flag_reg;
                    end else if (registers_araddr_select==REG_READ_COHERENT_FLAG) begin
                        registers_rdata <= read_coherent_flag_reg;
                    end
                    read_state <= RS_DATA;
                end
            RS_DATA:
                // Send read data through the data channel, including its response.
                if (registers_rvalid_buff==1 && registers_rready==1) begin
                    registers_rvalid_buff <= 0;
                    read_state <= RS_ADDRESS;
                end else begin
                    registers_rvalid_buff <= 1;
                end
            default: read_state <= RS_ADDRESS;
            endcase
endmodule
