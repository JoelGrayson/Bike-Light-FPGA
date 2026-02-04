module blinker (
    input wire clk,
    input wire reset, //sets the output to 0 no matter what
    input wire switch, //whether to flip the output
    output wire out //output which goes to the mux
);
    assign next = out ^ switch;
    
    dffr blinker_dff(
        .clk(clk),
        .d(next),
        .q(out),
        .r(reset)
    );
endmodule

