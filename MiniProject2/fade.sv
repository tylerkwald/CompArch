// Fade

module fade #(
    parameter INC_DEC_INTERVAL = 8000,     // CLK frequency is 12MHz, so 4,000 cycles is 2/3ms
    parameter INC_DEC_MAX = 250,            // Transition to next state after 250 increments / decrements, which is 0.16s
    parameter PWM_INTERVAL = 1250,          // CLK frequency is 12MHz, so 1,200 cycles is 100us
    parameter INC_DEC_VAL = PWM_INTERVAL / INC_DEC_MAX 
)(
    input logic clk, 
    output logic [$clog2(PWM_INTERVAL) - 1:0] R_value,
    output logic [$clog2(PWM_INTERVAL) - 1:0] G_value,
    output logic [$clog2(PWM_INTERVAL) - 1:0] B_value
);

    // Define state variable values
    localparam STATE_1 = 3'b000;
    localparam STATE_2 = 3'b001;
    localparam STATE_3 = 3'b010;
    localparam STATE_4 = 3'b011;
    localparam STATE_5 = 3'b100;
    localparam STATE_6 = 3'b101;
    localparam STATE_7 = 3'b110;
    localparam STATE_8 = 3'b111;

    //Steady Point Value
    localparam PWM_HIGH = PWM_INTERVAL;
    localparam PWM_LOW = 8'd0;
    // Declare state variables
    logic [2:0] current_state = STATE_1;
    logic [2:0] next_state;

    // Declare variables for timing state transitions
    logic [$clog2(INC_DEC_INTERVAL) - 1:0] count = 0;
    logic [$clog2(INC_DEC_MAX) - 1:0] inc_dec_count = 0;
    logic time_to_inc_dec = 1'b0;
    logic time_to_transition = 1'b0;

    initial begin
        R_value = PWM_HIGH;
        G_value = PWM_LOW;
        B_value = PWM_LOW;
    end

    // Register the next state of the FSM
    always_ff @(posedge time_to_transition)
        current_state <= next_state;

    // Compute the next state of the FSM
    always_comb begin
        next_state = 3'bx;
        case (current_state)
            STATE_1:
                next_state = STATE_2;
            STATE_2:
                next_state = STATE_3;
            STATE_3:
                next_state = STATE_4;
            STATE_4:
                next_state = STATE_5;
            STATE_5:
                next_state = STATE_6;
            STATE_6:
                next_state = STATE_1;
            STATE_7:
                next_state = STATE_1;
            STATE_8:
                next_state = STATE_1;
        endcase
    end

    // Implement counter for incrementing / decrementing PWM value
    always_ff @(posedge clk) begin
        if (count == INC_DEC_INTERVAL - 1) begin
            count <= 0;
            time_to_inc_dec <= 1'b1;
        end
        else begin
            count <= count + 1;
            time_to_inc_dec <= 1'b0;
        end
    end

    // Increment / Decrement PWM counters as appropriate given current state
    always_ff @(posedge time_to_inc_dec) begin
        case (current_state) 
            STATE_1: begin
                R_value <= PWM_HIGH;
                G_value <= G_value + INC_DEC_VAL;
                B_value <= PWM_LOW;
            end
            STATE_2: begin
                R_value <= R_value - INC_DEC_VAL;
                G_value <= PWM_HIGH;
                B_value <= PWM_LOW;
            end
            STATE_3: begin
                R_value <= PWM_LOW;
                G_value <= PWM_HIGH;
                B_value <= B_value + INC_DEC_VAL;
            end
            STATE_4: begin
                R_value <= PWM_LOW;
                G_value <= G_value- INC_DEC_VAL;
                B_value <= PWM_HIGH;
            end
            STATE_5: begin
                R_value <= R_value + INC_DEC_VAL;
                G_value <= PWM_LOW;
                B_value <= PWM_HIGH;
            end
            STATE_6: begin
                R_value <= PWM_HIGH;
                G_value <= PWM_LOW;
                B_value <= B_value - INC_DEC_VAL;
            end
            STATE_7: begin
                R_value <= R_value;
                G_value <= G_value;
                B_value <= B_value;
            end
            STATE_8: begin
                R_value <= R_value;
                G_value <= G_value;
                B_value <= B_value;
            end
        endcase
    end

    // Implement counter for timing state transitions
    always_ff @(posedge time_to_inc_dec) begin
        if (inc_dec_count == INC_DEC_MAX - 1) begin
            inc_dec_count <= 0;
            time_to_transition <= 1'b1;
        end
        else begin
            inc_dec_count <= inc_dec_count + 1;
            time_to_transition <= 1'b0;
        end
    end

endmodule
