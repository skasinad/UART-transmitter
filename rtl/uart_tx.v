module uart_tx #(
    parameter CLK_HZ = 50_000_000, BAUD_RATE = 115_200
    //CLK_HZ for the frequency of the system's clock in hertz
    //BAUD_RATE is the bit rate of the UART line 
)(
    input wire clk; 
    input wire rst; 
    input wire tx_valid; 
    input wire [7:0] tx_data; 

    output reg tx_ready; 
    output reg txd;
);
localparam integer CLKS_PER_BIT = CLK_HZ/BAUD_RATE; //CLKS_PER_BIT is the number of clock cyclers per UART bit, the relation between the clock frequency and the bitrate
endmodule   