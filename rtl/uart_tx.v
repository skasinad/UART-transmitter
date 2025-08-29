module uart_tx #(
    parameter clk_hz = 50_000_000, baud_rate = 115_200
    //clk_hz for the frequency of the system's clock in hertz
    //baud_rate is the bit rate of the UART line 
)(
    input wire clk; 
    input wire rst; 
    input wire tx_valid; 
    input wire [7:0] tx_data; 

    output reg tx_ready; 
    output reg txd;
);
localparam integer clks_per_bit = clk_hz/baud_rate; //clks_per_bit is the number of clock cycles per UART bit, the relation between the clock frequency and the bitrate
/* 4 states in the UART line
1. IDLE 
2. START
3. DATA
4. STOP
*/
localparam [1:0] idle_state = 2'b00, start_state = 2'b01, data_state = 2'b10, stop_state = 2'b11;
reg [1:0] current_state;  

localparam integer timer_width = (clks_per_bit <= 2) ? 1: $clog2(clks_per_bit);

endmodule   