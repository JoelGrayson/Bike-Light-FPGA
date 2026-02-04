`timescale 1ns/1ps

/* All tests passed. Logs:
beat32_tb v1.1
count should be 0. Is        0. Beat is 0 (should be 0)
count should be 9. Is        9. Beat is 1 (should be 1)
count should reset back to 0. Is        0. Beat should be low. Is 0
count should be 0. Is        0. Beat is 0 (should be 0)
count should be 9. Is        9. Beat is 1 (should be 1)
count should reset back to 0. Is        0. Beat should be low. Is 0
count should be 0. Is        0. Beat is 0 (should be 0)
count should be 9. Is        9. Beat is 1 (should be 1)
count should reset back to 0. Is        0. Beat should be low. Is 0
count should be 0. Is        0. Beat is 0 (should be 0)
count should be 9. Is        9. Beat is 1 (should be 1)
count should reset back to 0. Is        0. Beat should be low. Is 0
count should be 0. Is        0. Beat is 0 (should be 0)
count should be 9. Is        9. Beat is 1 (should be 1)
count should reset back to 0. Is        0. Beat should be low. Is 0

beat32_tb v1.0
count should be 0. Is        0. Beat is 0 (should be 0)
count should be 9. Is        9. Beat is 1 (should be 1)
count should reset back to 0. Is        0. Beat should be low. Is 0
*/

// Beat is high when hit limit and about to reset to 0

module beat32_tb ();
    // Setup
    reg clk; //clock signal simulated in this testbench
    reg reset = 0;
    wire beat; //set by the dut
    
    beat32 dut(
        .clk(clk),
        .reset(reset),
        .beat(beat)
    );
    
    // Setup clock
    always begin
        #5 clk = 0;
        #5 clk = 1;
    end
    
    // Run tests
    initial begin
        $display("beat32_tb v1.1");
        #10 reset = 0; //need to set to 0 so the rising edge happens.
        #10 reset = 1;
        // At time 20, started counting
        #5 //in middle of update cycle this way you can see the updated changes
        reset = 0;
        
        repeat (5) begin //repeat syntax from Gemini
            $display("count should be 0. Is %d. Beat is %d (should be 0)", dut.count, beat);
            // At time 110, should be at 9
            #90
            $display("count should be 9. Is %d. Beat is %d (should be 1)", dut.count, beat);
            #10
            $display("count should reset back to 0. Is %d. Beat should be low. Is %d", dut.count, beat);
        end
        
        #20
        $finish;
    end
endmodule