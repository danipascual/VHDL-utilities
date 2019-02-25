--------------------------------------------------------------------------------------
-- Sync signals with same rate
--------------------------------------------------------------------------------------
-- Diary:	01/12/2017	Start
--				01/12/2017	Version 1.0	Dani
--				31/01/2017	Added Initial values on reset
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

entity sync_SIGNALS is
	GENERIC(WIDTH_1 : integer := 32;
		WIDTH_2 : integer := 32;
		INITIAL_1 : integer := 0;
		INITIAL_2 : integer := 0);
	Port (clk : in std_logic;
		rst : in std_logic;
		data_in_1 : in std_logic_vector(WIDTH_1-1 downto 0);
		data_in_2 : in std_logic_vector(WIDTH_2-1 downto 0);
		data_out_1 : out std_logic_vector(WIDTH_1-1 downto 0);
		data_out_2 : out std_logic_vector(WIDTH_2-1 downto 0);
		strobe_in_1 : in std_logic;
		strobe_in_2 : in std_logic;
		strobe_out : out std_logic);
end sync_SIGNALS;

architecture Behavioral of sync_SIGNALS is

	signal data_in_1_aux : std_logic_vector(WIDTH_1-1 downto 0);
	signal data_in_2_aux : std_logic_vector(WIDTH_2-1 downto 0);
	
	signal data_1_changed, data_2_changed, data_1_changed_init, data_2_changed_init : std_logic;

	begin
		process(clk)
			begin
				if (rising_edge(clk)) then
					if (rst= '1') then
						strobe_out <= '0';
						data_out_1 <= (others => '0');
						data_out_2 <= (others => '0');
						data_in_1_aux <= (others => '0');
						data_in_2_aux <= (others => '0');
						
						data_2_changed <= '0';
						data_1_changed <= '0';
						
						if INITIAL_1 = 1 then
							data_1_changed_init <= '1';
						else
							data_1_changed_init <= '0';
						end if;
						
						if INITIAL_2 = 1 then
							data_2_changed_init <= '1';
						else
							data_2_changed_init <= '0';
						end if;						
					else

						strobe_out <= '0';

						if strobe_in_1 = '1' then

							if data_2_changed_init = '1' then
								data_2_changed_init <= '0';
								
								data_out_1 <= data_in_1;
								data_out_2 <= (others => '0');
								
								strobe_out <= '1';
								
							else
							
								data_in_1_aux <= data_in_1;

								if data_2_changed = '1' then
									data_1_changed <= '0';
									data_2_changed <= '0';
									
									--data_out_1 <= data_in_1_aux;
									data_out_1 <= data_in_1;				-- EOOOO!!
									data_out_2 <= data_in_2_aux;
									strobe_out <= '1';							
								else
									data_1_changed <= '1';
								end if;							
							end if;
							
						end if;

						if strobe_in_2 = '1' then
						

							if data_1_changed_init = '1' then
								data_1_changed_init <= '0';

								data_out_1 <= (others => '0');
								data_out_2 <= data_in_2;
								
								strobe_out <= '1';
								
							else						

								data_in_2_aux <= data_in_2;
								
								if data_1_changed = '1' then
									data_1_changed <= '0';
									data_2_changed <= '0';
									
									data_out_1 <= data_in_1_aux;
									--data_out_2 <= data_in_2_aux;		-- EOOOO!!
									data_out_2 <= data_in_2;
									strobe_out <= '1';							
								else
									data_2_changed <= '1';
								end if;		
							end if;								
						end if;						
						
				end if;
			end if;
		end process;
end Behavioral;