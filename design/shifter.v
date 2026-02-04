module shifter (
    input wire clk,
    input wire reset,
    input wire is_flash_1, //determines how the out (beats) is determined by shift_left/right
    input wire shift_left, //decreases the state number (as defined in block diagram)
    input wire shift_right, //increases the state number
    output reg [8:0] out //number of beats that the timer module should wait. Each beat is 1/32 s
    //8 * 32 = 256 (7 bits is only 0 to 255 and we need 1 to 256)
);
    wire [1:0] state; //0-based so reset works
    reg [1:0] next; //next_state
    
    // Set next based on state, shift_left/right
    always @(*) begin
        case (state)
            2'b00: next = shift_right ? state + 2'b01 : state; //cannot shift left
            2'b01: next = shift_right ? state + 2'b01 : ( shift_left ? state - 2'b01 : state );
            2'b10: next = shift_right ? state + 2'b01 : ( shift_left ? state - 2'b01 : state );
            2'b11: next = shift_left ? state - 2'b01 : state; //cannot shift right
            default: next = state; //stay put
        endcase
    end
    
    wire [1:0] default_state = is_flash_1 ? 2'b00 : 2'b11;
    
    dff #(2) state_dff(
        .clk(clk),
        .d(reset ? default_state : next),
        .q(state)
    );
    
    // Set out based on state
    always @(*) begin
        case (state)
            2'b00: out = is_flash_1 ? 9'd32  : 9'd4;
            2'b01: out = is_flash_1 ? 9'd64  : 9'd8;
            2'b10: out = is_flash_1 ? 9'd128 : 9'd16;
            2'b11: out = is_flash_1 ? 9'd256 : 9'd32;
            default: out = 9'd32; //should not happen
        endcase
    end
endmodule
