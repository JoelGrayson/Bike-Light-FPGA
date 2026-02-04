`define DEFAULT_STATE 4'b0001
`define DEFAULT_MASTER_STATE 3'b000
`define STATE_OFF     4'b0001
`define STATE_ON      4'b0010
`define STATE_FLASH_1 4'b0100
`define STATE_FLASH_2 4'b1000

module master_fsm (
    input wire clk, reset,
    input wire next, up_button, down_button, //up_button for faster, down_button for slower
    output reg [3:0] state, //for selecting in Mux (one-hot encoded)
    output reg f1_shift_left, f1_shift_right, f2_shift_left, f2_shift_right
);
    wire [2:0] master_state; //internal logging of the state. Determines state
    wire [2:0] next_master_state = master_state == 3'd5 ? 3'd0 : master_state + 1'b1;
    
    dffre #(3) master_state_dff(
        .clk(clk),
        .d(reset ? `DEFAULT_MASTER_STATE : next_master_state),
        .q(master_state),
        .en(next | reset),
        .r(1'b0)
    );
    
    // Determine state (exported state) from master_state (internal state)
    always @(*) begin
        case (master_state)
            3'd0: state = `STATE_OFF;
            3'd1: state = `STATE_ON;
            3'd2: state = `STATE_OFF;
            3'd3: state = `STATE_FLASH_1;
            3'd4: state = `STATE_OFF;
            3'd5: state = `STATE_FLASH_2;
            default: state = 4'b1111; //should not happen
            
//            3'd0: state = 4'b0001; //off
//            3'd1: state = 4'b0010; //on
//            3'd2: state = 4'b0001; //off
//            3'd3: state = 4'b0100; //flash1
//            3'd4: state = 4'b0001; //off
//            3'd5: state = 4'b1000; //flash2
//            default: state = 4'b0000;
        endcase
    end
    
    // f1/2_shift_left/right buttons based on up_button/down_button and state
    always @* begin //saw this syntax in the other files. Curious to try it. Apparently it is old verilog syntax for @(*)
        if (state == `STATE_FLASH_1) begin
            f1_shift_left = up_button;
            f1_shift_right = down_button;
            f2_shift_left = 0;
            f2_shift_right = 0;
        end else if (state == `STATE_FLASH_2) begin
            f1_shift_left = 0;
            f1_shift_right = 0;
            f2_shift_left = up_button;
            f2_shift_right = down_button;
        end else begin
            f1_shift_left = 0;
            f1_shift_right = 0;
            f2_shift_left = 0;
            f2_shift_right = 0;
        end
    end
    /*
        input wire next, up_button, down_button, //up_button for faster, down_button for slower
    output reg [3:0] state, //for selecting in Mux (one-hot encoded)
    output wire f1_shift_left, f1_shift_right, f2_shift_left, f2_shift_right
*/
endmodule

