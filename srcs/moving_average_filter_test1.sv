`timescale 1ns / 1ps

module moving_average_filter_test1 #(
    parameter N = 4, // Size of window
    parameter DATA_WIDTH = 8
)(
    input clk, 
    input aresetn,
    input [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out
);

    logic [DATA_WIDTH - 1:0] buff [0:N-1];
    logic [DATA_WIDTH + $clog2(N) - 1:0] sum;
    integer i;
    logic [DATA_WIDTH - 1:0] res;
    
    always @(posedge clk or negedge aresetn) begin // or posedge rst
        if (!aresetn) begin
            // Reset all registers
            for (i = 0; i < N; i = i + 1) begin
                buff[i] <= 0;
            end
            sum <= 0;
            res <= 0;
        end else begin
            // Subtract the oldest value from the sum and add the new value
            sum <= sum - buff[N-1] + data_in;

            // Buffer shift
            for (i = N-1; i > 0; i = i - 1) begin
                buff[i] <= buff[i-1];
            end
            buff[0] <= data_in;

            res <= sum / N;
        end
    end
    
    assign data_out = res;    
    
endmodule
