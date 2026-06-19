library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pe_column_tb is
end entity pe_column_tb;

architecture testbench of pe_column_tb is 
-- creates all port map signals
signal clk, reset, load_weight : std_logic;
signal weight1, weight2, weight3, act_in : signed(7 downto 0);
signal sum_out : signed(31 downto 0);
begin
	-- port map
	uut: entity work.pe_column
		port map(clk => clk, reset => reset, load_weight => load_weight, weight1 => weight1,
		weight2 => weight2, weight3 => weight3, act_in => act_in, sum_out => sum_out);
		
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
		-- cycle 1
		reset <= '1';
		wait for 10 ns;	 
		
		-- cycle 2
		reset <= '0';
		load_weight <= '1';
		weight1 <= to_signed(2, 8);
		weight2 <= to_signed(3, 8);
		weight3 <= to_signed(5, 8);	
		act_in <= to_signed(5, 8);
		wait for 10 ns;	   
		
		--cycle 3
		load_weight <= '0';
		wait for 40 ns;
		wait;
	end process;
end architecture testbench;
		