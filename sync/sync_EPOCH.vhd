--------------------------------------------------------------------------------------
-- Memoryless
--------------------------------------------------------------------------------------
-- Diary:	01/12/2017	Start
--				01/12/2017	Version 1.0	Dani
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

entity sync_EPOCH is
	GENERIC(WIDTH : integer := 32;
		COMP : integer := 1024;
		INITIAL_VALUE : integer := 0);	 		
	Port (clk : in std_logic;
		rst : in std_logic;
		data_in : in std_logic_vector(WIDTH-1 downto 0);
		data_out : out std_logic_vector(WIDTH-1 downto 0);
		strobe_in : in std_logic;
		strobe_out : out std_logic;
		strobe_cont : in std_logic);
end sync_EPOCH;

architecture Behavioral of sync_EPOCH is

	signal contador : integer range 0 to COMP-1;

	begin
		process(clk)
			begin
				if (rising_edge(clk)) then
					if (rst= '1') then
						strobe_out <= '0';
						data_out <= (others => '0');
						--contador <= 0;
						contador <= INITIAL_VALUE;
					else
						strobe_out <= strobe_in;

						if strobe_cont = '1' then
							if contador = COMP-1 then
								contador <= 0;
								data_out <= data_in;
							else
								contador <= contador+1;
							end if;
						end if;
				end if;
			end if;
		end process;
end Behavioral;