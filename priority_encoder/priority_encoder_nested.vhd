--------------------------------------------------------------------------------------
-- Finds the MSB of a vector. Pipeline is ensured by nesting compare_vectors and by 
-- proper setting their size.
-- Latency = WIDTH_IN/WEI+4 ?
--------------------------------------------------------------------------------------
-- Author: Dani
--------------------------------------------------------------------------------------
-- Diary:	9/02/2017	Start 
--				22/02/2017	Ready
--------------------------------------------------------------------------------------
-- Author: Daniel Pascual (daniel.pascual at protonmail.com) 
-- Copyright 2017 Daniel Pascual
-- License: GNU GPLv3
--------------------------------------------------------------------------------------
-- Copyright 2017 Daniel Pascual
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all; -- additions
use ieee.numeric_std.all; 			-- to_unsigned
use IEEE.math_real.all; 			-- mathematical functions

entity priority_encoder_nested is
	Generic (WIDTH_IN : integer := 32; 	  		-- pow of 2
				WIDTH_OUT : integer := 5;   		-- log2(WIDTH_IN)
				WEI : integer := 8);	-- size of the encoders (pow of 2)
	Port (input_signal : in std_logic_vector(WIDTH_IN-1 downto 0); 	-- unsigned
			output_signal : out STD_LOGIC_vector(WIDTH_OUT-1 downto 0);	-- unsigned
			enable_in : in std_logic; 		-- used for nesting
			valid_out : out std_logic; 	-- used for nesting
			clock : in std_logic;
			reset : in std_logic;
			strobe_in : in std_logic;
			strobe_out : out std_logic);
end priority_encoder_nested;

