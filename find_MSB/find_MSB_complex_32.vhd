--------------------------------------------------------------------------------------
-- Finds the MSB of a 32 bits complex unsigned signal (i.e. 32 bits I + 32 bits Q). 
-- Pipeline is ensured by proper setting the priority_encoder_nested
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
use IEEE.numeric_std.all; 			-- to_signed, etc
use IEEE.std_logic_signed.all; 	-- additions

entity find_MSB_complex_32 is
		Generic (WIDTH_IN : integer := 32; 	  		-- pow of 2
					WIDTH_OUT : integer := 5;   		-- log2(WIDTH_IN)
					WEI : integer := 8);	-- size of the encoders (pow of 2)
		Port (input_signal_1 : in std_logic_vector(WIDTH_IN-1 downto 0); 	-- unsigned
				input_signal_2 : in std_logic_vector(WIDTH_IN-1 downto 0); 	-- unsigned
				output_signal : out STD_LOGIC_vector(WIDTH_OUT-1 downto 0);	-- unsigned
				enable_in : in std_logic; 		-- used for nesting
				valid_out : out std_logic; 	-- used for nesting
				clock : in std_logic;
				reset : in std_logic;
				strobe_in : in std_logic;
				strobe_out : out std_logic);	
end find_MSB_complex_32;

architecture Behavioral of find_MSB_complex_32 is

	signal strobe_encoder, strobe_max : std_logic;
	signal output_signal_1, output_signal_2, output_max : STD_LOGIC_vector(WIDTH_OUT-1 downto 0);
	signal input_signal_max_1, input_signal_max_2, output_signal_max : STD_LOGIC_vector(8-1 downto 0);
	
	COMPONENT priority_encoder_nested is
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
	END COMPONENT;		
	
	COMPONENT max_vector_8 is
		Generic (WIDTH : integer := 8); 	 
		Port (input_signal_1 : in std_logic_vector(WIDTH-1 downto 0); 	-- unsigned
				input_signal_2  : in std_logic_vector(WIDTH-1 downto 0); -- unsigned
				output_signal : out STD_LOGIC_vector(WIDTH-1 downto 0);	-- unsigned
				strobe_out : out std_logic; 	
				clock : in std_logic;
				reset : in std_logic;
				strobe_in : in std_logic); 
		END COMPONENT;	
		
	begin
	
		priority_encoder_nested_inst_1 : priority_encoder_nested 
			Generic map (WIDTH_IN => WIDTH_IN,
						WIDTH_OUT => WIDTH_OUT,
						WEI => WEI)
			Port map (input_signal =>  input_signal_1,
					output_signal =>  output_signal_1,
					enable_in => '1',
					valid_out => open,
					clock => clock,
					reset => reset,
					strobe_in => strobe_in,
					strobe_out => strobe_encoder);		
					
		priority_encoder_nested_inst_2 : priority_encoder_nested 
			Generic map (WIDTH_IN => WIDTH_IN,
						WIDTH_OUT => WIDTH_OUT,
						WEI => WEI)
			Port map (input_signal =>  input_signal_2,
					output_signal =>  output_signal_2,
					enable_in => '1',
					valid_out => open,
					clock => clock,
					reset => reset,
					strobe_in => strobe_in,
					strobe_out => open);		
		
		max_vector_inst : max_vector_8
			Generic map (WIDTH => 8)
			Port map (input_signal_1 => input_signal_max_1,
					input_signal_2 => input_signal_max_2,
					output_signal=> output_signal_max,
					strobe_out=> strobe_out,
					clock =>clock ,
					reset => reset,
					strobe_in => strobe_encoder); 
					
	input_signal_max_1 <=  "000" & output_signal_1;
	input_signal_max_2 <=  "000" & output_signal_2;
	output_signal <= output_signal_max(WIDTH_OUT-1 downto 0);
					
end Behavioral;				