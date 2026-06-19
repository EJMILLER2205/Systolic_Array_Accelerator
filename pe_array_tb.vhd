library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pe_array_pkg.all;

entity pe_array_tb is
end entity pe_array_tb;

architecture testbench of pe_array_tb is

    signal clk, reset, load_weight : std_logic;
    signal weights     : weight_matrix_t(0 to 2, 0 to 2);
    signal act_inputs  : act_vector_t(0 to 2);
    signal sum_outputs : sum_vector_t(0 to 2);

begin

    uut: entity work.pe_array
        generic map (N => 3)
        port map (
            clk         => clk,
            reset       => reset,
            load_weight => load_weight,
            weights     => weights,
            act_inputs  => act_inputs,
            sum_outputs => sum_outputs
        );

    clk_gen: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    stim_proc: process
    begin
        -- cycle 1: reset
        reset <= '1';
        wait for 10 ns;

        -- cycle 2: load weights
        -- W = | 1 4 7 |
        --     | 2 5 8 |
        --     | 3 6 9 |
        reset <= '0';
        load_weight <= '1';
        weights(0,0) <= to_signed(1, 8);
        weights(0,1) <= to_signed(4, 8);
        weights(0,2) <= to_signed(7, 8);
        weights(1,0) <= to_signed(2, 8);
        weights(1,1) <= to_signed(5, 8);
        weights(1,2) <= to_signed(8, 8);
        weights(2,0) <= to_signed(3, 8);
        weights(2,1) <= to_signed(6, 8);
        weights(2,2) <= to_signed(9, 8);
        wait for 10 ns;

        -- cycle 3: drop load_weight, feed activations x = [1, 2, 3]
        -- expected outputs (after settling): 14, 32, 50
        load_weight <= '0';
        act_inputs(0) <= to_signed(1, 8);
        act_inputs(1) <= to_signed(2, 8);
        act_inputs(2) <= to_signed(3, 8);
        wait for 80 ns;  --  settle time for the result to propagate fully
        wait;
    end process;

end architecture testbench;