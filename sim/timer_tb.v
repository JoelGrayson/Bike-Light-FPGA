`timescale 1ns/1ps

// QC Pass: out is behaving like it should according to the waveforms in the simulator

module timer_tb ();
    reg clk, reset, count_en = 0;
    reg [8:0] load_value = 9'd8;
    
    always begin
        #5 clk = 0;
        #5 clk = 1;
        $display("Time is %d", $time); //asked Gemini how to print current time in logs
    end
    
    always begin //10 clk cycles for one count_en cycle
        count_en = 0;
        #50;
        count_en = 1;
        #10;
    end
    
    wire out;
    
    timer dut(
        .clk(clk),
        .reset(reset),
        .load_value(load_value),
        .count_en(count_en),
        .out(out)
    );
    
    // Testing
    initial begin
        // Both devices reset
        #10 reset = 0;
        #5; //change variables between signals
        #10 reset = 1;
        #10 reset = 0;
        #10;
        
        #600;
        $finish;
    end
endmodule

