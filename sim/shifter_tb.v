`timescale 1ns/1ps

/* All tests pass. For flash1, it goes from 32 to 128 (shifting right) and back to 32 (shifting left) */

module shifter_tb ();
    // Clock and reset
    reg clk, reset = 0;
    always begin
        #5 clk = 0;
        #5 clk = 1;
        $display("Time is %d", $time); //asked Gemini how to print current time in logs
    end
    
    // Setup devices
    reg flash1_shift_left = 0, flash2_shift_left = 0,
        flash1_shift_right = 0, flash2_shift_right = 0;
    wire [8:0] flash1_out, flash2_out;
    
    shifter flash1(
        .clk(clk),
        .reset(reset),
        .is_flash_1(1'b1),
        .shift_left(flash1_shift_left),
        .shift_right(flash1_shift_right),
        .out(flash1_out)
    );
    
    shifter flash2(
        .clk(clk),
        .reset(reset),
        .is_flash_1(1'b0),
        .shift_left(flash2_shift_left),
        .shift_right(flash2_shift_right),
        .out(flash2_out)
    );
    
    // Testing
    initial begin
        // Both devices reset
        #10 reset = 0;
        #5; //change variables between signals
        #10 reset = 1;
        #10 reset = 0;
        #10;

        $display("Reset should have set both to %d: %d, %d", 9'd32, flash1_out, flash2_out);
        

        // Test flash1
        $display("---Testing flash 1---");
        $display("flash1_out = %d", flash1_out);
        #20
        $display("flash1_out = %d. Stays the same.", flash1_out);
        
        
        $display("Shift right 6 times");
        repeat (6) begin
            flash1_shift_right = 1;
            #10
            flash1_shift_right = 0;
            $display("flash1_out = %d. Shifted right.", flash1_out);
            #20
            $display("flash1_out = %d. Should stay stable", flash1_out);
        end
        
        $display("Shift left 6 times");
        repeat (6) begin
            flash1_shift_left = 1;
            #10
            flash1_shift_left = 0;
            $display("flash1_out = %d. Shifted left.", flash1_out);
            #20
            $display("flash1_out = %d. Should stay stable", flash1_out);
        end
        
        
        #20
        
        
        
        
        // Test flash1
        $display("\n\n---Testing flash 2---");
        $display("flash2_out = %d", flash2_out);
        #20
        $display("flash2_out = %d. Stays the same.", flash2_out);
        
        
        $display("Shift left 6 times");
        repeat (6) begin
            flash2_shift_left = 1;
            #10
            flash2_shift_left = 0;
            $display("flash2_out = %d. Shifted left.", flash2_out);
            #20
            $display("flash2_out = %d. Should stay stable", flash2_out);
        end

        
        $display("Shift right 6 times");
        repeat (6) begin
            flash2_shift_right = 1;
            #10
            flash2_shift_right = 0;
            $display("flash2_out = %d. Shifted right.", flash2_out);
            #20
            $display("flash2_out = %d. Should stay stable", flash2_out);
        end
        
        
        
        #20
        
        
        
        
        $finish;
    end
endmodule

/* Test logs
Time is                   10
Time is                   20
Time is                   30
Time is                   40
Reset should have set both to  32:  32,  32
---Testing flash 1---
flash1_out =  32
Time is                   50
Time is                   60
flash1_out =  32. Stays the same.
Shift right 6 times
Time is                   70
flash1_out =  64. Shifted right.
Time is                   80
Time is                   90
flash1_out =  64. Should stay stable
Time is                  100
flash1_out = 128. Shifted right.
Time is                  110
Time is                  120
flash1_out = 128. Should stay stable
Time is                  130
flash1_out = 256. Shifted right.
Time is                  140
Time is                  150
flash1_out = 256. Should stay stable
Time is                  160
flash1_out = 256. Shifted right.
Time is                  170
Time is                  180
flash1_out = 256. Should stay stable
Time is                  190
flash1_out = 256. Shifted right.
Time is                  200
Time is                  210
flash1_out = 256. Should stay stable
Time is                  220
flash1_out = 256. Shifted right.
Time is                  230
Time is                  240
flash1_out = 256. Should stay stable
Shift left 6 times
Time is                  250
flash1_out = 128. Shifted left.
Time is                  260
Time is                  270
flash1_out = 128. Should stay stable
Time is                  280
flash1_out =  64. Shifted left.
Time is                  290
Time is                  300
flash1_out =  64. Should stay stable
Time is                  310
flash1_out =  32. Shifted left.
Time is                  320
Time is                  330
flash1_out =  32. Should stay stable
Time is                  340
flash1_out =  32. Shifted left.
Time is                  350
Time is                  360
flash1_out =  32. Should stay stable
Time is                  370
flash1_out =  32. Shifted left.
Time is                  380
Time is                  390
flash1_out =  32. Should stay stable
Time is                  400
flash1_out =  32. Shifted left.
Time is                  410
Time is                  420
flash1_out =  32. Should stay stable
Time is                  430
Time is                  440


---Testing flash 2---
flash2_out =  32
Time is                  450
Time is                  460
flash2_out =  32. Stays the same.
Shift left 6 times
Time is                  470
flash2_out =  16. Shifted left.
Time is                  480
Time is                  490
flash2_out =  16. Should stay stable
Time is                  500
flash2_out =   8. Shifted left.
Time is                  510
Time is                  520
flash2_out =   8. Should stay stable
Time is                  530
flash2_out =   4. Shifted left.
Time is                  540
Time is                  550
flash2_out =   4. Should stay stable
Time is                  560
flash2_out =   4. Shifted left.
Time is                  570
Time is                  580
flash2_out =   4. Should stay stable
Time is                  590
flash2_out =   4. Shifted left.
Time is                  600
Time is                  610
flash2_out =   4. Should stay stable
Time is                  620
flash2_out =   4. Shifted left.
Time is                  630
Time is                  640
flash2_out =   4. Should stay stable
Shift right 6 times
Time is                  650
flash2_out =   8. Shifted right.
Time is                  660
Time is                  670
flash2_out =   8. Should stay stable
Time is                  680
flash2_out =  16. Shifted right.
Time is                  690
Time is                  700
flash2_out =  16. Should stay stable
Time is                  710
flash2_out =  32. Shifted right.
Time is                  720
Time is                  730
flash2_out =  32. Should stay stable
Time is                  740
flash2_out =  32. Shifted right.
Time is                  750
Time is                  760
flash2_out =  32. Should stay stable
Time is                  770
flash2_out =  32. Shifted right.
Time is                  780
Time is                  790
flash2_out =  32. Should stay stable
Time is                  800
flash2_out =  32. Shifted right.
Time is                  810
Time is                  820
flash2_out =  32. Should stay stable
Time is                  830
Time is                  840
*/