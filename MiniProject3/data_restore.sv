// data_restore

module data_restore #(
parameter INC_DEC_MAX = 128

)(
    input logic clk,
    input logic [8:0] data_amp,
    output logic [9:0] data
);

logic [1:0] current_state = 0;
logic time_to_inc_dec = 0;
logic [6:0] count  = 0; 

always_ff @(posedge clk) begin
        if (count == INC_DEC_MAX - 1) begin
            count <= 0;
            current_state <= current_state + 1;
        end
        else begin
            count <= count + 1;
            
        end
end

 always_ff @(posedge clk) begin
        case (current_state) 
            2'd0: begin
                data <= data_amp + 10'd512;
            end
            2'd1: begin
                data <= data_amp + 10'd512;
            end
            2'd2: begin
                data <= ~(data_amp + 10'b0) + 10'd513;
            end
            2'd3: begin
                data <= ~(data_amp + 10'b0) + 10'd513;
            end
        endcase
    end


endmodule