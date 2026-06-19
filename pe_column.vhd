library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- creates pe_column
entity pe_column is
	port(
	clk, reset, load_weight : in std_logic;
	weight1, weight2, weight3, act_in : in signed(7 downto 0);
	sum_out : out signed(31 downto 0)
	);
end entity pe_column;

-- creates pe_column architecture
architecture structural of pe_column is	
	-- signals required for 3 pe units in a column
	signal sum_link_1_2 : signed(31 downto 0);
	signal sum_link_2_3 : signed(31 downto 0);
	signal act_unused_1 : signed(7 downto 0);
    signal act_unused_2 : signed(7 downto 0);
    signal act_unused_3 : signed(7 downto 0); 
begin
	-- pe1
	pe1: entity work.pe
		port map(clk => clk, reset => reset, load_weight => load_weight, weight => weight1, 
		act_in => act_in, act_out => act_unused_1, sum_in => (others => '0'), sum_out => sum_link_1_2);	
	-- pe2
	pe2: entity work.pe
		port map(clk => clk, reset => reset, load_weight => load_weight, weight => weight2, 
		act_in => act_in, act_out => act_unused_2, sum_in => sum_link_1_2, sum_out => sum_link_2_3);
	-- pe3
	pe3: entity work.pe
		port map(clk => clk, reset => reset, load_weight => load_weight, weight => weight3, 
		act_in => act_in, act_out => act_unused_3, sum_in => sum_link_2_3, sum_out => sum_out);
end architecture structural;