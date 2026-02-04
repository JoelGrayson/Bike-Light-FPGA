module programmable_blinker (
    // For the submodules
    input wire clk,
    input wire reset,
    input wire is_flash_1, //for blinker 1. Fed into shifter.
    
    // Inputs
    input wire shift_left,
    input wire shift_right,
    input wire count_en, //from beat32
    // Outputs
    output wire out //to mux
);
    wire [8:0] timer_load_value;
    wire blinker_switch;

    shifter shifter_device(
        .clk(clk),
        .reset(reset),
        .is_flash_1(is_flash_1),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .out(timer_load_value)
    );
    
    timer timer_device(
        .clk(clk),
        .reset(reset),
        .load_value(timer_load_value),
        .count_en(count_en),
        .out(blinker_switch)
    );

    blinker blinker_device(
        .clk(clk),
        .reset(reset),
        .switch(blinker_switch),
        .out(out)
    );
endmodule