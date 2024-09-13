`timescale 1ns / 1ps


module tb_moving_average_filter_test1;

    parameter N = 4;
    parameter DATA_WIDTH = 8;
    parameter CLK_PERIOD = 2;
    parameter ALL_NUMBERS = 10;
    
    reg clk;
    reg aresetn;
    reg  [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    
    
     moving_average_filter_test1 #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .aresetn(aresetn),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    // Clock signal generation
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end
    
    logic valid_work;
    
    // Reset sgnal generation 
    initial begin
        aresetn <= 0;
        #(CLK_PERIOD);
        aresetn <= 1;
        #(CLK_PERIOD+1);
        valid_work <= 1;
    end
    
    // Input signals generation 
    initial begin
        
        data_in <= 0;
        
        wait(aresetn);
        repeat(100) begin
            @(posedge clk);
            data_in <= $urandom_range(0, 10);
        end
        @(posedge clk);
        $stop();
    end
    
    typedef struct{
        logic [DATA_WIDTH-1:0] data_in_2;
        logic [DATA_WIDTH-1:0] data_out_2;
    } packet;
    
    mailbox#(packet)   mon2chk = new();
    
    // Monitoring 
    initial begin
        packet pkt;
        wait(aresetn);
        
        forever begin 
            @(posedge clk);
            pkt.data_in_2  = data_in;
            pkt.data_out_2 = data_out;
            $display("%p", pkt);
            mon2chk.put(pkt);
        end
    end
    
    
    integer test_index = 0;
    integer window_idx = 0;
    logic [DATA_WIDTH-1:0] sum_tb = 0;
    logic [DATA_WIDTH-1:0] window [0:N-1];
    logic [DATA_WIDTH-1:0] expected_data;
    
    initial begin
        for (int k = 0; k <= N; k = k + 1) begin
            window[k] = 0;
        end
    end
    
    // Checking results 
    initial begin
        packet pkt_prev, pkt_cur;
        
        sum_tb = 0;
        expected_data = 0;
        wait(aresetn);
        mon2chk.get(pkt_prev);
        
        forever begin
            mon2chk.get(pkt_cur);
            sum_tb = 0;
            
            if(pkt_cur.data_out_2 != expected_data) begin
                $display("Test %0d failed: data_out = %d, expected_data = %d", test_index, pkt_cur.data_out_2, expected_data);
                $error("Wrong answer");
            end
            else begin
                $display("Test %0d SUCCESS: data_out = %d, expected_data = %d", test_index, pkt_cur.data_out_2, expected_data);
            end

            for (int j = N-1; j > 0; j = j - 1) begin
                window[j] = window[j-1];
            end
            
            window[0] = pkt_prev.data_in_2;
            
            for (int m = 0; m < N; m = m + 1) begin
                sum_tb = sum_tb + window[m];
            end

            expected_data = sum_tb/N;
            test_index = test_index + 1;
            pkt_prev = pkt_cur;
        end
    end
    
    
endmodule
