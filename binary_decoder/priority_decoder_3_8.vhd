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


entity priority_decoder_3_8 is
	Port (input_signal : in std_logic_vector(3-1 downto 0);
			output_signal : out STD_LOGIC_vector(8-1 downto 0);
			enable_in : in std_logic; 		-- used for nesting
			clock : in std_logic;
			reset : in std_logic;
			strobe_in : in std_logic;
			strobe_out : out std_logic);
end priority_decoder_3_8;

architecture Behavioral of priority_decoder_3_8 is

	signal strobe_in_d, enable_in_d, enable_in_d2 : std_logic;

	type matriu is array (0 to 8-1) of STD_LOGIC_VECTOR(3-1 downto 0);
	signal signal_matrix : matriu;

	signal result : STD_LOGIC_VECTOR(8-1 downto 0);

	COMPONENT AND_sync
		GENERIC(WIDTH : integer := 3;
				L : integer := 3);
		PORT(clk : in STD_LOGIC;
				rst : in STD_LOGIC;
				x_in : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
				x_out : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
				result : out STD_LOGIC);
	END COMPONENT;

	begin
	
		signal_matrix(7) <= input_signal(2) & input_signal(1) & input_signal(0);
		signal_matrix(6) <= input_signal(2) & input_signal(1) & (not input_signal(0));
		signal_matrix(5) <= input_signal(2) & (not input_signal(1)) & input_signal(0);
		signal_matrix(4) <= input_signal(2) & (not input_signal(1)) & (not input_signal(0));
		signal_matrix(3) <= (not input_signal(2)) & input_signal(1) & input_signal(0);
		signal_matrix(2) <= (not input_signal(2)) & input_signal(1) & (not input_signal(0));
		signal_matrix(1) <= (not input_signal(2)) & (not input_signal(1)) & input_signal(0);
		signal_matrix(0) <= (not input_signal(2)) & (not input_signal(1)) & (not input_signal(0));
	
	
		AND_sync_chain : for i in 0 to 8-1 generate 
			AND_sync_inst : AND_sync	
				GENERIC MAP(WIDTH => 3,
					L => 3)
				PORT MAP(clk => clock,
					rst => reset,
					x_in => signal_matrix(i),
					x_out => open,
					result => result(i));
		end generate AND_sync_chain;
				
		process(clock)
			begin		
				if (rising_edge(clock)) then
					if (reset = '1') then		

						output_signal <= (others=>'0');
						strobe_out <= '0';
						strobe_in_d <= '0';
						enable_in_d <= '0';
						enable_in_d2 <= '0';

					else			
						strobe_in_d <= strobe_in;
						enable_in_d <= enable_in;
						enable_in_d2<= enable_in_d;
					
						strobe_out <= strobe_in_d;		-- check, needs to be delayed again
						
						if (enable_in_d2 = '1') then
							output_signal <= result;
						else
							output_signal <= (others=>'0');
						end if;
					

					end if; -- rst
				end if; -- clck
		end process;
end Behavioral;