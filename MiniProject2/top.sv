`include "fade.sv"
`include "pwm.sv"

// Fade top level module

module top #(
    parameter PWM_INTERVAL = 1200       // CLK frequency is 12MHz, so 1,200 cycles is 100us
)(
    input logic     clk, 
    output logic    RGB_R,
    output logic    RGB_G,
    output logic    RGB_B
);

    logic [$clog2(PWM_INTERVAL) - 1:0] R_value;
    logic [$clog2(PWM_INTERVAL) - 1:0] G_value;
    logic [$clog2(PWM_INTERVAL) - 1:0] B_value;
    logic R_out;
    logic G_out;
    logic B_out;

    fade #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u1 (
        .clk            (clk), 
        .R_value      (R_value),
        .G_value      (G_value),
        .B_value      (B_value)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u2 (
        .clk            (clk), 
        .R_value      (R_value),
        .G_value      (G_value),
        .B_value      (B_value), 
        .R_out        (R_out),
        .G_out        (G_out),
        .B_out        (B_out)
    );

    assign RGB_R = R_out;
    assign RGB_G = G_out;
    assign RGB_B = B_out;

endmodule
