# UART-transmitter
## Overview
This project focuses on the transmitter(TX) aspect of a UART(Universal Asynchronous Receiver and Transmitter), verified with a cocotb testbench. It serializes a set of 8-bit data using a simple synchronous Finite State Machine with four states in the following order: IDLE => START => DATA => STOP. The data is driven on a txd line at a baud rate.
* **RTL**: `rtl/uart_tx.v`
* **Verification**: `sim/test_tx.py`
* **Simulator**: [Icarus Verilog](https://github.com/steveicarus/iverilog)
* **Automation**: Makefile integration with [cocotb](https://github.com/cocotb/cocotb)

## Features 
* FSM-based UART transmitter with:
  - Configurable clock frequency(`clk_hz`)
  - Configurable baud rate(`baud_rate`)
  - 1 start bit, 8 data bits, 1 stop bit
* Outputs handshake signals(`tx_ready`, `tx_valid`)
* Python cocotb testbench:
  - Drives reset and input transactions
  - Waits for DUT readiness
  - Samples txd line bit-by-bit mid-cycle of transaction
  - Asserts the correctness of the UART frame
* Optionally, Waveform can be viewed through [GTKWave](https://github.com/gtkwave/gtkwave)

 ## Setup 
 ### Clone the repository 
 `git clone https://github.com/<your-username>/UART-transmitter.git`
 
 `cd UART-transmitter/sim`
 ### Install required dependencies 
 `pip install -r requirements.txt`
  ### Run the simulation 
  `make`

## Example Output 
<img width="3016" height="596" alt="image" src="https://github.com/user-attachments/assets/9e907654-cd75-4a37-ac01-ea3e4e29d9b4" />

## Next Steps 
* Adding Receiver(RX) functionality
* Integrating waveform viewing VCD with GTKWave
* Supporting configurable parity and stop bits
* Adding multi-byte python tests

## Skills Demonstrated 
* Digital design with Verilog
* Hardware verification with Python
* Toolchain integration of Icarus Verilog, cocotb, and Makefiles
