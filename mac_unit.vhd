library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- mac_unit entity (has a running sum of a * b)
entity mac_unit is
	port (
	a, b : in signed(7 downto 0);	
	clk, reset : in std_logic;
	sum_out : out signed(31 downto 0)
	);
end entity mac_unit;

-- mac_unit architecture
architecture behavioral of mac_unit is
	-- hold the accumulated sum
	signal accumulator : signed(31 downto 0) := (others => '0');
begin
	-- updates on clk
	process(clk)
	begin
		-- if rising edge
		if rising_edge(clk) then
			-- if reset enabled, reset the sum to 0
			if reset = '1' then
				accumulator <= (others => '0');
			else
				-- add a * b to the sum
				accumulator <= accumulator + resize(a * b, 32);
			end if;
		end if;
	end process;
	
	-- set sum_out to new collective sum
	sum_out <= accumulator;
end architecture behavioral;