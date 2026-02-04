`timescale 1ns/1ps

module bicycle_fsm_tb ();
    reg clk, reset;

    always begin 
        #5 clk = 0;
        #5 clk = 1;
//        $display("The time is %d", $stime);
    end
    
    // Input wires
    reg next = 0, faster = 0, slower = 0;
    
    // Output wires
    wire rear_light;
    reg [3:0] expected;
    
    // Setup
    bicycle_fsm dut(
        .clk(clk),
        .faster(faster),
        .slower(slower),
        .next(next),
        .reset(reset),
        .rear_light(rear_light)
    );
    
    
    initial begin
        // Reset
        #5;
        next = 0;
        reset = 0;
        #10;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        next = 1;
        #50; //turn on
        next = 0;
        
//        slower = 1;
//        #50;
//        slower = 0;
        
        #40_000;
        $finish;
    end
endmodule