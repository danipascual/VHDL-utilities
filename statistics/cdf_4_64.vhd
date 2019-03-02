--------------------------------------------------------------------------------------
-- To be finished. Counter to 64 and reset the accumulatros
--  manage strobe lines
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
use IEEE.math_real.all;			-- maths


entity cdf_4_64 is
	PORT(clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			input_signal : in std_logic_vector(4-1 downto 0);
			strobe_in : in std_logic;
			strobe_out : out std_logic);			
end cdf_4_64;

architecture Behavioral of cdf_4_64 is


	signal signal_decoded : std_logic_vector(16-1 downto 0);
	signal strobe_decoded : std_logic;
	
	type matriu is array (0 to 16-1) of std_logic_vector(6 downto 0);
	signal result : matriu;	
	
	component decoder_accum_4_16
		Port (input_signal : in std_logic_vector(4-1 downto 0);
				output_signal : out STD_LOGIC_vector(16-1 downto 0);
				clock : in std_logic;
				reset : in std_logic;
				strobe_in : in std_logic;
				strobe_out : out std_logic);
		end component;

	COMPONENT ACUM_2_7
	  PORT (
		 b : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 clk : IN STD_LOGIC;
		 ce : IN STD_LOGIC;
		 sclr : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	  );				
	  end component;

	begin
	
		decoder_accum_4_16_inst : decoder_accum_4_16
			Port map(input_signal => input_signal, 
					output_signal => signal_decoded,
					clock  => clk,
					reset  => rst,
					strobe_in  => strobe_in,
					strobe_out => strobe_decoded);	
					
		ACUM_2_7_chain : for i in 0 to 16-1 generate 
			ACUM_2_7_inst : ACUM_2_7
			  PORT MAP (
				 b => "01",
				 clk => clk,
				 ce => (signal_decoded(i) and strobe_decoded),
				 sclr => '0',
				 q => result(i));
		end generate ACUM_2_7_chain;					

		process (clk)
			begin
				if (rising_edge(clk)) then
					if (rst = '1') then
						strobe_out <= '0';
					else
--						strobe_out <= '1';
					end if;
				end if;
		end process;

end Behavioral;
