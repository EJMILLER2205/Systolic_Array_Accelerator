library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pe_array_pkg is
	
	-- 2D array of weights: indexed [row][col]
	type weight_matrix_t is array (natural range <>, natural range<>) of signed(7 downto 0);
	
	-- 1D array of activations: one entry per row
	type act_vector_t is array (natural range <>) of signed(7 downto 0);
	
	-- 1D array of sums: one entry per column (final outputs)
	type sum_vector_t is array (natural range <>) of signed(31 downto 0);
	
	-- internal 2D arrays used to wire the grid together
	type act_grid_t is array (natural range <>, natural range <>) of signed(7 downto 0);
	type sum_grid_t is array (natural range <>, natural range <>) of signed(31 downto 0); 

end package;