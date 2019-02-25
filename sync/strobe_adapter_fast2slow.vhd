--------------------------------------------------------------------------------------
-- Adapts a strobe line from a fast clock to a slower clock.
--------------------------------------------------------------------------------------
-- Author: Dani
--------------------------------------------------------------------------------------
-- Diary:	06/04/2016	Start 
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
use IEEE.NUMERIC_STD.ALL; 
use IEEE.std_logic_signed.all; 	-- per multiplicar per -1 (complment a dos)
use IEEE.math_real.all; 			-- funcions matematiques

entity strobe_adapter_fast2slow is
	Generic(WIDTH : integer := 32;
		RATIO : integer := 10);
	Port(clk : in STD_LOGIC;		-- fast
		data : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
		strobe_in : in STD_LOGIC;
		rst : in STD_LOGIC;
		strobe_out : out STD_LOGIC;
		outputa : out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
end strobe_adapter_fast2slow;

architecture Behavioral of strobe_adapter_fast2slow is

	signal cont : integer;
	signal strobe_aux : std_logic;
	signal data_out : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	
	begin
	
		strobe_out <= strobe_aux;
		outputa <= data_out;
	
		process(clk)
			begin
				if (rising_edge(clk)) then 
					if (rst= '1') then
						strobe_aux <= '0';
						data_out <= (others => '0');
						cont <= 0;
					else
						if strobe_in = '1' then
							strobe_aux <= '1';
							data_out <= data;
						else
							data_out <= data_out;
						end if;
						
						if strobe_aux = '1' then
							cont <= cont+1;
							if (cont=(RATIO-1)) then 
								cont <= 0;
								strobe_aux <= '0';
							end if;							
						end if;
				end if;		
			end if;
		end process;
end Behavioral;