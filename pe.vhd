library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- creates pe entity
entity pe is
	port(
	clk, reset : in std_logic;
	load_weight : in std_logic;
	weight : in signed(7 downto 0);
	act_in : in signed(7 downto 0);
	act_out : out signed(7 downto 0);
	sum_in : in signed(31 downto 0);
	sum_out : out signed(31 downto 0)
	);
end entity pe;

-- creates pe architecture
architecture behavioral of pe is
	-- signals to hold weight, act, and sum
	signal stored_weight : signed(7 downto 0) := (others => '0');
	signal act_reg : signed(7 downto 0) := (others => '0');
	signal sum_reg : signed (31 downto 0) := (others => '0');

begin
	process(clk)
	begin
		-- if rising edge
		if rising_edge(clk) then
			-- if reset is enabled, set stored_weight, act_reg, and sum_reg to 0
			if reset = '1' then
				stored_weight <= (others => '0');
				act_reg <= (others => '0');
				sum_reg <= (others => '0');
			-- if load_weight is enabled, store the inputted weight into stored_weight
			elsif load_weight = '1' then
				stored_weight <= weight;
			-- else input new act_in into the act_reg, and compute the sum and save it into the sum_reg
			else
				act_reg <= act_in;
				sum_reg <= sum_in + resize(act_in * stored_weight, 32);
			end if;
		end if;
	end process;
	-- ouptut the act_reg
	act_out <= act_reg;
	-- output the sum_reg
	sum_out <= sum_reg;
end architecture behavioral;