
module seven_seg_drive #(
    parameter INPUT_WIDTH = 15,
    SEV_SEG_PRESCALAR = 4
)(
    input                               i_clk,
    input       [INPUT_WIDTH-1:0]       number,
    input       [3:0]                   decimal_points,
    output reg  [3:0]                   anodes,
    output reg  [7:0]                   cathodes
);

    localparam [0:9][6:0] digit_to_logic_mapping = {      // This mapping is active low
            7'b0000001,     // 0
            7'b1001111,     // 1
            7'b0010010,     // 2
            7'b0000110,     // 3
            7'b1001100,     // 4
            7'b0100100,     // 5
            7'b0100000,     // 6
            7'b0001111,     // 7
            7'b0000000,     // 8
            7'b0000100      // 9
        };

    reg [3:0] i;
    reg [3:0][3:0] digits;                  // Store the BCD digits as they are converted
    reg [1:0] current_digit;                // Keep track of which display to activate

    reg clk;
    reg [SEV_SEG_PRESCALAR:0] local_counter;

    initial begin
        current_digit = 0;
        
        anodes = 4'b1111;
        cathodes = 8'b0;
        
        digits = {4'h0, 4'h0, 4'h0, 4'h0};

        clk = 0;
        local_counter = 0;
    end

    always @(posedge i_clk) begin
        local_counter <= local_counter + 1;

        if(local_counter == 1<<SEV_SEG_PRESCALAR) begin
            local_counter <= 0;
            clk <= ~clk;
        end
    end

    // Choosing which digit to display
    always @(posedge clk) begin
        current_digit <= current_digit + 1;
    end

    // Convert the integer to 4-digit BCD
    always @(posedge clk) begin        
       digits = {4'h0, 4'h0, 4'h0, 4'h0};
        
       for(i = 0; i < 15; i = i + 1) begin

           digits[3]   = (digits[3] >= 5)? digits[3] + 3 : digits[3];
           digits[2]   = (digits[2] >= 5)? digits[2] + 3 : digits[2];
           digits[1]   = (digits[1] >= 5)? digits[1] + 3 : digits[1];
           digits[0]   = (digits[0] >= 5)? digits[0] + 3 : digits[0];

           {digits[3], digits[2], digits[1], digits[0]} = {
                {digits[3][2:0], digits[2][3]},
                {digits[2][2:0], digits[1][3]},
                {digits[1][2:0], digits[0][3]},
                {digits[0][2:0], number[INPUT_WIDTH-1-i]}
            };
       end   
    end

    // Converting the BCD digits and the decimal point signal into actual outputs
    always @(current_digit, decimal_points) begin
        anodes      <= ~(1<<current_digit);
        cathodes    <= {
            digit_to_logic_mapping[digits[current_digit]],
            ~decimal_points[current_digit]
        };

    end

endmodule