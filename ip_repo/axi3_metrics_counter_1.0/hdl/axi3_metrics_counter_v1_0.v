
`timescale 1 ns / 1 ps

module axi4_metrics_counter_v1_0 #
(
    parameter integer C_s_axi_lite_DATA_WIDTH	= 32, // shouldn't change
    parameter integer C_s_axi_lite_ADDR_WIDTH	= 8,

    parameter integer C_axi4_monitor_ID_WIDTH	= 1,
    parameter integer C_axi4_monitor_DATA_WIDTH	= 32,
    parameter integer C_axi4_monitor_ADDR_WIDTH	= 6
)
(
    input wire  aclk,
    input wire  aresetn,
    
    input wire [C_s_axi_lite_ADDR_WIDTH-1 : 0] s_axi_lite_awaddr,
    input wire [2 : 0] s_axi_lite_awprot,
    input wire  s_axi_lite_awvalid,
    output reg  s_axi_lite_awready=0,
    input wire [C_s_axi_lite_DATA_WIDTH-1 : 0] s_axi_lite_wdata,
    input wire [(C_s_axi_lite_DATA_WIDTH/8)-1 : 0] s_axi_lite_wstrb,
    input wire  s_axi_lite_wvalid,
    output reg  s_axi_lite_wready=0,
    output wire [1 : 0] s_axi_lite_bresp,
    output reg  s_axi_lite_bvalid=0,
    input wire  s_axi_lite_bready,
    input wire [C_s_axi_lite_ADDR_WIDTH-1 : 0] s_axi_lite_araddr,
    input wire [2 : 0] s_axi_lite_arprot,
    input wire  s_axi_lite_arvalid,
    output reg  s_axi_lite_arready=0,
    output reg [C_s_axi_lite_DATA_WIDTH-1 : 0] s_axi_lite_rdata=0,
    output wire [1 : 0] s_axi_lite_rresp,
    output reg  s_axi_lite_rvalid=0,
    input wire  s_axi_lite_rready,
    
    input wire [C_axi4_monitor_ID_WIDTH-1 : 0] axi4_monitor_arid,
    input wire [C_axi4_monitor_ADDR_WIDTH-1 : 0] axi4_monitor_araddr,
    input wire [7 : 0] axi4_monitor_arlen,
    input wire [2 : 0] axi4_monitor_arsize,
    input wire [1 : 0] axi4_monitor_arburst,
    input wire  axi4_monitor_arlock,
    input wire [3 : 0] axi4_monitor_arcache,
    input wire [2 : 0] axi4_monitor_arprot,
    input wire  axi4_monitor_arvalid,
    input wire  axi4_monitor_arready,
    input wire [C_axi4_monitor_ID_WIDTH-1 : 0] axi4_monitor_awid,
    input wire [C_axi4_monitor_ADDR_WIDTH-1 : 0] axi4_monitor_awaddr,
    input wire [7 : 0] axi4_monitor_awlen,
    input wire [2 : 0] axi4_monitor_awsize,
    input wire [1 : 0] axi4_monitor_awburst,
    input wire  axi4_monitor_awlock,
    input wire [3 : 0] axi4_monitor_awcache,
    input wire [2 : 0] axi4_monitor_awprot,
    input wire  axi4_monitor_awvalid,
    input wire  axi4_monitor_awready,
    input wire [C_axi4_monitor_ID_WIDTH-1 : 0] axi4_monitor_bid,
    input wire [1 : 0] axi4_monitor_bresp,
    input wire  axi4_monitor_bvalid,
    input wire  axi4_monitor_bready,
    input wire [C_axi4_monitor_ID_WIDTH-1 : 0] axi4_monitor_rid,
    input wire [C_axi4_monitor_DATA_WIDTH-1 : 0] axi4_monitor_rdata,
    input wire [1 : 0] axi4_monitor_rresp,
    input wire  axi4_monitor_rlast,
    input wire  axi4_monitor_rvalid,
    input wire  axi4_monitor_rready,
    input wire [C_axi4_monitor_ID_WIDTH-1 : 0] axi4_monitor_wid,
    input wire [C_axi4_monitor_DATA_WIDTH-1 : 0] axi4_monitor_wdata,
    input wire [(C_axi4_monitor_DATA_WIDTH/8)-1 : 0] axi4_monitor_wstrb,
    input wire  axi4_monitor_wlast,
    input wire  axi4_monitor_wvalid,
    input wire  axi4_monitor_wready,
    
    input wire counter_start,
    input wire counter_finish
);

localparam C_state_width                        = 8;
localparam C_bits_per_byte                      = 8;
localparam C_bytes_per_word                     = (C_s_axi_lite_DATA_WIDTH/C_bits_per_byte);
localparam C_id_CONTROL                         = 0;
localparam C_id_LATENCY_TOTAL_WRITE             = C_id_CONTROL+1;
localparam C_id_LATENCY_TOTAL_READ              = C_id_LATENCY_TOTAL_WRITE+1;
localparam C_id_LATENCY_MIN_WRITE               = C_id_LATENCY_TOTAL_READ+1;
localparam C_id_LATENCY_MIN_READ                = C_id_LATENCY_MIN_WRITE+1;
localparam C_id_LATENCY_MAX_WRITE               = C_id_LATENCY_MIN_READ+1;
localparam C_id_LATENCY_MAX_READ                = C_id_LATENCY_MAX_WRITE+1;
localparam C_id_COUNTER                         = C_id_LATENCY_MAX_READ+1;
localparam C_id_TRANSACTION_TOTAL_WRITE         = C_id_COUNTER+1;
localparam C_id_TRANSACTION_TOTAL_READ          = C_id_TRANSACTION_TOTAL_WRITE+1;
localparam C_registers_total                    = 10;
localparam C_mask_CONTROL_RESET                 = 'h1;
localparam C_s_axi_lite_w_RECEIVE_ADDRESS       = 0;
localparam C_s_axi_lite_w_RECEIVE_WORD          = C_s_axi_lite_w_RECEIVE_ADDRESS+1;
localparam C_s_axi_lite_w_CHECK                 = C_s_axi_lite_w_RECEIVE_WORD+1;
localparam C_s_axi_lite_r_RECEIVE_ADDRESS       = 0;
localparam C_s_axi_lite_r_TRANSFER_WORD         = C_s_axi_lite_r_RECEIVE_ADDRESS+1;

reg [C_s_axi_lite_DATA_WIDTH-1:0]   registers                   [0:C_registers_total-1];
reg                                 flag_reset_metrics          = 0;
reg [C_state_width-1:0]             s_axi_lite_w_state          = 0;
reg [C_s_axi_lite_ADDR_WIDTH-1 : 0] s_axi_lite_awaddr_reg       = 0;
reg [C_state_width-1:0]             s_axi_lite_r_state          = 0;
reg [C_s_axi_lite_ADDR_WIDTH-1 : 0] s_axi_lite_araddr_reg       = 0;
reg [C_s_axi_lite_DATA_WIDTH-1:0]   w_latency_current_counter   = 0;
reg                                 w_latency_flag_counting     = 0;
reg [C_s_axi_lite_DATA_WIDTH-1:0]   r_latency_current_counter   = 0;
reg                                 r_latency_flag_counting     = 0;

integer i;

assign s_axi_lite_bresp = 'b0;
assign s_axi_lite_rresp = 'b0;

initial
    for (i=0;i<C_registers_total;i=i+1)
        registers[i] <= 0;
        
// Axi lite w FSM
always @(posedge aclk)
    if (aresetn==0) begin
        s_axi_lite_w_state <= C_s_axi_lite_w_RECEIVE_ADDRESS;
        s_axi_lite_awready <= 0;
        s_axi_lite_awaddr_reg <= 0;
        s_axi_lite_wready <= 0;
        s_axi_lite_bvalid <= 0;
        flag_reset_metrics <= 0;
    end
    else
        case (s_axi_lite_w_state)
        C_s_axi_lite_w_RECEIVE_ADDRESS: begin
            if (s_axi_lite_awready==0) begin
                s_axi_lite_awready <= 1;
            end
            else if (s_axi_lite_awvalid==1) begin
                s_axi_lite_awready <= 0;
                s_axi_lite_awaddr_reg <= s_axi_lite_awaddr;
                s_axi_lite_w_state <= C_s_axi_lite_w_RECEIVE_WORD;
            end
        end
        C_s_axi_lite_w_RECEIVE_WORD: begin
            if (s_axi_lite_wready==0) begin
                s_axi_lite_wready <= 1;
            end
            else if (s_axi_lite_wvalid==1) begin
                s_axi_lite_wready <= 0;
                if ((s_axi_lite_awaddr_reg/C_bytes_per_word)==C_id_CONTROL) begin
                    if (C_mask_CONTROL_RESET&s_axi_lite_wdata) begin
                        flag_reset_metrics <= 1;
                    end
                end
                s_axi_lite_w_state <= C_s_axi_lite_w_CHECK;
            end
        end
        C_s_axi_lite_w_CHECK: begin
            flag_reset_metrics <= 0;
            if (s_axi_lite_bvalid==0) begin
                s_axi_lite_bvalid <= 1;
            end
            else if (s_axi_lite_bready==1) begin
                s_axi_lite_bvalid <= 0;
                s_axi_lite_w_state <= C_s_axi_lite_w_RECEIVE_ADDRESS;
            end
        end
        endcase
        
// Axi lite r FSM
always @(posedge aclk)
    if (aresetn==0) begin
        s_axi_lite_r_state <= C_s_axi_lite_r_RECEIVE_ADDRESS;
        s_axi_lite_arready <= 0;
        s_axi_lite_araddr_reg <= 0;
        s_axi_lite_rdata <= 0;
        s_axi_lite_rvalid <= 0;
    end
    else
        case (s_axi_lite_r_state)
        C_s_axi_lite_r_RECEIVE_ADDRESS: begin
            if (s_axi_lite_arready==0) begin
                s_axi_lite_arready <= 1;
            end
            else if (s_axi_lite_arvalid==1) begin
                s_axi_lite_arready <= 0;
                s_axi_lite_araddr_reg <= s_axi_lite_araddr;
                s_axi_lite_r_state <= C_s_axi_lite_r_TRANSFER_WORD;
            end
        end
        C_s_axi_lite_r_TRANSFER_WORD: begin
            if (s_axi_lite_rvalid==0) begin
                s_axi_lite_rvalid <= 1;
                s_axi_lite_rdata <= registers[s_axi_lite_araddr_reg/C_bytes_per_word];
            end
            else if (s_axi_lite_rready==1) begin
                s_axi_lite_rvalid <= 0;
                s_axi_lite_r_state <= C_s_axi_lite_r_RECEIVE_ADDRESS;
            end
        end
        endcase

// Writing latency
always @(posedge aclk) 
    if ((aresetn==0)||(flag_reset_metrics==1)) begin
        w_latency_current_counter <= 0;
        w_latency_flag_counting <= 0;
        registers[C_id_LATENCY_TOTAL_WRITE] <= 0;
        registers[C_id_LATENCY_MIN_WRITE] <= (2**C_s_axi_lite_DATA_WIDTH)-1;
        registers[C_id_LATENCY_MAX_WRITE] <= 0;
        registers[C_id_TRANSACTION_TOTAL_WRITE] <= 0;
    end 
    else begin
        if (w_latency_flag_counting==0) begin
            if (axi4_monitor_awvalid==1) begin
                w_latency_flag_counting <= 1;
            end
            w_latency_current_counter <= 0;
        end 
        else begin
            if ((axi4_monitor_bvalid==1)&&(axi4_monitor_bready==1)) begin
                w_latency_flag_counting <= 0;
                registers[C_id_LATENCY_TOTAL_WRITE] <= registers[C_id_LATENCY_TOTAL_WRITE]+w_latency_current_counter;
                if (w_latency_current_counter<registers[C_id_LATENCY_MIN_WRITE]) begin
                    registers[C_id_LATENCY_MIN_WRITE] <= w_latency_current_counter;
                end
                if (w_latency_current_counter>registers[C_id_LATENCY_MAX_WRITE]) begin
                    registers[C_id_LATENCY_MAX_WRITE] <= w_latency_current_counter;
                end
                registers[C_id_TRANSACTION_TOTAL_WRITE] <= registers[C_id_TRANSACTION_TOTAL_WRITE]+1;
            end
            w_latency_current_counter <= w_latency_current_counter+1;
        end
    end
    
// Reading latency
always @(posedge aclk) 
    if ((aresetn==0)||(flag_reset_metrics==1)) begin
        r_latency_current_counter <= 0;
        r_latency_flag_counting <= 0;
        registers[C_id_LATENCY_TOTAL_READ] <= 0;
        registers[C_id_LATENCY_MIN_READ] <= (2**C_s_axi_lite_DATA_WIDTH)-1;
        registers[C_id_LATENCY_MAX_READ] <= 0;
        registers[C_id_TRANSACTION_TOTAL_READ] <= 0;
    end 
    else begin
        if (r_latency_flag_counting==0) begin
            if (axi4_monitor_arvalid==1) begin
                r_latency_flag_counting <= 1;
            end
            r_latency_current_counter <= 0;
        end 
        else begin
            if ((axi4_monitor_rlast==1)&&(axi4_monitor_rvalid==1)&&(axi4_monitor_rready==1)) begin
                r_latency_flag_counting <= 0;
                registers[C_id_LATENCY_TOTAL_READ] <= registers[C_id_LATENCY_TOTAL_READ]+r_latency_current_counter;
                if (r_latency_current_counter<registers[C_id_LATENCY_MIN_READ]) begin
                    registers[C_id_LATENCY_MIN_READ] <= r_latency_current_counter;
                end
                if (r_latency_current_counter>registers[C_id_LATENCY_MAX_READ]) begin
                    registers[C_id_LATENCY_MAX_READ] <= r_latency_current_counter;
                end
                registers[C_id_TRANSACTION_TOTAL_READ] <= registers[C_id_TRANSACTION_TOTAL_READ]+1;
            end
            r_latency_current_counter <= r_latency_current_counter+1;
        end
    end
    
// Counter
always @(posedge aclk) 
    if ((aresetn==0)||(flag_reset_metrics==1)) begin
        registers[C_id_COUNTER] <= 0;
    end
    else begin
        if ((counter_start==1)&&(counter_finish==0)) begin
            registers[C_id_COUNTER] <= registers[C_id_COUNTER]+1;
        end
    end

endmodule
