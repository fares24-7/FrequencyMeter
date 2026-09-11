library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lcd_driver is
    Port (
        clk        : in  STD_LOGIC; 
        signal_in  : in  STD_LOGIC;
        lcd_rs     : out STD_LOGIC;
        lcd_e      : out STD_LOGIC;
        lcd_data   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end lcd_driver;

architecture Behavioral of lcd_driver is
    signal freq_count     : unsigned(39 downto 0) := (others => '0');
    
    signal timer_31k      : unsigned(14 downto 0) := (others => '0'); 
    
    signal state          : integer range 0 to 15 := 15; 
    signal reset_math     : std_logic := '0';
begin


    process(clk)
    begin
        if rising_edge(clk) then
            if state = 15 then
                if timer_31k = 31249 then
                    timer_31k <= (others => '0');
                    state <= 0; 
                else
                    timer_31k <= timer_31k + 1;
                end if;
            else
                if timer_31k = 63 then
                    timer_31k <= (others => '0');
                    
                    if state = 14 then
                        state <= 15; 
                    else
                        state <= state + 1;
                    end if;
                else
                    timer_31k <= timer_31k + 1;
                end if;
            end if;
        end if;
    end process;

    reset_math <= '1' when state = 14 else '0';
    process(signal_in, reset_math)
    begin
        if reset_math = '1' then
            freq_count <= (others => '0');
            
        elsif rising_edge(signal_in) then
            if state = 15 then
                if freq_count(3 downto 0) = 9 then
                    freq_count(3 downto 0) <= x"0";
                    if freq_count(7 downto 4) = 9 then
                        freq_count(7 downto 4) <= x"0";
                        if freq_count(11 downto 8) = 9 then
                            freq_count(11 downto 8) <= x"0";
                            if freq_count(15 downto 12) = 9 then
                                freq_count(15 downto 12) <= x"0";
                                if freq_count(19 downto 16) = 9 then
                                    freq_count(19 downto 16) <= x"0";
                                    if freq_count(23 downto 20) = 9 then
                                        freq_count(23 downto 20) <= x"0";
                                        if freq_count(27 downto 24) = 9 then
                                            freq_count(27 downto 24) <= x"0";
                                            if freq_count(31 downto 28) = 9 then
                                                freq_count(31 downto 28) <= x"0";
                                                if freq_count(35 downto 32) = 9 then
                                                    freq_count(35 downto 32) <= x"0";
                                                    if freq_count(39 downto 36) = 9 then
                                                        freq_count(39 downto 36) <= x"0";
                                                    else freq_count(39 downto 36) <= freq_count(39 downto 36) + 1; end if;
                                                else freq_count(35 downto 32) <= freq_count(35 downto 32) + 1; end if;
                                            else freq_count(31 downto 28) <= freq_count(31 downto 28) + 1; end if;
                                        else freq_count(27 downto 24) <= freq_count(27 downto 24) + 1; end if;
                                    else freq_count(23 downto 20) <= freq_count(23 downto 20) + 1; end if;
                                else freq_count(19 downto 16) <= freq_count(19 downto 16) + 1; end if;
                            else freq_count(15 downto 12) <= freq_count(15 downto 12) + 1; end if;
                        else freq_count(11 downto 8) <= freq_count(11 downto 8) + 1; end if;
                    else freq_count(7 downto 4) <= freq_count(7 downto 4) + 1; end if;
                else freq_count(3 downto 0) <= freq_count(3 downto 0) + 1; end if;
            end if;
        end if;
    end process;

    process(state, freq_count)
        variable current_nibble : unsigned(3 downto 0);
    begin
        lcd_rs <= '0';
        lcd_data <= "00000000";
        current_nibble := x"0";
        
        case state is
            when 0 => lcd_data <= "00111000"; 
            when 1 => lcd_data <= "00001100"; 
            when 2 => lcd_data <= "10000000";
            when 3  => current_nibble := freq_count(39 downto 36); lcd_rs <= '1';
            when 4  => current_nibble := freq_count(35 downto 32); lcd_rs <= '1';
            when 5  => current_nibble := freq_count(31 downto 28); lcd_rs <= '1';
            when 6  => current_nibble := freq_count(27 downto 24); lcd_rs <= '1';
            when 7  => current_nibble := freq_count(23 downto 20); lcd_rs <= '1';
            when 8  => current_nibble := freq_count(19 downto 16); lcd_rs <= '1';
            when 9  => current_nibble := freq_count(15 downto 12); lcd_rs <= '1';
            when 10 => current_nibble := freq_count(11 downto 8);  lcd_rs <= '1';
            when 11 => current_nibble := freq_count(7 downto 4);   lcd_rs <= '1';
            when 12 => current_nibble := freq_count(3 downto 0);   lcd_rs <= '1';

            when 13 => lcd_rs <= '1'; lcd_data <= "01001000"; -- 'H'
            when 14 => lcd_rs <= '1'; lcd_data <= "01111010"; -- 'z'
            
            when others => null;
        end case;

        if state >= 3 and state <= 12 then
            case current_nibble is
                when x"0" => lcd_data <= "00110000";
                when x"1" => lcd_data <= "00110001";
                when x"2" => lcd_data <= "00110010";
                when x"3" => lcd_data <= "00110011";
                when x"4" => lcd_data <= "00110100";
                when x"5" => lcd_data <= "00110101";
                when x"6" => lcd_data <= "00110110";
                when x"7" => lcd_data <= "00110111";
                when x"8" => lcd_data <= "00111000";
                when x"9" => lcd_data <= "00111001";
                when others => lcd_data <= "00110000";
            end case;
        end if;
    end process;
    lcd_e <= '1' when (state /= 15 and timer_31k(5) = '0') else '0';

end Behavioral;