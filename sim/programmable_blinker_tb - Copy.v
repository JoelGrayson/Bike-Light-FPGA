`timescale 1ns/1ps

module programmable_blinker_tb();
    reg clk, reset;
    reg count_en; //simulate beat32
    
    always begin
        #5 clk = 0;
        #5 clk = 1;
    end
    
    always begin
        count_en = 1'b0;
        #90;
        count_en = 1'b1;
        #10;
    end
    
    reg shift_left1 = 0, shift_right1 = 0, shift_left2 = 0, shift_right2 = 0;
    wire out1;
    
    programmable_blinker dut1(
        .clk(clk),
        .reset(reset),
        .is_flash_1(1'b1),
        .shift_left(shift_left1),
        .shift_right(shift_right1),
        .count_en(count_en),
        .out(out1)
    );
    programmable_blinker dut2(
        .clk(clk),
        .reset(reset),
        .is_flash_1(1'b0),
        .shift_left(shift_left2),
        .shift_right(shift_right2),
        .count_en(count_en),
        .out(out2)
    );
    
    initial begin
        reset = 1'b0;
        #5;
        reset = 1'b1;
        #10 reset = 1'b0; //blinks should be 3us
        
        shift_right1 = 1'b1;
        #20; //blinks should be 12us now
        shift_right1 = 1'b0;
        
        #20_000
        $finish;
    end
endmodule