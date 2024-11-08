`timescale 1ns / 1ps





module controller(
    input clk_100MHz,
    input RST,
    input rx,           // B18
    output tx,          // A18
    output rx_busy,     // U16
    output converted,   // E19
    output data_valid,  // U19
    output tx_busy,    // V19
    output [7:0] cathodes,
    output [3:0] anodes
);
    
    // FSM states
    localparam RX_NUM_1_LB = 0; // Receive low-byte of first number
    localparam RX_NUM_1_HB = 1; // Receive high-byte of first number
    localparam RX_NUM_2_LB = 2; // Receive low-byte of second number
    localparam RX_NUM_2_HB = 3; // Receive high-byte of second number
    localparam TX_NUM_1 = 4;    // Send high byte of sum
    localparam TX_NUM_2 = 5;    // Send low byte of sum
    localparam TX_NUM_3 = 6;    // Send high byte of sum
    localparam TX_NUM_4 = 7; 
    localparam TX_NUM_5 = 8;    // Send high byte of sum
    localparam TX_NUM_6 = 9; 
    localparam TX_NUM_7 = 10;    // Send high byte of sum
    localparam TX_NUM_8 = 11; 
    // Local control logic variables
    // FSM state
    reg [3:0] state;
    wire [63:0] key;
    // This variable is super critical in preventing wrong FSM state changes
    reg allow_next;     // Local signal to prevent race conditions 
    wire CHIP_SELECT_BAR;
    // IO related variables
    reg flush_ctrl;     // Flush the RX data after reading
    reg tx_enable_ctrl; // Allow tranmission of output, after data is settled
    
    wire [7:0] uart_data;   // The actual RX UART data
    reg [7:0] out_data;     // The data that will be sent over TX
    reg [7:0] byte_buffer;  // Store low byte of the second number 
    //reg [15:0] sum;
    reg [63:0] result;  
    reg [15:0] data1;
    reg [15:0] data2;
    //reg [63:0] plain_text;       // Store the actual sum and incoming data
    wire [63:0]cipher;
    // UART clock related variables
    reg clk_uart;           // (100MHz) / (BAUD_RATE*OVERSAMPLING*2) 
    reg [6:0] counter;
    assign key = 64'd1000;
    // See UART RX module

ila_0 your_instance_name (
	.clk(clk_100MHz), // input wire clk


	.probe0(data1), // input wire [15:0]  probe0  
	.probe1(data2), // input wire [15:0]  probe1 
	.probe2(key), // input wire [63:0]  probe2 
	.probe3(result), // input wire [63:0]  probe3 
	.probe4(cipher) // input wire [63:0]  probe4
);

    uart_rx uart_rx_115200 (
        .rx(rx),
        .i_clk(clk_uart),
        .flush(flush_ctrl),
        .data(uart_data),
        .converted(converted),
        .data_valid(data_valid),
        .busy(rx_busy)
    );
    
    Des_Top des(.CLK(clk_uart), .RST(RST), .CHIP_SELECT_BAR(CHIP_SELECT_BAR), .PLAIN_TEXT(result), .CIPHER_TEXT(cipher),.KEY(key));
    
    // See UART TX module
    uart_tx uart_tx_115200(
        .clk(clk_uart),
        .tx_enable(tx_enable_ctrl),
        .data(out_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );
 
    /*seven_seg_drive #(
        .INPUT_WIDTH(16),
        .SEV_SEG_PRESCALAR(18)
    ) display (
        .i_clk(clk_100MHz),
        .number(sum[9:0]),
        .decimal_points(4'h0),
        .anodes(anodes),
        .cathodes(cathodes)
    );*/
    
    initial begin
        counter = 0;
        clk_uart = 0;
        
        flush_ctrl = 0;
        tx_enable_ctrl = 0;
        
        //sum = 0;
        out_data = 0;
        byte_buffer = 0;
        
        state = RX_NUM_1_LB;
        allow_next = 0;
    end
    
    // Divided clock for UART @ 115200 baud
    always @(posedge clk_100MHz) begin
        counter <= counter + 1;
        
        if(counter == 7'd27) begin
            counter <= 0;
            clk_uart <= ~clk_uart;
        end
    end
    
    always @(posedge clk_uart) begin
        case(state)
            RX_NUM_1_LB: begin
                tx_enable_ctrl <= 0;
                
                if(converted) begin
                    //sum <= {8'b0, uart_data};
                    //result <= {48'b0,uart_data,uart_data};
                    result[7:0] <= uart_data;
                    data1[7:0] <= uart_data;
                    flush_ctrl <= 1;        // Flush UART RX registers
                    state <= RX_NUM_1_HB;
                end
            end

            RX_NUM_1_HB: begin
                // Once RX module has produced the final output(converted)
                // and registers are cleared(converted is set low), go ahead
                if(~flush_ctrl && ~converted)
                    allow_next <= 1;        // Allow RX after registers cleared
                    
                if(converted && ~flush_ctrl && allow_next) begin
                    //sum <= {uart_data, sum[7:0]};
                    //result <= {32'b0,uart_data,uart_data, result[15:0]};
                    result[15:8] <= uart_data;  // Place second byte in the next 8 bits
                    data1[15:8] <= uart_data;
                    flush_ctrl <= 1;        // Data read, flush RX register
                    allow_next <= 0;
                    state <= RX_NUM_2_LB;
                end
                else
                    flush_ctrl <= 0;
            end
            
            // These states are exactly the same as "RX_NUM_1_HB" state
            RX_NUM_2_LB: begin
                if(~flush_ctrl && ~converted)
                    allow_next <= 1;
                    
                if(converted && ~flush_ctrl && allow_next) begin
                    byte_buffer <= uart_data;
                    //result <= {16'b0,byte_buffer,byte_buffer, result[31:0]};
                    result[23:16] <= uart_data;  // Place third byte
                    data2[7:0] <= uart_data;
                    flush_ctrl <= 1;
                    allow_next <= 0;
                    state <= RX_NUM_2_HB;
                end
                else
                    flush_ctrl <= 0;
            end
            
            RX_NUM_2_HB: begin
                if(~flush_ctrl && ~converted)
                    allow_next <= 1;
                    
                if(converted && ~flush_ctrl && allow_next) begin
                    //sum <= sum + {uart_data, byte_buffer};
                    //result <= {uart_data,uart_data, result[47:0]};
                    result[31:24] <= uart_data;  // Place fourth byte, completing the first 32-bit word
                    data2[15:8] <= uart_data;
                    result <= {result[31:0],32'b0};
                    byte_buffer <= 0;
                    flush_ctrl <= 1;
                    allow_next <= 0;
                    state <= TX_NUM_1;
                end
                else
                    flush_ctrl <= 0;
            end

            // Calculations done, send data back
            TX_NUM_1: begin
                out_data <= cipher[63:56];
                
                // Once TX is complete, allow going to next state
                if(~tx_busy && ~allow_next)
                    tx_enable_ctrl <= 1;
                else begin
                    allow_next <= 1;
                    flush_ctrl <= 0;
                    tx_enable_ctrl <= 0;
                end
                
                // TX complete, go to next state
                if(~tx_busy && allow_next) begin
                    allow_next <= 0;
                    state <= TX_NUM_2;
                end
            end
            
            // Exactly the same as the previous state
            TX_NUM_2: begin
                out_data <= cipher[55:48];
                
                if(~tx_busy && ~allow_next)
                    tx_enable_ctrl <= 1;
                else begin
                    allow_next <= 1;
                    tx_enable_ctrl <= 0;
                end
                
                if(~tx_busy && allow_next) begin
                    allow_next <= 0;
                    state <= TX_NUM_3;
                end
            end
            
            TX_NUM_3: begin
                out_data <= cipher[47:40];
                
                if(~tx_busy && ~allow_next)
                    tx_enable_ctrl <= 1;
                else begin
                    allow_next <= 1;
                    tx_enable_ctrl <= 0;
                end
                
                if(~tx_busy && allow_next) begin
                    allow_next <= 0;
                    state <= TX_NUM_4;
                end
            end
            TX_NUM_4: begin
                out_data <= cipher[39:32];
                
                if(~tx_busy && ~allow_next)
                    tx_enable_ctrl <= 1;
                else begin
                    allow_next <= 1;
                    tx_enable_ctrl <= 0;
                end
                
                if(~tx_busy && allow_next) begin
                    allow_next <= 0;
                    state <= TX_NUM_5;
                end
            end
            TX_NUM_5: begin
                out_data <= cipher[31:24];
                
                if(~tx_busy && ~allow_next)
                    tx_enable_ctrl <= 1;
                else begin
                    allow_next <= 1;
                    tx_enable_ctrl <= 0;
                end
                
                if(~tx_busy && allow_next) begin
                    allow_next <= 0;
                    state <= TX_NUM_6;
                end
            end
            TX_NUM_6: begin
                out_data <= cipher[23:16];
                
                if(~tx_busy && ~allow_next)
                    tx_enable_ctrl <= 1;
                else begin
                    allow_next <= 1;
                    tx_enable_ctrl <= 0;
                end
                
                if(~tx_busy && allow_next) begin
                    allow_next <= 0;
                    state <= TX_NUM_7;
                end
            end
            TX_NUM_7: begin
                out_data <= cipher[15:8];
                
                if(~tx_busy && ~allow_next)
                    tx_enable_ctrl <= 1;
                else begin
                    allow_next <= 1;
                    tx_enable_ctrl <= 0;
                end
                
                if(~tx_busy && allow_next) begin
                    allow_next <= 0;
                    state <= TX_NUM_8;
                end
            end
            TX_NUM_8: begin
                out_data <= cipher[7:0];
                
                if(~tx_busy && ~allow_next)
                    tx_enable_ctrl <= 1;
                else begin
                    allow_next <= 1;
                    tx_enable_ctrl <= 0;
                end
                
                if(~tx_busy && allow_next) begin
                    allow_next <= 0;
                    state <= RX_NUM_1_LB;
                end
            end
        endcase
    end
endmodule