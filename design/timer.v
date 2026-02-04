module timer (
    input wire clk,
    input wire reset,
    input wire [8:0] load_value, //in units of beats
    input wire count_en, //from beat32
    output wire out
);
    wire [8:0] curr_count;
    wire isDone = curr_count == 0;
    assign out = isDone;

    wire [8:0] next = (reset | isDone) ? load_value : curr_count - 1;
    
    dffre #(.WIDTH(9)) counter_dff(
        .clk(clk),
        .d(next),
        .q(curr_count),
        .r(1'b0), //used custom reset logic
        .en(
            count_en //beat
            | reset //resetting at start of program
            | isDone // so pulses only once
        )
    );
endmodule
