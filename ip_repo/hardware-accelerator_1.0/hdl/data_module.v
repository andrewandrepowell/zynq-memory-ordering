`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2015 09:42:43 PM
// Design Name: 
// Module Name: data_module
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


module data_module #(
    // Parameters of Axi Slave Bus Interface registers
    parameter integer C_registers_DATA_WIDTH	= 32,

    // Parameters of Axi Master Bus Interface data
    parameter integer C_data_ID	= 0,
    parameter integer C_data_ID_WIDTH	= 1,
    parameter integer C_data_ADDR_WIDTH	= 32,
    parameter integer C_data_DATA_WIDTH	= 32,
    parameter integer C_data_AWUSER_WIDTH	= 0,
    parameter integer C_data_ARUSER_WIDTH	= 0,
    parameter integer C_data_WUSER_WIDTH	= 0,
    parameter integer C_data_RUSER_WIDTH	= 0,
    parameter integer C_data_BUSER_WIDTH	= 0,
    
    // Misc.
    parameter integer BUFFER_SIZE = 4)(
    
    // Synchronization interface.
    input wire  aclk,
    input wire  aresetn,
    
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
    output reg  data_awvalid = 0,
    input wire  data_awready,
    output reg [C_data_DATA_WIDTH-1 : 0] data_wdata = 0,
    output wire [C_data_DATA_WIDTH/8-1 : 0] data_wstrb,
    output reg  data_wlast = 0,
    output wire [C_data_WUSER_WIDTH-1 : 0] data_wuser,
    output reg  data_wvalid = 0,
    input wire  data_wready,
    input wire [C_data_ID_WIDTH-1 : 0] data_bid,
    input wire [1 : 0] data_bresp,
    input wire [C_data_BUSER_WIDTH-1 : 0] data_buser,
    input wire  data_bvalid,
    output reg  data_bready = 0,
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
    output reg  data_arvalid = 0,
    input wire  data_arready,
    input wire [C_data_ID_WIDTH-1 : 0] data_rid,
    input wire [C_data_DATA_WIDTH-1 : 0] data_rdata,
    input wire [1 : 0] data_rresp,
    input wire  data_rlast,
    input wire [C_data_RUSER_WIDTH-1 : 0] data_ruser,
    input wire  data_rvalid,
    output reg  data_rready = 0,
    
    // Misc.
    input wire enable,
    output reg write_ready = 0,
    output reg read_ready = 0,
    input wire [C_registers_DATA_WIDTH-1:0] write_address_con,
    input wire [C_registers_DATA_WIDTH-1:0] read_address_con,
    input wire [C_registers_DATA_WIDTH-1:0] write_coherency_flag_con,
    input wire [C_registers_DATA_WIDTH-1:0] read_coherency_flag_con,
    input wire [C_registers_DATA_WIDTH-1:0] burst_length_con);
    
    // This function was simply taken from the Xilinx example.
    function integer clogb2 (input integer bit_depth);              
        begin                                                           
            for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
                bit_depth = bit_depth >> 1;                                 
        end                                                           
    endfunction  
    integer each_word;
    
    reg [C_registers_DATA_WIDTH-1:0] write_data_ptr = 0;
    reg [C_registers_DATA_WIDTH-1:0] read_data_ptr = 0;
    reg [C_data_DATA_WIDTH-1 : 0] data_buffer [0:BUFFER_SIZE-1];
    initial for (each_word=0; each_word<BUFFER_SIZE; each_word=each_word+1)
        data_buffer[each_word] <= 0;
    
    // Read FSM.
    localparam RS_ENABLE=0,RS_ADDRESS=1,RS_DATA=2,RS_READY=3;
    reg [1:0] read_state = RS_ENABLE;
    reg data_rlast_buff = 0;
    assign data_arid = C_data_ID;
    assign data_araddr = read_address_con;
    assign data_arlen = burst_length_con-1;
    assign data_arsize = clogb2((C_data_DATA_WIDTH/8)-1);
    assign data_arburst = 2'b01;
    assign data_arlock = 1'b0;
    assign data_arcache = 4'b0011;
    assign data_arprot = 3'b000;
    assign data_arqos = 4'b0000;
    assign data_aruser = read_coherency_flag_con[0];
    always @(posedge aclk)
        if (aresetn==0) begin
            read_state <= RS_ENABLE;
            data_arvalid <= 0;
            data_rready <= 0;
            read_data_ptr <= 0;
            read_ready <= 0;
            data_rlast_buff <= 0;
            for (each_word=0; each_word<BUFFER_SIZE; each_word=each_word+1)
                data_buffer[each_word] <= 0;
        end else
            case (read_state)
            RS_ENABLE:
                begin
                    // Wait until the controller says to start
                    // to begin.
                    read_ready <= 0;
                    if (enable==1) begin
                        read_state <= RS_ADDRESS;
                    end
                end
            RS_ADDRESS:
                // Perform handshake with slave to begin
                // the transaction.
                if (data_arvalid==1 && data_arready==1) begin
                    data_arvalid <= 0;
                    read_state <= RS_DATA;
                end else begin
                    data_arvalid <= 1;
                end
            RS_DATA:
                begin
                    // Sample data into buffer on successful handshake.
                    if (data_rready==1 && data_rvalid==1) begin
                        if ((data_rlast==1)&&(data_rlast_buff==0)) begin
                            data_rlast_buff <= 1;
                            read_data_ptr <= 0;
                        end else begin
                            read_data_ptr <= read_data_ptr+1;
                        end
                        data_buffer[read_data_ptr%BUFFER_SIZE] <= data_rdata;
                    end
                    // Only set the ready flag when there is available 
                    // space in buffer.
                    if ((((read_data_ptr+1)%BUFFER_SIZE)!=
                            (write_data_ptr%BUFFER_SIZE))&&
                            (data_rlast_buff==0)) begin
                        data_rready <= 1;
                    end else begin
                        data_rready <= 0;
                    end
                    // Bufferring when rlast is high necessary
                    // to ensure the state changes correctly.
                    if (data_rlast_buff==1) begin
                        data_rlast_buff <= 0;
                        read_state <= RS_READY;
                    end
                end
            RS_READY:
                begin
                    // Indicate to the controller the transaction's 
                    // completion.
                    read_ready <= 1;
                    if (enable==0) begin
                        read_state <= RS_ENABLE;
                    end
                end
            default: read_state <= RS_ENABLE;
            endcase
    
    // Write FSM.
    localparam WS_ENABLE=0,WS_ADDRESS=1,WS_DATA=2,WS_RESPONSE=3,WS_READY=4;
    reg [2:0] write_state = WS_ENABLE;
    assign data_awid = C_data_ID;
    assign data_awaddr = write_address_con;
    assign data_awlen = burst_length_con-1;
    assign data_awsize = clogb2((C_data_DATA_WIDTH/8)-1);
    assign data_awburst = 2'b01;
    assign data_awlock = 1'b0;
    assign data_awcache = 4'b0011;
    assign data_awprot = 3'b000;
    assign data_awqos = 4'b0000;
    assign data_awuser = write_coherency_flag_con[0];
    assign data_wstrb = {(C_data_DATA_WIDTH/8){1'b1}};
    always @(posedge aclk)
        if (aresetn==0) begin
            write_state <= WS_ENABLE;
            data_awvalid <= 0;
            data_wvalid <= 0;
            data_wlast <= 0;
            data_wdata <= 0;
            data_bready <= 0;
            write_data_ptr <= 0;
            write_ready <= 0;
        end else
            case (write_state)
            WS_ENABLE:
                begin
                    // Wait until the controller says to start
                    // to begin.
                    write_ready <= 0;
                    if (enable==1) begin
                        write_state <= WS_ADDRESS;
                    end
                end
            WS_ADDRESS:
                // Perform handshake with slave to begin
                // the transaction.
                if (data_awvalid==1 && data_awready==1) begin
                    data_awvalid <= 0;
                    write_state <= WS_DATA;
                end else begin
                    data_awvalid <= 1;
                end
            WS_DATA:
                begin
                    // Write data to slave interface, but only when
                    // data is available in the data buffer.
                    if (data_wvalid==1 && data_wready==1) begin
                        if (data_wlast==1) begin
                            data_wlast <= 0;
                            write_data_ptr <= 0;
                            write_state <= WS_RESPONSE;
                        end else begin
                            write_data_ptr <= write_data_ptr+1;
                        end
                        data_wvalid <= 0;
                    end else if ((write_data_ptr%BUFFER_SIZE)!=
                            (read_data_ptr%BUFFER_SIZE)) begin
                        if (write_data_ptr==(burst_length_con-1)) begin
                            data_wlast <= 1;
                        end
                        data_wvalid <= 1;
                    end
                    data_wdata <= data_buffer[write_data_ptr%BUFFER_SIZE];
                end
            WS_RESPONSE:
                // Send the response.
                if (data_bready==1 && data_bvalid==1) begin
                    data_bready <= 0;
                    write_state <= WS_READY;
                end else begin
                    data_bready <= 1;
                end
            WS_READY:
                begin
                    // Indicate to the controller the transaction's 
                    // completion.
                    write_ready <= 1;
                    if (enable==0) begin
                        write_state <= WS_ENABLE;
                    end
                end
            default: write_state <= WS_ENABLE;
            endcase
            
    
    
endmodule
