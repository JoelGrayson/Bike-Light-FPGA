`timescale 1ns/1ps

/* All tests passed. Logs:
Time resolution is 1 ps
Out = 0, expected = 0
Starting to switch 0
Should have toggled. Out = 1, expected = 1
Should have toggled again. Out = 0, expected = 0
Should maintain its state 0. Expected 0
Should have swapped. Out = 1, expected = 1
Should maintain its state 1. Expected 1
*/


module blinker_tb ();
    reg clk, reset;
    reg switch = 0;
    wire out;
    reg expected = 0;
    
    always begin
        #5 clk = 0;
        #5 clk = 1;
    end
    
    blinker dut(
        .clk(clk),
        .reset(reset),
        .switch(switch),
        .out(out)
    );
    
    initial begin
        #10 reset = 0;
        #10 reset = 1;
        #10 reset = 0;
        #30;
        expected = 0;
        $display("Out = %b, expected = %b", out, expected); //from reset
        
        //60 ns
        #5; //65 ns
        
        switch = 1;
        $display("Starting to switch %b", out);
        #10;
        // 75ns
        expected = 1;
        $display("Should have toggled. Out = %b, expected = %b", out, expected);
        #10;
        expected = 0;
        $display("Should have toggled again. Out = %b, expected = %b", out, expected);
        switch = 0;
        
        #50
        $display("Should maintain its state %b. Expected %b", out, expected);
        
        
        switch = 1;
        #10
        expected = ~expected;
        $display("Should have swapped. Out = %b, expected = %b", out, expected);
        switch = 0;
        #50
        $display("Should maintain its state %b. Expected %b", out, expected);
        
        
        #5;
        
        
        
        
        
        $finish; //asked Gemini how to make the simulation stop. The answer is to use the $finish keyword.
   end
endmodule
