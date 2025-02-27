// PWM generator to fade LED

module pwm #(
    parameter PWM_INTERVAL = 1250       // CLK frequency is 12MHz, so 1,200 cycles is 100us
)(
    input logic clk, 
    input logic [$clog2(PWM_INTERVAL) - 1:0] R_value, 
    input logic [$clog2(PWM_INTERVAL) - 1:0] G_value, 
    input logic [$clog2(PWM_INTERVAL) - 1:0] B_value, 
    output logic R_out,
    output logic G_out,
    output logic B_out
);

    // Declare PWM generator counter variable
    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_count = 0;

    // Implement counter for timing transition in PWM output signal
    always_ff @(posedge clk) begin
        if (pwm_count == PWM_INTERVAL - 1) begin
            pwm_count <= 0;
        end
        else begin
            pwm_count <= pwm_count + 1;
        end
    end

    // Generate PWM output signal
    assign R_out = (pwm_count > R_value) ? 1'b0 : 1'b1;
    assign G_out = (pwm_count > G_value) ? 1'b0 : 1'b1;
    assign B_out = (pwm_count > B_value) ? 1'b0 : 1'b1;

endmodule
