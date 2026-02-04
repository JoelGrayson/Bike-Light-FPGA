`timescale 1ns/1ps

// All tests pass except for 5 because I implemented my up_button differently.

module master_fsm_tb ();
reg clk, reset, next, up_button, down_button, expected_l, expected_r, errors;
wire f1_shift_left, f1_shift_right, f2_shift_left, f2_shift_right;
wire [3:0] state;
reg [3:0] expected;
master_fsm dut (.clk(clk), .reset(reset), .next(next), .up_button(up_button),
                .down_button(down_button), .state(state), .f1_shift_left(f1_shift_left),
                .f1_shift_right(f1_shift_right), .f2_shift_left(f2_shift_left), .f2_shift_right(f2_shift_right));

always begin 
    #5 clk = 0;
    #5 clk = 1;
    $display("The time is %d", $stime);
end

initial begin
    // rst the circuit
    #10 reset = 0;
    #20 reset = 1;
    #10 reset = 0;
    #30
    
    // initialization of values
    errors = 1'b0;
    up_button = 1'b0;
    down_button = 1'b0;
    
    // starting at 'OFF' position, next state is 'ON'
    #5
    next = 1'b1;
    expected = 4'b0010; // expect to be 'ON'
    #10
    $display ("Current state is %b, expected %b", state, expected);
    if (state !== expected) begin
        errors = 1'b1;
        $display ("Error at test 1");
    end
    
    // in 'ON' state, next state is 'OFF'
    expected = 4'b0001; // expect to be 'OFF'
    #10
    $display ("Current state is %b, expected %b", state, expected);
    if (state !== expected) begin
        errors = 1'b1;
        $display ("Error at test 2");
    end
    
    // in 'OFF' state, stay in 'OFF'
    next = 1'b0;
    expected = 4'b0001; // expect to be 'OFF'
    #10
    $display ("Current state is %b, expected %b", state, expected);
    if (state !== expected) begin
        errors = 1'b1;
        $display ("Error at test 3");
    end
    
    // still in 'OFF' state, next state is 'BLINK1'
    next = 1'b1;
    expected = 4'b0100; // expect to be in 'BLINK1'
    #10
    $display ("Current state is %b, expected %b", state, expected);
    if (state !== expected) begin
        errors = 1'b1;
        $display ("Error at test 4");
    end

    // sending shift signals
    next = 1'b0;
    down_button = 1'b1;
    expected_l = 1'b1;
    expected_r = 1'b0;
    #10
    $display ("For blink1: left and right shift are %b and %b, expected %b and %b", f1_shift_left, f1_shift_right, expected_l, expected_r);
    if (expected_l !== f1_shift_left || expected_r !== f1_shift_right) begin
        errors = 1'b1;
        $display ("Error at test 5");
    end
    
    // in 'BLINK1', next state is 'OFF'
    next = 1'b1;
    expected = 4'b0001; // expect to be 'OFF'
    #10
    $display ("Current state is %b, expected %b", state, expected);
    if (state !== expected) begin
        errors = 1'b1;
        $display ("Error at test 6");
    end
    
    // in 'OFF', next state is 'BLINK2'
    next = 1'b1;
    expected = 4'b1000; // expect 'BLINK2'
    #10
    $display ("Current state is %b, expected %b", state, expected);
    if (state !== expected) begin
        errors = 1'b1;
        $display ("Error at test 7");
    end
    
    // in 'BLINK2', next state is 'OFF'
    next = 1'b1;
    expected = 4'b0001; // expect 'oFF'
    #10
    $display ("Current state is %b, expected %b", state, expected);
    if (state !== expected) begin
        errors = 1'b1;
        $display ("Error at test 8");
    end
   
    
    if (errors == 1'b0) begin
        $display ("No errors!");
    end
    
    $finish;
end
endmodule