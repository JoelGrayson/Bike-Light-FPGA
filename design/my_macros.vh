`ifndef MY_MACROS_VH
`define MY_MACROS_VH

`define DEFAULT_STATE 4'b0001
`define DEFAULT_MASTER_STATE 3'b000
`define STATE_OFF     4'b0001
`define STATE_ON      4'b0010
`define STATE_FLASH_1 4'b0100
`define STATE_FLASH_2 4'b1000


// # For beat
// In real life: 100,000,000/32 = 3125000
`define CYCLES_PER_BEAT 24'd3125000 //log_2() = 21.6, so I'll do 24 bits

// In the simulation: 10 cycles per beat so shorter
//`define CYCLES_PER_BEAT 24'd10

`endif
