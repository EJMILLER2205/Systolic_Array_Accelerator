library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.pe_array_pkg.all;

-- create pe_array entity
entity pe_array is
	generic (
	N : integer := 3 -- NxN array
	);
	
	port (
	clk, reset, load_weight : in std_logic;
	weights : in weight_matrix_t(0 to N-1, 0 to N-1);
	act_inputs : in act_vector_t(0 to N-1);
	sum_outputs : out sum_vector_t(0 to N-1)
	);
end entity pe_array;

-- create pe_array architecture
architecture structural of pe_array is
-- act_grid(row, col): activation arriving at PE(row, col) from its left neighbor
-- col index 0...N is used: col = 0 is the external input edge, col = N is unused output edge
signal act_grid : act_grid_t(0 to N-1, 0 to N);	 

-- sum_grid(row, col): partial sum arriving at PE(row, col) from its top neighbor
-- row index 0...N is used: row = 0 is tied to zero (top edge), row = N is the external output edge
signal sum_grid : sum_grid_t(0 to N, 0 to N-1);

begin
	-- tie external activation inputs into the left edge of the grid
	feed_acts : for r in 0 to N-1 generate
		act_grid(r, 0) <= act_inputs(r);
	end generate feed_acts;
	
	-- tie zero into the top edge of every column (nothing above the first row)
	feed_sums: for c in 0 to N-1 generate
		sum_grid(0, c) <= (others => '0');
	end generate feed_sums;
	
	-- tie the bottom edge of the grid out to the external outputs
	drain_sums: for c in 0 to N-1 generate
		sum_outputs(c) <= sum_grid(N, c);
	end generate drain_sums;
	
	-- generate the actual NxN grid of PEs
	row_gen: for r in 0 to N-1 generate
		col_gen: for c in 0 to N-1 generate
		begin
			pe_inst: entity work.pe
				port map(clk => clk, reset => reset, load_weight => load_weight, weight => weights(r, c),
				act_in => act_grid(r, c), act_out => act_grid(r, c+1), sum_in => sum_grid(r, c), sum_out => sum_grid(r+1, c));
		end generate col_gen;
	end generate row_gen;
		
end architecture structural;