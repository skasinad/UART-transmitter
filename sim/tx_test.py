import cocotb 
from cocotb.clock import Clock 
from cocotb.triggers import Timer, RisingEdge

clock_period = 10 
baud_rate = 115200
bit_time = 1e9/baud_rate # I divided the bit rate by 1x10^9 due to how cocotb uses nanoseconds, hence 1x10^9ns = 1s

@cocotb.test() 
async def oneByte(dut): 
    cocotb.start_soon(Clock(dut.clk, clock_period, units="ns").start()) # driving the clk signal from the Verilog with a repeating period of 10 ns
    
    # Reset state
    dut.rst.value = 1 # keeping the signal high to force it into reset state
    for _ in range(5): 
        await RisingEdge(dut.clk) # waiting for the rising edge 
    dut.rst.value = 0
    
    while dut.tx_ready.value.integer == 0: # while DUT is still not ready, still wait for the rising edge
        await RisingEdge(dut.clk)
    # drive state 
    dut.tx_data.value = 85 # I chose the value to be 85 as going between 1 and 0 for 8 bits would be 85 in decimal  
    dut.tx_valid.value = 1
    await RisingEdge(dut.clk)
    dut.tx_valid.value = 0 
    
    # breaking the pattern into individual bits to get the bit sequence of the DUT
    data = 85 
    bits = [0] # the start bit 
    for i in range(8): 
        bits.append((data >>i) & 1) # as known, LSB to MSB
    bits.append(1)
    final_bits = bits # the final UART frame for 85
    
    await Timer(bit_time / 2, units="ns")
    
    for i, bit in enumerate(final_bits):
        received_bit = int(dut.txd.value) # converting the binary value given by cocotb to get what the DUT is driving on the TX line
        assert received_bit == bit, f"Bit {i}: expected {bit} got {received_bit}" # checking that the sampled matches the position in the frame that we want
        await Timer(bit_time, units="ns") 