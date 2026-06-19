library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- create testbench entity
entity mac_unit_tb is
end entity mac_unit_tb;

-- create testbench architecture
architecture testbench of mac_unit_tb is
-- all signals for testbench
signal a, b : signed(7 downto 0);
signal clk, reset : std_logic;
signal sum_out : signed(31 downto 0);

begin  
	-- port map
	uut: entity work.mac_unit
		port map(a => a, b => b, clk => clk, reset => reset, sum_out => sum_out);
	-- clock generation
	clk_gen: process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;
	
	stim_proc: process
	begin
		-- start by resetting the accumulator to 0
		reset <= '1';
		a <= to_signed(0, 8);
		b <= to_signed(0, 8);
		wait for 10 ns;
		
		reset <= '0';
		
		-- cycle 1: 2 * 3 = 6, total = 6
		a <= to_signed(2, 8);
		b <= to_signed(3, 8); 
		wait for 10 ns;
		-- cycle 2: 4 * 5 = 20, total = 26
		a <= to_signed(4, 8);
		b <= to_signed(5, 8);
		wait for 10 ns;
		-- cycle 3: -1 * 6 = -6, total = 20
		a <= to_signed(-1, 8);
		b <= to_signed(6, 8);
		wait for 10 ns;
		
		-- hold final values so they're easier to evaluate
		wait for 10 ns;
		
		wait;
	end process;
end architecture testbench;