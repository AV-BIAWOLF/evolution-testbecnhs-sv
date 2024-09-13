`timescale 1ns / 1ps


module tb_moving_average_filter_test1;

    parameter N = 4;
    parameter DATA_WIDTH = 8;
    parameter ALL_NUMBERS = 10;

    reg clk;
    reg rst;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    
    reg [DATA_WIDTH-1:0] input_data     [0:ALL_NUMBERS];
    reg [DATA_WIDTH-1:0] expect_data    [0:ALL_NUMBERS];
    reg [DATA_WIDTH-1:0] sum;
    
    integer i;
    
    
     moving_average_filter_test1 #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    always begin
        #1 clk = ~clk;
    end 
    
    event ev;
    
    // Calculating expecting numbers
    initial begin
        sum = 0;
    
        for (i = 0; i < ALL_NUMBERS; i++) begin
            input_data[i] = i * 10;
            sum = sum + input_data[i]; 
            sum = sum - input_data[i - (N - 1)];
            expect_data[i] = sum / 4;
        end
    end
    
    // Initialization
    initial begin
        clk = 0;
        rst = 1;
        data_in = 0;
        #2 rst = 0;
        
        // Feeding data 
        for (i = 0; i < ALL_NUMBERS; i++) begin
            data_in = input_data[i];
            #2;
            ->> ev; // Event generation for result checking
        end
        
        #10;
        $display("SUCCESS");
        $finish;
    end
    
    // Checking results by event
    initial begin
        integer test_index = 0;
        while(1) begin
            @ev;
            if (data_out != expect_data[test_index]) begin
                $display("Test %0d failed: data_out = %d, expected_data = %d", test_index, data_out, expect_data[test_index]);
                $error("Wrong answer");
            end
            test_index = test_index + 1;
        end
    end
           

endmodule
