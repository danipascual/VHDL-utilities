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
use ieee.numeric_std.all; 			-- to_signed, etc
use IEEE.math_real.all; 			-- maths

entity pow_decoder is
	Generic(L : integer := 16;
		W : integer := 8);
  PORT(rst : IN STD_LOGIC;
	 clk : IN STD_LOGIC;
	 signal_out : out std_logic_vector(L-1 downto 0);
	 MSB : in integer range 0 to L-1);
end pow_decoder;

architecture Behavioral of pow_decoder is
	begin
		process(clk)
			begin
				if (rising_edge(clk)) then		
					if (rst = '1') then
						signal_out <= STD_LOGIC_VECTOR(to_unsigned(1,L));
					else
						if ((MSB+1) >= W) then
							signal_out <= STD_LOGIC_VECTOR(to_unsigned(2**(MSB+1-W),L));
						else 
							signal_out <= STD_LOGIC_VECTOR(to_unsigned(1,L));
						end if;
					end if; --rst
				end if; --clk
		end process;					
end Behavioral;