--------------------------------------------------------------------------------------
-- Finds the MSB of a 32 bits complex signal (i.e. 32 bits I + 32 bits Q) with a 
-- non-sliding window of "EPOCH" samples. Pipeline is ensured by proper setting the
-- priority_encoder_nested.
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

entity find_MSB_complex_epoch_32 is
		Generic (WIDTH_IN : integer := 32; 	  		-- pow of 2
					WIDTH_OUT : integer := 5;   		-- log2(WIDTH_IN)
					WEI : integer := 8;	-- size of the encoders (pow of 2)
					EPOCH : integer := 16384);
		Port (input_signal_1 : in std_logic_vector(WIDTH_IN-1 downto 0); 	-- unsigned
				input_signal_2 : in std_logic_vector(WIDTH_IN-1 downto 0); 	-- unsigned
				output_signal : out STD_LOGIC_vector(WIDTH_OUT-1 downto 0);	-- unsigned
				enable_in : in std_logic; 		-- used for nesting
				valid_out : out std_logic; 	-- used for nesting
				clock : in std_logic;
				reset : in std_logic;
				strobe_in : in std_logic;
				strobe_out : out std_logic);
end find_MSB_complex_epoch_32;

architecture Behavioral of find_MSB_complex_epoch_32 is

	signal output_encoder : STD_LOGIC_vector(WIDTH_OUT-1 downto 0);
	signal output_encoder_aux, output_encoder_sync, max_out, max_out_sync, max_out_aux : STD_LOGIC_VECTOR(8-1 downto 0);
	signal strobe_encoder, strobe_sync, strobe_max,strobe_max_aux : STD_LOGIC;
	
	signal contador : integer range 0 to EPOCH-1;
	
	COMPONENT find_MSB_complex_32 is
		Generic (WIDTH_IN : integer := 32; 	  	
					WIDTH_OUT : integer := 5;   		
					WEI : integer := 8);
		Port (input_signal_1 : in std_logic_vector(WIDTH_IN-1 downto 0); 
				input_signal_2 : in std_logic_vector(WIDTH_IN-1 downto 0); 
				output_signal : out STD_LOGIC_vector(WIDTH_OUT-1 downto 0);	
				enable_in : in std_logic; 		
				valid_out : out std_logic; 	
				clock : in std_logic;
				reset : in std_logic;
				strobe_in : in std_logic;
				strobe_out : out std_logic);		
	END COMPONENT;
	
	COMPONENT sync_SIGNALS is
		GENERIC(WIDTH_1 : integer := 8;
			WIDTH_2 : integer := 8;
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
	END COMPONENT;			
	
	COMPONENT max_vector_8 is
		Generic (WIDTH : integer := 8); 	 
		Port (input_signal_1 : in std_logic_vector(WIDTH-1 downto 0); 	
				input_signal_2  : in std_logic_vector(WIDTH-1 downto 0);
				output_signal : out STD_LOGIC_vector(WIDTH-1 downto 0);	
				strobe_out : out std_logic; 	
				clock : in std_logic;
				reset : in std_logic;
				strobe_in : in std_logic); 
		END COMPONENT;		

	begin
	
		find_MSB_complex_inst : find_MSB_complex_32
				Generic map (WIDTH_IN => WIDTH_IN,
							WIDTH_OUT => WIDTH_OUT,
							WEI => WEI)
				Port map (input_signal_1 => input_signal_1,
						input_signal_2 => input_signal_2,
						output_signal => output_encoder,
						enable_in => '1',
						valid_out => open,
						clock => clock,
						reset => reset, 
						strobe_in => strobe_in,
						strobe_out => strobe_encoder);

		output_encoder_aux <=  "000" & output_encoder;				
						
		sync_SIGNALS_inst : sync_SIGNALS
			GENERIC MAP(WIDTH_1 => 8,
				WIDTH_2 => 8,
				INITIAL_1 => 0,
				INITIAL_2  => 1)
			Port map (clk => clock,
				rst => reset, 
				data_in_1 => output_encoder_aux,
				data_in_2 => max_out_aux,
				data_out_1 => output_encoder_sync,
				data_out_2 => max_out_sync,
				strobe_in_1 => strobe_encoder,
				strobe_in_2 => strobe_max_aux,
				strobe_out => strobe_sync);							

		max_vector_inst : max_vector_8
			Generic map (WIDTH => 8)
			Port map (input_signal_1 =>  output_encoder_sync,
					input_signal_2 => max_out_sync,
					output_signal=> max_out,
					strobe_out=> strobe_max,
					clock => clock ,
					reset => reset,
					strobe_in => strobe_sync); 
					
		strobe_out <= strobe_max;
		output_signal <= max_out(WIDTH_OUT-1 downto 0);							

		process(clock)
			begin
				if (rising_edge(clock)) then
					if (reset= '1') then
--						contador <= EPOCH-1;
						contador <= 0;
						max_out_aux <= (others => '0');
						strobe_max_aux <= '0';
					else
						
						strobe_max_aux <= strobe_max;
						
						if strobe_max = '1' then
							if contador < EPOCH-1 then
								contador <= contador+1;
							else
								contador <= 0;
							end if;
							
							if contador = EPOCH-1 then			 -- abans 0
								max_out_aux <= (others => '0');
							else
								max_out_aux  <= max_out;
							end if;									
							
						end if;

--						if contador = EPOCH-1 then			 -- abans 0
--							max_out_aux <= (others => '0');
--						else
--							max_out_aux  <= max_out;
--						end if;								

					end if;
				end if;
		end process;		
end Behavioral;