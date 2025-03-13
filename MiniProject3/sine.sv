`include "memory.sv"
`include "data_restore.sv"

// Sine top-level module

module top #(
    parameter INC_DEC_MAX = 128
)(
    input logic     clk, 
    output logic    _9b,    // D0
    output logic    _6a,    // D1
    output logic    _4a,    // D2
    output logic    _2a,    // D3
    output logic    _0a,    // D4
    output logic    _5a,    // D5
    output logic    _3b,    // D6
    output logic    _49a,   // D7
    output logic    _45a,   // D8
    output logic    _48b    // D9
);

    logic [8:0] data_amp;
    logic [9:0] data;
    logic [6:0] step = 0;
    logic [0:0] increment = 1;
    logic [6:0] address = 0;
    logic current_state = 0;

    memory #(
        .INIT_FILE      ("sine.txt")
    ) u1 (
        .clk            (clk), 
        .read_address   (address), 
        .read_data      (data_amp)
    );

    data_restore #(
            .INC_DEC_MAX  (INC_DEC_MAX)
        ) u2 (
            .clk            (clk), 
            .data_amp   (data_amp),
            .data      (data)
        );

    // Implement counter to determine which address to pull from
    always_ff @(posedge clk) begin
        step <= step + 1;
    end

    //determine which address to pull from
    always_ff @(posedge clk) begin
        if (increment == 1) begin
            address <= step;
        end
        if (increment == 0) begin
            address <= 7'd127 - step;
        end        
    end

    // Implement case to determine if we are increasing or decreasing through address
    always_comb begin
        case (current_state)
            1'b0:
                increment = 1;
            1'b1:
                increment = 0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (step == 7'd127) begin
            current_state <= current_state + 1;
        end
    end




    assign {_48b, _45a, _49a, _3b, _5a, _0a, _2a, _4a, _6a, _9b} = data;

endmodule
