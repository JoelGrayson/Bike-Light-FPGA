`include "my_macros.vh"

module beat32 (
    input wire clk,
    input wire reset,
    output wire beat
);
    wire [23:0] count;
    wire isDone;
    
    //`CYCLES_PER_BEAT
    dffr #(24) count_dff(
        .clk(clk),
        .d(count + 1'b1), //next
        .q(count),
        .r(reset | isDone)
    );
    
    assign isDone = count == (`CYCLES_PER_BEAT - 24'd1); //starts at 0 so goes up to N-1
    
    assign beat = isDone;
endmodule


// Done with my own reset:
/*
module beat32 (
    input wire clk,
    input wire reset,
    output wire beat
);
    wire [23:0] count, next;
    wire isDone;
    
    assign next = (reset | isDone) ? 24'b0 : count + 1;
    
    //`CYCLES_PER_BEAT
    dff #(24) count_dff(
        .clk(clk),
        .d(next),
        .q(count)
    );
    
    
    assign isDone = count == `CYCLES_PER_BEAT - 1; //starts at 0
    
    assign beat = isDone;
endmodule
*/
