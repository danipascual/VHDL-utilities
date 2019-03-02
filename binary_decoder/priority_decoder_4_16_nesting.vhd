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

--https://circuitdigest.com/tutorial/binary-decoder-basics-circuit-truth-tables-applications

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity priority_decoder_4_16_nesting is
	Port (input_signal : in std_logic_vector(4-1 downto 0);
			output_signal : out STD_LOGIC_vector(16-1 downto 0);
			enable_in : in std_logic; 		-- used for nesting
			clock : in std_logic;
			reset : in std_logic;
			strobe_in : in std_logic;
			strobe_out : out std_logic);
end priority_decoder_4_16_nesting;

architecture Behavioral of priority_decoder_4_16_nesting is


	COMPONENT priority_decoder_3_8
		Port (input_signal : in std_logic_vector(3-1 downto 0);
				output_signal : out STD_LOGIC_vector(8-1 downto 0);
				enable_in : in std_logic; 		-- used for nesting
				clock : in std_logic;
				reset : in std_logic;
				strobe_in : in std_logic;
				strobe_out : out std_logic);
	END COMPONENT;

	begin
	
		
		priority_decoder_3_8_1 : priority_decoder_3_8	
			PORT MAP(input_signal => input_signal(2 downto 0),
				output_signal => output_signal(16-1 downto 8),
				enable_in => input_signal(3),
				clock => clock,
				reset => reset,
				strobe_in => strobe_in,
				strobe_out => strobe_out
				);
		
		priority_decoder_3_8_2 : priority_decoder_3_8	
			PORT MAP(input_signal => input_signal(2 downto 0),
				output_signal => output_signal(7 downto 0),
				enable_in => (not input_signal(3)),		-- si ho vas fent fins l'infiit, són molts NOTs acumulats..
				clock => clock,
				reset => reset,
				strobe_in => strobe_in,
				strobe_out => open
				);
				
end Behavioral;