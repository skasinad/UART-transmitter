// smoke test for transmitter (tx)
`timescale 1ns/1ps

module tb_tx_smoke;
  //
  reg clk = 0; // clock starting at 0 
  always #10 clk = ~clk; // clock will invert every 10 ns

  reg rst = 1;
  reg tx_valid = 0;
  reg [7:0] tx_data = 8'b00000000;
  wire tx_ready;
  wire txd;

  // DUT
  uart_tx #(
    .clk_hz(50_000_000),
    .baud_rate(115_200)
  ) dut (
    .clk(clk),
    .rst(rst),
    .tx_valid(tx_valid),
    .tx_data(tx_data),      
    .tx_ready(tx_ready),    
    .txd(txd)
  );
  initial begin
    //waves
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_tx_smoke);

    // reset for 5 cycles
    repeat (5) @(posedge clk);
    rst = 0;

    @(posedge clk);
    wait (tx_ready);

    
    tx_data  = 8'h55;
    tx_valid = 1'b1;
    @(posedge clk);
    tx_valid = 1'b0;  

    
    repeat (6000) @(posedge clk);

    $finish;
  end
endmodule