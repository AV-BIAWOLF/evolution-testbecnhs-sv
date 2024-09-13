`timescale 1ns / 1ps


module tb_moving_average_filter_test1;

    parameter N = 4;
    parameter DATA_WIDTH = 8;

    reg clk;
    reg rst;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    
    
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
    
    initial begin
        // Initialization
        clk = 0;
        rst = 1;
        data_in = 0;
        #2 rst = 0;

        // Test 1: Feeding constant value
        data_in = 8'd10;
        #10;  // Ждем 4 такта
        $display("Test 1: data_out = %d", data_out); // Ожидаем 10
        if(data_out != 10) $error("Wrong answer Test 1");

        // Test 2: Feeding another constant value
        data_in = 8'd20;
        #10;  // Waiting 4 periods
        $display("Test 2: data_out = %d", data_out); 
        if(data_out != 20) $error("Wrong answer Test 2");

        // Test 3: Feeding changing data
        data_in = 8'd10;
        #2;
        data_in = 8'd20;
        #2;
        data_in = 8'd30;
        #2;
        data_in = 8'd40;
        
        // Test 4: Data changes in the process
        #2;
        data_in = 8'd50;
        
        #2;
//        #4;
        $display("Test 3: data_out = %d", data_out); // Expect the average value (25)
        if(data_out != 25) $error("Wrong answer Test 3");
        
        data_in = 8'd60;
        
        #2;
        $display("Test 4: data_out = %d", data_out); // Expect the average value (35)
        if(data_out != 35) $error("Wrong answer Test 4");
        
        #2;
        $display("Test 5: data_out = %d", data_out); // Expect the average value (45)
        if(data_out != 45) $error("Wrong answer Test 5");
        
        // Completing the test
        $finish;
    end        

endmodule
