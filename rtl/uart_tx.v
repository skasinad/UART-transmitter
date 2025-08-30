module uart_tx #(
    parameter integer clk_hz = 50_000_000, baud_rate = 115_200
    //clk_hz for the frequency of the system's clock in hertz
    //baud_rate is the bit rate of the UART line 
)(
    input wire clk, 
    input wire rst, 
    input wire tx_valid, 
    input wire [7:0] tx_data, 

    output reg tx_ready, 
    output reg txd,
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
reg [timer_width-1:0] bit_timer; // metronome
reg [2:0] bit_index; // pointer for bit currently being processed 
reg [7:0] current_byte; // the byte captured at exact time during transition

always @(posedge clk) begin 
    if(rst) begin // if rst = 1 
        current_state <= idle_state;
        bit_index <= 3'b000; 
        bit_timer <= {timer_width{1'b0}}; 
        current_byte <= 8'b00000000;
        txd <= 1'b1;
        tx_ready <= 1'b1;  
    end else begin
        case (current_state)
            idle_state: begin
                txd <= 1'b1; 
                tx_ready <= 1'b1; 
                bit_timer <= {timer_width{1'b0}};

                if(tx_valid && tx_ready) begin
                    current_byte <= tx_data; // data being transmitted is whatever the byte is at the time 
                    txd <= 1'b0; // data line down to 0 as state is no longer idle
                    tx_ready <= 1'b0; // busy in transmission, down to 0
                    bit_timer <= {timer_width{1'b0}}; // beginning of the clock cycle, hence set down to 0 for starting value
                    current_state <= start_state; 
                end  
            end
            start_state: begin
                txd <= 1'b0; 
                tx_ready <= 1'b0;
                // the bit has been held long enough 
                if(bit_timer == clks_per_bit-1) begin
                    bit_timer <= {timer_width{1'b0}};
                    bit_index <= 3'd0;
                    txd <= current_byte[0]; // data line set to the LSB of the byte to be transmitted to signal the beginning of the transmission
                    current_state <= data_state; 
                end else begin
                    bit_timer <= bit_timer + 1'b1; 
                end 
            end 
            data_state: begin
                tx_ready <= 1'b0; 
                txd <= current_byte[bit_index];
                if(bit_timer == clks_per_bit - 1) begin // for if this bit period is complete
                    bit_timer <= {timer_width{1'b0}}; // reset the timer 

                    if (bit_index == 3'd7) begin // if we finished the 7th bit of current_byte
                        txd <= 1'b1; 
                        current_state <= stop_state;  
                    end else begin 
                        bit_index <= bit_index + 1'b1; 
                    end 
                end else begin
                    bit_timer <= bit_timer + 1'b1;  
                end   
            end 
            stop_state: begin
                tx_ready <= 1'b0;
                txd <= 1'b1; 
                if(bit_timer == clks_per_bit - 1) begin
                    bit_timer <= {timer_width{1'b0}};
                    current_state <= idle_state;
                    tx_ready <= 1'b1; // ready to accept new data again as state is back in idle  
                end else begin
                    bit_timer <= bit_timer + 1'b1; 
                end 
            end  
        endcase   
    end 
end 

endmodule   