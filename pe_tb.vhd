library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity pe_tb is
end entity pe_tb;

architecture testbench of pe_tb is
	-- creates all port map signals
	signal clk, reset, load_weight : std_logic;
	signal weight, act_in, act_out : signed(7 downto 0);
	signal sum_in, sum_out : signed(31 downto 0);

begin
	-- port map
	uut: entity work.pe
		port map(clk => clk, reset => reset, load_weight => load_weight, weight => weight, 
		act_in => act_in, act_out => act_out, sum_in => sum_in, sum_out => sum_out);
		
	-- clock gen
	clk_gen: process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;
	
	stim_proc: process
	begin
		-- cycle 1 - reset
		reset <= '1';
		wait for 10 ns;	
		
		-- cycle 2 - input weight 
		reset <= '0';
		load_weight <= '1';
		weight <= to_signed(5, 8);
		wait for 10 ns;	
		
		-- cycle 3 - reset sum_in and sum_in is 2, sum_out = 10
		load_weight <= '0';
		sum_in <= to_signed(0, 32);
		act_in <= to_signed(2, 8);
		wait for 10 ns;		   
		
		-- cycle 4 - sum_in is 7, sum_out = 45 
		act_in <= to_signed(7, 8);	
		sum_in <= sum_out;
		wait for 10 ns;	   
		
		-- cycle 5 - sum_in is 1, sum_out = 50	  		
		act_in <= to_signed(1, 8); 
		sum_in <= sum_out;
		wait for 10 ns;
		wait;
	end process;
end architecture testbench;
		