module lcd_driver (
    input  wire       clk,
    input  wire       signal_in,
    input  wire       mode_btn,
    output reg        lcd_rs,
    output reg        led_ind,
    output wire       lcd_e,
    output reg  [7:0] lcd_data
);

    // Internal Registers
    reg [7:0]  t_low        = 8'd0;
    reg [11:0] t_high       = 12'd0;
    reg [23:0] freq_count   = 24'd0;
    
    reg        sig_p        = 1'b0;
    reg        tick_prev    = 1'b0;
    reg        display_mode = 1'b0;
    
    integer    state        = 13;
    
    reg [3:0]  current_nibble;

    // Output assignment
    assign lcd_e = (state != 13 && t_low[5] == 1'b0 && t_low[4] == 1'b0) ? 1'b1 : 1'b0;

    // Main Sequential Process
    always @(posedge clk) begin
        sig_p     <= signal_in;
        tick_prev <= t_low[5];

        if (state == 13) begin
            // Rising edge detector on signal_in
            if (signal_in == 1'b1 && sig_p == 1'b0) begin
                if (display_mode == 1'b1) begin
                    freq_count <= freq_count + 1'b1;
                end else begin
                    // BCD Counter Logic
                    if (freq_count[3:0] == 4'd9) begin
                        freq_count[3:0] <= 4'h0;
                        if (freq_count[7:4] == 4'd9) begin
                            freq_count[7:4] <= 4'h0;
                            if (freq_count[11:8] == 4'd9) begin
                                freq_count[11:8] <= 4'h0;
                                if (freq_count[15:12] == 4'd9) begin
                                    freq_count[15:12] <= 4'h0;
                                    if (freq_count[19:16] == 4'd9) begin
                                        freq_count[19:16] <= 4'h0;
                                        if (freq_count[23:20] == 4'd9) begin
                                            freq_count[23:20] <= 4'h0;
                                        end else begin
                                            freq_count[23:20] <= freq_count[23:20] + 1'b1;
                                        end
                                    end else begin
                                        freq_count[19:16] <= freq_count[19:16] + 1'b1;
                                    end
                                end else begin
                                    freq_count[15:12] <= freq_count[15:12] + 1'b1;
                                end
                            end else begin
                                freq_count[11:8] <= freq_count[11:8] + 1'b1;
                            end
                        end else begin
                            freq_count[7:4] <= freq_count[7:4] + 1'b1;
                        end
                    end else begin
                        freq_count[3:0] <= freq_count[3:0] + 1'b1;
                    end
                end
            end

            // Timing Counters
            if (t_low == 8'd249) begin
                t_low <= 8'd0;
                if (t_high == 12'd2499) begin
                    t_high <= 12'd0;
                    state  <= 0;
                end else begin
                    t_high <= t_high + 1'b1;
                end
            end else begin
                t_low <= t_low + 1'b1;
            end

        end else begin
            t_low <= t_low + 1'b1;

            // Tick pulse detection on t_low[5]
            if (tick_prev == 1'b0 && t_low[5] == 1'b1) begin
                if (state == 12) begin
                    state      <= 13;
                    freq_count <= 24'd0;
                    t_low      <= 8'd0;
                    t_high     <= 12'd0;
                end else begin
                    state <= state + 1;
                end
            end
        end
    end

    // Display Mode Toggle (Button Process)
    always @(posedge mode_btn) begin
        display_mode <= ~display_mode;
    end

    // Combinational LCD Decoding Logic
    always @(*) begin
        lcd_rs         = 1'b0;
        lcd_data       = 8'h00;
        current_nibble = 4'h0;

        // Drive led_ind to display_mode status
        led_ind        = display_mode;

        case (state)
            0: lcd_data = 8'b00111000;
            1: lcd_data = 8'b00111000;
            2: lcd_data = 8'b00001100;
            3: lcd_data = 8'b10000000;

            4:  begin current_nibble = freq_count[23:20]; lcd_rs = 1'b1; end
            5:  begin current_nibble = freq_count[19:16]; lcd_rs = 1'b1; end
            6:  begin current_nibble = freq_count[15:12]; lcd_rs = 1'b1; end
            7:  begin current_nibble = freq_count[11:8];  lcd_rs = 1'b1; end
            8:  begin current_nibble = freq_count[7:4];   lcd_rs = 1'b1; end
            9:  begin current_nibble = freq_count[3:0];   lcd_rs = 1'b1; end

            10: begin lcd_rs = 1'b1; lcd_data = 8'b00100000; end
            11: begin lcd_rs = 1'b1; lcd_data = 8'b01001000; end
            12: begin lcd_rs = 1'b1; lcd_data = 8'b01111010; end
            default: ;
        endcase

        if (state >= 4 && state <= 9) begin
            case (current_nibble)
                4'h0: lcd_data = 8'b00110000; // '0'
                4'h1: lcd_data = 8'b00110001; // '1'
                4'h2: lcd_data = 8'b00110010; // '2'
                4'h3: lcd_data = 8'b00110011; // '3'
                4'h4: lcd_data = 8'b00110100; // '4'
                4'h5: lcd_data = 8'b00110101; // '5'
                4'h6: lcd_data = 8'b00110110; // '6'
                4'h7: lcd_data = 8'b00110111; // '7'
                4'h8: lcd_data = 8'b00111000; // '8'
                4'h9: lcd_data = 8'b00111001; // '9'
                4'hA: lcd_data = 8'b01000001; // 'A'
                4'hB: lcd_data = 8'b01000010; // 'B'
                4'hC: lcd_data = 8'b01000011; // 'C'
                4'hD: lcd_data = 8'b01000100; // 'D'
                4'hE: lcd_data = 8'b01000101; // 'E'
                4'hF: lcd_data = 8'b01000110; // 'F'
                default: lcd_data = 8'b00110000;
            endcase
        end
    end

endmodule
