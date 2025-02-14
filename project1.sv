// RGB Blink Cycle

module top(
    input logic     clk, 
    output logic    RGB_R,
    output logic    RGB_G,
    output logic    RGB_B
);

    // CLK frequency is 12MHz, so 6,000,000 cycles is 0.5s
    parameter BLINK_INTERVAL = 2000000;
    logic [2:0] cycle = 0;
    logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;
 



    always_ff @(posedge clk) begin
    
        if (count == BLINK_INTERVAL - 1) begin
            count <= 0;
            cycle <= cycle +1;
        end
        else begin
            count <= count + 1;
        end
        
        if (cycle == 0) begin
        	RGB_R <= 1;
        	RGB_G <= 0;
        	RGB_B <= 0;
        end
        else if (cycle == 1) begin
        	RGB_R <= 1;
        	RGB_G <= 1;
        	RGB_B <= 0;
        end
        else if (cycle == 2) begin
        	RGB_R <= 0;
        	RGB_G <= 1;
        	RGB_B <= 0;
        end
        else if (cycle == 3) begin
        	RGB_R <= 0;
        	RGB_G <= 1;
        	RGB_B <= 1;
        end
        else if (cycle == 4) begin
        	RGB_R <= 0;
        	RGB_G <= 0;
        	RGB_B <= 1;
        end
        else if (cycle == 5) begin
        	RGB_R <= 1;
        	RGB_G <= 0;
        	RGB_B <= 1;
        end
        else begin
        	cycle <= 0;
        end
    end
    

endmodule