architecture Behavioral of priority_encoder_nested is

	constant N : integer := integer(real(WIDTH_IN)/real(WEI));
	constant WEO : integer := integer(log2(real(WEI)));
	constant NLOG : integer := integer(log2(real(N)));
	constant LATENCY : integer := N+3;
	
	type ARRAY_2_N is array (0 to 2) of std_logic_vector(N-1 downto 0);	
	type ARRAY_N_WEI is array (0 to N-1) of std_logic_vector(WEI-1 downto 0);	
	type ARRAY_N_N_WEI is array (0 to N-1) of ARRAY_N_WEI;
	type ARRAY_N_WEO is array (0 to N-1) of std_logic_vector(WEO-1 downto 0);	
	type ARRAY_2_N_WEO is array (0 to 2) of ARRAY_N_WEO;		
	type ARRAY_N_NLOG is array (0 to N-1) of std_logic_vector(NLOG-1 downto 0);
	type ARRAY_2_N_NLOG is array (0 to 2) of ARRAY_N_NLOG;
	
	signal enable_vector : std_logic_vector(N-1+1 downto 0); 	
	signal valid_vector : std_logic_vector(N-1 downto 0); 	
	signal strobe_in_vector : std_logic_vector(N-1 downto 0);
	signal strobe_out_vector : std_logic_vector(LATENCY-1 downto 0);
	
	signal input_matrix : ARRAY_N_WEI;
	signal input_matrix_delayed : ARRAY_N_N_WEI;
	signal valid_encoders_matrix : ARRAY_2_N;
	signal mask : ARRAY_N_NLOG;	
	signal valid_encoders_matrix_AND_mask : ARRAY_N_NLOG;	
	signal MSB_matrix : ARRAY_2_N_NLOG;
	signal output_encoders : ARRAY_N_WEO; 
	signal LSB_matrix : ARRAY_2_N_WEO; 
	
	component priority_encoder is
		Generic (WIDTH_IN : integer := 8; 	 
					WIDTH_OUT : integer := 3);  
		Port (input_signal : in std_logic_vector(WIDTH_IN-1 downto 0); 	
				output_signal : out STD_LOGIC_vector(WIDTH_OUT-1 downto 0);	
				enable_out : out std_logic; 	
				enable_in : in std_logic; 		
				valid_out : out std_logic; 
				strobe_out : out std_logic; 				 
				clock : in std_logic;
				reset : in std_logic;
				strobe_in : in std_logic); 
	end component;	

	begin
	
		pe_chain : for i in 0 to N-1 generate 
			pe : priority_encoder
				Generic map (WIDTH_IN => WEI,
								WIDTH_OUT => WEO) 
				Port map (input_signal => input_matrix_delayed(0)(i)(WEI-1 downto 0),
							output_signal => output_encoders(i)(WEO-1 downto 0),
							enable_out =>  enable_vector(i),	
							enable_in => enable_vector(i+1),
							valid_out => valid_vector(i),
							strobe_out => open,
							clock => clock,
							reset => reset,
							strobe_in => strobe_in_vector(i));
		end generate pe_chain;
		
		-- input_signal to input_matrix
		fill_input_matrix : for i in 0 to N-1 generate
			input_matrix(i)(WEI-1 downto 0) <= input_signal((i+1)*WEI-1 downto i*WEI);
		end generate fill_input_matrix;	
		
		-- Create mask
		fill_mask : for i in 0  to N-1 generate 
			mask(i)(NLOG-1 downto 0) <= std_logic_vector(to_unsigned(i,NLOG));
		end generate fill_mask;
	
		-- Multiply mask by valid vector
		rows : for i in 0 to N-1 generate
			columns : for k in 0 to NLOG-1 generate
					valid_encoders_matrix_AND_mask(i)(k) <= valid_vector(i) and mask(i)(k);
			end generate columns;		
		end generate rows;		
		
		-- Outputs
		valid_out <= valid_encoders_matrix(1)(0);
		
		MSB : for k in WIDTH_OUT-1 downto WEO generate
			output_signal(k)<= MSB_matrix(1)(0)(k-WEO); 
		end generate MSB; 

		LSB : for k in WEO-1 downto 0 generate
			output_signal(k) <= LSB_matrix(1)(0)(k); 
		end generate LSB;
		
		strobe_out <= strobe_out_vector(LATENCY-1);
		
		process(clock)
			begin		
				if (rising_edge(clock)) then
					if (reset = '1') then		

						valid_encoders_matrix <= (others=>(others=>'0'));
						LSB_matrix <= (others=>(others=>(others=>'0')));
						input_matrix_delayed <= (others=>(others=>(others=>'0')));
						
						MSB_matrix <= (others=>(others=>(others=>'0')));
						
						enable_vector(N-1+1) <= '0';
						strobe_in_vector(N-1 downto 0) <= (others=>'0');
						
						strobe_out_vector <= (others=>'0');

					else			
					
						-- Delay strobe_out
						strobe_out_vector(0) <= strobe_in;
						strobe_out_vector(LATENCY-1 downto 1) <= strobe_out_vector(LATENCY-2 downto 0);
						
						-- Delay enable
						enable_vector(N-1+1) <= enable_in;	
						
						-- Delay strobe_in
						strobe_in_vector(N-1)<=strobe_in;						
						for i in 1 to N-1 loop
							strobe_in_vector(N-1-i) <= strobe_in_vector(N-1-i+1);
						end loop;
					
						-- Delay input
						for i in N-1 downto 0 loop
							input_matrix_delayed(i)(N-1-i)(WEI-1 downto 0) <= input_matrix(N-1-i)(WEI-1 downto 0 );	
						end loop;

						for j in N-2 downto 0 loop	
							for tt in (N-j-1) downto 1 loop
								input_matrix_delayed(tt-1)(j)(WEI-1 downto 0) <= input_matrix_delayed(tt)(j)(WEI-1 downto 0);
							end loop;
						end loop;	

						-- Valid signal
						valid_encoders_matrix(0)(N-1 downto 0) <= valid_vector;
						
						valid_encoders_matrix(1)(N-1) <= valid_encoders_matrix(0)(N-1);
						
						for i in N-1 downto 1 loop
							valid_encoders_matrix(1)(i-1) <= valid_encoders_matrix(1)(i) or valid_encoders_matrix(0)(i-1) ;
						end loop;
						
						-- MSB
						for k in NLOG-1 downto 0 loop
							
							MSB_matrix(1)(N-1)(k) <= MSB_matrix(0)(N-1)(k); 
						
							for i in N-1 downto 0 loop
								MSB_matrix(0)(i)(k) <= valid_encoders_matrix_AND_mask(i)(k); 
							end loop;
						end loop;
						
						for k in NLOG-1 downto 0 loop
							for i in N-2 downto 0 loop
								MSB_matrix(1)(i)(k) <= MSB_matrix(1)(i+1)(k) or MSB_matrix(0)(i)(k);
							end loop;
						end loop;
						
						-- LSB
						for k in WEO-1 downto 0 loop
						
							LSB_matrix(1)(N-1 )(k) <= LSB_matrix(0)(N-1 )(k);
						
							for i in N-1 downto 0 loop
								LSB_matrix(0)(i)(k) <= output_encoders(i)(k);
							end loop;
						end loop;
						
						for k in WEO-1 downto 0 loop
							for i in N-2 downto 0 loop
								LSB_matrix(1)(i)(k) <= LSB_matrix(1)(i+1)(k) or LSB_matrix(0)(i)(k);
							end loop;
						end loop;
						
					end if; -- rst
				end if; -- clck
		end process;
end Behavioral;