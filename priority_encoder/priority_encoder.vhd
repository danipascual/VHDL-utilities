--------------------------------------------------------------------------------------
-- Finds the MSB of a vector. Pipeline is not ensured if the vector is too large.
-- Input must be power of 2 and signed positive. 
-- This program should take less than strobe_in period and the data must be valid during this time
--	Delay depends alot on transitions
-- Latency one clock
-- Truth table with WIDTH_IN = 4:
-- ENABLE_IN | INPUT | OUTPUT | VALID | ENABLE_OUT
--	0 				XXXX		00			0			0
--	1				0000		00			0			1
--	1				0001		00			1			0
--	1				001X		01			1			0
--	1				01XX		10			1			0
-- 1				1XXX		11			1			0
--------------------------------------------------------------------------------------
-- Author: Daniel Pascual (daniel.pascual [at] protonmail.com)
--
-- This work is licensed under the Creative Commons Attribution 4.0 International 
-- License. To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by/4.0/.
--------------------------------------------------------------------------------------
-- Diary:	4/03/2016	Start 
--				14/02/2017	Ready for nesting and syncing
--				20/02/2017	Inserted strobe_in
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

entity priority_encoder is
	Generic (WIDTH_IN : integer := 8; 	  -- pow of 2
				WIDTH_OUT : integer := 3);   -- log2(WIDTH_IN)
	Port (input_signal : in std_logic_vector(WIDTH_IN-1 downto 0); 	-- unsigned
			output_signal : out STD_LOGIC_vector(WIDTH_OUT-1 downto 0);	-- unsigned
			enable_out : out std_logic; 	-- used for nesting
			enable_in : in std_logic; 		-- used for nesting
			valid_out : out std_logic;		-- used for nesting
			strobe_out : out std_logic; 	
			clock : in std_logic;
			reset : in std_logic;
			strobe_in : in std_logic;
			output_MSB : out std_logic_vector(WIDTH_IN-1 downto 0));  -- unsigned
end priority_encoder;

architecture Behavioral of priority_encoder is

	function find_MSB(input_signal : STD_LOGIC_vector) return integer is	

		variable var : integer;
		
		begin
			var := (2**WIDTH_OUT)-1;
			for j in WIDTH_IN-1 downto 0 loop
				if input_signal(j) = '1' then
					return var;
				else
					var := var-1;
				end if;
			end loop;
			return var;	 -- zero
	end find_MSB;


	function find_MSB_vector(input_signal : STD_LOGIC_vector) return STD_LOGIC_vector is	

		variable var : std_logic_vector(WIDTH_IN-1 downto 0) := (others => '0');
		
		begin
			for j in WIDTH_IN-1 downto 0 loop
				if input_signal(j) = '1' then
					var(j) := '1';
					return var;
				end if;
			end loop;
			return var;	 -- zero
	end find_MSB_vector;	
	
	begin
		process(clock)
			begin		
				if (rising_edge(clock)) then
					if (reset = '1') then		
						enable_out <= '0';
						valid_out <= '0';
						output_signal <= (others => '0');
						strobe_out <= '0';
						output_MSB <= (others => '0');
					else			
					
						-- sync outputs with strobe_in
						enable_out <= '0'; 
						valid_out <= '0';	 
						strobe_out <= '0'; 
					
						if (enable_in = '1') then				
							if strobe_in = '1' then				-- not really needed..
								if (input_signal = 0) then
									enable_out <= '1';
									valid_out <= '0';	
									output_signal <= (others => '0'); 
									strobe_out <= '1';
									output_MSB <= (others => '0');									
								else
									enable_out <= '0';
									valid_out <= '1';
									output_signal <= std_logic_vector(to_unsigned(find_MSB(input_signal), output_signal'length));
									output_MSB <= find_MSB_vector(input_signal);
									
									strobe_out <= '1';
								end if; -- input_signal = 0							
							end if; -- strobe_in
						else	-- enable_in
							enable_out <= '0';
							valid_out <= '0';
							output_signal <= (others => '0'); 	
						end if; -- enable_in
					end if; -- rst
				end if; -- clck
		end process;
end Behavioral;