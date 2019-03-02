--------------------------------------------------------------------------------------
-- Finds the maximum between 2 unsigned vectors of 8 bits. Pipeline is ensured
--------------------------------------------------------------------------------------
-- Diary:	26/01/2018	Start 
--------------------------------------------------------------------------------------
-- Author: Daniel Pascual (daniel.pascual at protonmail.com) 
-- Copyright 2018 Daniel Pascual
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


entity max_vector_8 is
	Generic (WIDTH : integer := 8); 	  -- pow of 2
	Port (input_signal_1 : in std_logic_vector(WIDTH-1 downto 0); 	-- unsigned
			input_signal_2  : in std_logic_vector(WIDTH-1 downto 0); -- unsigned
			output_signal : out STD_LOGIC_vector(WIDTH-1 downto 0);	-- unsigned
			strobe_out : out std_logic; 	
			clock : in std_logic;
			reset : in std_logic;
			strobe_in : in std_logic); 
end max_vector_8;

architecture Behavioral of max_vector_8 is

--	function find_MAX(signal input_signal_A, input_signal_B : std_logic_vector) return std_logic_vector is	
--		begin
--			--for j in WIDTH-1 downto 1 loop
--			for j in WIDTH-1 downto 0 loop
--				if (input_signal_A(j) = '1') and (input_signal_B(j) = '0')  then
--					return input_signal_A;
--				elsif (input_signal_A(j) = '0') and (input_signal_B(j) = '1')  then
--					return input_signal_B;
--				end if;
--			end loop;
--			
--			return input_signal_A;
--			
----			if (input_signal_A(0) = '1') and (input_signal_B(0) = '0')  then
----				return input_signal_A;
----			elsif (input_signal_A(0) = '0') and (input_signal_B(0) = '1')  then
----				return input_signal_B;
----			else
----				return input_signal_A;
----			end if;			
--	end find_MAX;	
	
	
--	function find_MAX (signal input_signal_A, input_signal_B : std_logic_vector) return std_logic_vector is
--		begin
--			if (input_signal_A) >= (input_signal_B) then
--				return input_signal_A;
--			else
--				return input_signal_B;
--			end if;		
--	end find_MAX;	

	signal s : std_logic_vector(WIDTH downto 0);
	signal strobe_in_d : std_logic;
	signal input_signal_1_d, input_signal_2_d : std_logic_vector(WIDTH-1 downto 0);
	
	COMPONENT SUBSTRACTER_8UNSIGNED_8UNSIGNED
		Port(a : in std_logic_vector(WIDTH-1 downto 0);
			b : in std_logic_vector(WIDTH-1 downto 0);
			clk : in std_logic;
			sclr : in std_logic;
			s : out std_logic_vector(WIDTH downto 0));
	END COMPONENT;

	begin
	
		SUBS : SUBSTRACTER_8UNSIGNED_8UNSIGNED
			Port map(a => input_signal_1,
				b => input_signal_2,
				clk => clock,
				sclr => reset,
				s => s);

		process(clock)
			begin		
				if (rising_edge(clock)) then
					if (reset = '1') then		
						output_signal <= (others => '0');
						strobe_out <= '0';
						strobe_in_d <= '0';
						input_signal_1_d <= (others => '0');
						input_signal_2_d <= (others => '0');
					else			
					
						strobe_in_d <= strobe_in;
						strobe_out <= strobe_in_d;
						input_signal_1_d <= input_signal_1;
						input_signal_2_d <= input_signal_2;
					
						if s(WIDTH) = '0' then
							output_signal <= input_signal_1_d;
						else
							output_signal <= input_signal_2_d;
						end if;

					end if; -- rst
				end if; -- clck
		end process;
end Behavioral;