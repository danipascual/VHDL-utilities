--------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------
-- Diary:	29/11/2017	Start
--				29/11/2017	Version 1.0	Dani
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

entity decoder_accum_4_16 is
	Port (input_signal : in std_logic_vector(4-1 downto 0);
			output_signal : out STD_LOGIC_vector(16-1 downto 0);
			clock : in std_logic;
			reset : in std_logic;
			strobe_in : in std_logic;
			strobe_out : out std_logic);
end decoder_accum_4_16;

architecture Behavioral of decoder_accum_4_16 is

	type memory_type is array (0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
	--signal table : memory_type := (1, 3, 7, 15, 31, 63, 127, 255, 511, 1023, 2047, 4095, 8191, 16383, 32767, 65535);
	signal table : memory_type := (x"0001", x"0003", x"0007", x"000F", x"001F", x"003F", x"007F", x"00FF", x"01FF", x"03FF", x"07FF", x"0FFF", x"1FFF", x"3FFF", x"7FFF", x"FFFF");
	
	-- maybe it's better to use a ROM memory instead of a lookup table because many logic is neeeded for larger input_signal

	begin
				
		process(clock)
			begin		
				if (rising_edge(clock)) then
					if (reset = '1') then		

						output_signal <= (others=>'0');
						strobe_out <= '0';

					else			

						strobe_out <= strobe_in; -- check
						output_signal <= table(to_integer(unsigned(input_signal)));

					end if; -- rst
				end if; -- clck
		end process;
end Behavioral;