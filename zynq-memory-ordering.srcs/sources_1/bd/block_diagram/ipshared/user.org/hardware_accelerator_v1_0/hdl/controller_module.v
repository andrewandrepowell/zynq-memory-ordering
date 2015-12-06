`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2015 09:42:43 PM
// Design Name: 
// Module Name: controller_module
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


module controller_module #(
    // Parameters of Axi Slave Bus Interface registers
    parameter integer C_registers_DATA_WIDTH = 32,
    
    // Parameters of Axi Master Bus Interface data
    parameter integer C_data_ADDR_WIDTH	= 32) (
    
    // Synchronization interface.
    input wire aclk,
    input wire aresetn,
    input wire enable,
    output reg ready = 0,
    
    // Register interface.
    input wire [C_registers_DATA_WIDTH-1:0] burst_size_reg,
    input wire [C_registers_DATA_WIDTH-1:0] transfer_size_reg,
    input wire [C_registers_DATA_WIDTH-1:0] write_address_reg,
    input wire [C_registers_DATA_WIDTH-1:0] read_address_reg,
    input wire [C_registers_DATA_WIDTH-1:0] write_coherent_flag_reg,
    input wire [C_registers_DATA_WIDTH-1:0] read_coherent_flag_reg,
    
    // Data interface.
    output reg data_enable = 0,
    input wire write_ready,
    input wire read_ready,
    output reg [C_registers_DATA_WIDTH-1:0] burst_length_con = 0,
    output wire [C_registers_DATA_WIDTH-1:0] write_address_con,
    output wire [C_registers_DATA_WIDTH-1:0] read_address_con,
    output reg [C_registers_DATA_WIDTH-1:0] write_coherency_flag_con = 0,
    output reg [C_registers_DATA_WIDTH-1:0] read_coherency_flag_con = 0);
    
    // Nets and assignments.
    localparam BITS_PER_BYTE = 8;
    localparam BYTES_PER_WORD = C_registers_DATA_WIDTH/BITS_PER_BYTE;
    localparam CS_ENABLE=0,CS_CHECK=1,CS_COPY=2,CS_READY=3;
    reg [1:0] controller_state = CS_ENABLE;
    reg [C_data_ADDR_WIDTH-1:0] transfer_size_buff = 0;
    reg [C_data_ADDR_WIDTH-1:0] offset_ptr = 0;
    reg [C_registers_DATA_WIDTH-1:0] write_address_con_buff = 0;
    reg [C_registers_DATA_WIDTH-1:0] read_address_con_buff = 0;
    assign write_address_con = write_address_con_buff+offset_ptr;
    assign read_address_con = read_address_con_buff+offset_ptr;
    
    // Controller FSM.
    always @(posedge aclk)
        if (aresetn==0) begin
            ready <= 0;
            offset_ptr <= 0;
            burst_length_con <= 0;
            write_address_con_buff <= 0;
            read_address_con_buff <= 0;
            write_coherency_flag_con <= 0;
            read_coherency_flag_con <= 0;
            transfer_size_buff <= 0;
            data_enable <= 0;
        end else
            case (controller_state)
            CS_ENABLE:
                begin
                    // Wait until the hardware accelerator is enabled,
                    // and then sample registers.
                    ready <= 0;
                    if (enable==1) begin
                        offset_ptr <= 0;
                        burst_length_con <= burst_size_reg;
                        write_address_con_buff <= write_address_reg;
                        read_address_con_buff <= read_address_reg;
                        write_coherency_flag_con <= write_coherent_flag_reg;
                        read_coherency_flag_con <= read_coherent_flag_reg;
                        transfer_size_buff <= transfer_size_reg;
                        controller_state <= CS_CHECK;
                    end
                end
            CS_CHECK:
                // Check and see if all the data has been
                // transferred. 
                if (offset_ptr>=transfer_size_buff) begin
                    controller_state <= CS_READY;
                end else begin
                    controller_state <= CS_COPY;
                end
            CS_COPY:
                // Perform the copy operation. 
                if (data_enable==1 && write_ready==1 && read_ready==1) begin
                    data_enable <= 0;
                    offset_ptr <= offset_ptr+(burst_length_con*BYTES_PER_WORD);
                    controller_state <= CS_CHECK;
                end else begin
                    data_enable <= 1;
                end
            CS_READY:
                begin
                    // Signal when the hardware accelerator is ready.
                    ready <= 1;
                    if (enable==0) begin
                        controller_state <= CS_ENABLE;
                    end
                end
            default: controller_state <= CS_ENABLE;
            endcase
endmodule
