`include "my_macros.vh" //asked Gemini how to include macros across multiple files since I want to use them in bicycle_fsm and master_fsm

// Bicycle Light FSM
//
// This module determines how the light functions in the given state and what
// the next state is for the given state.
// 
// It is a structural module: it just instantiates other modules and hooks
// up the wires between them correctly.

/* For this lab, you need to implement the finite state machine following the
 * specifications in the lab hand-out */

module bicycle_fsm(
    input clk, 
    input faster, 
    input slower, 
    input next, 
    input reset, 
    output reg rear_light
);

    wire [3:0] state; //controlled by Master FSM. Controls the mux
    wire flash1_out, flash2_out;
    wire f1_shift_left, f1_shift_right,
         f2_shift_left, f2_shift_right;
    
    // Instantiations of master_fsm, beat32, fast_blinker, slow_blinker here
    master_fsm master_fsm_device(
        .clk(clk), .reset(reset),
        .next(next), .up_button(faster), .down_button(slower),
        .state(state),
        .f1_shift_left(f1_shift_left),
        .f1_shift_right(f1_shift_right),
        .f2_shift_left(f2_shift_left),
        .f2_shift_right(f2_shift_right)
    );
    
    wire beat;
    beat32 beat32_device(
        .clk(clk),
        .reset(reset),
        .beat(beat)
    );
    
    programmable_blinker pb1(
        .clk(clk), .reset(reset),
        .is_flash_1(1'b1),
        .shift_left(f1_shift_left),
        .shift_right(f1_shift_right),
        .count_en(beat),
        .out(flash1_out)
    );
    
    programmable_blinker pb2(
        .clk(clk), .reset(reset),
        .is_flash_1(1'b0),
        .shift_left(f2_shift_left),
        .shift_right(f2_shift_right),
        .count_en(beat),
        .out(flash2_out)
    );
    

    // Output mux here
    always @(*) begin
        case (state) //one-hot encoded. Preprocessor variables specified in the master_fsm.v file
            `STATE_OFF: rear_light = 1'b0;
            `STATE_ON: rear_light = 1'b1;
            `STATE_FLASH_1: rear_light = flash1_out;
            `STATE_FLASH_2: rear_light = flash2_out;
            default: rear_light = 1'b0; //should not happen
        endcase
    end
endmodule
