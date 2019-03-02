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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

use IEEE.std_logic_unsigned.all; -- additions
use ieee.numeric_std.all; 			-- to_unsigned
use IEEE.math_real.all; 			-- mathematical functions
 
ENTITY priority_decoder_3_8_tb IS
END priority_decoder_3_8_tb;
 
ARCHITECTURE behavior OF priority_decoder_3_8_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT priority_decoder_3_8
    PORT(
         input_signal : IN  std_logic_vector(2 downto 0);
         output_signal : OUT  std_logic_vector(7 downto 0);
         enable_in : IN  std_logic;
         clock : IN  std_logic;
         reset : IN  std_logic;
         strobe_in : IN  std_logic;
         strobe_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal input_signal : std_logic_vector(2 downto 0) := (others => '0');
   signal enable_in : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset : std_logic := '1';
   signal strobe_in : std_logic := '0';

 	--Outputs
   signal output_signal : std_logic_vector(7 downto 0);
   signal strobe_out : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: priority_decoder_3_8 PORT MAP (
          input_signal => input_signal,
          output_signal => output_signal,
          enable_in => '1',
          clock => clock,
          reset => reset,
          strobe_in => strobe_in,
          strobe_out => strobe_out
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;
		reset <= '0';

      -- insert stimulus here 

      wait;
   end process;
	
 process(clock)
		begin		
   
			if (rising_edge(clock)) then
				if (reset = '1') then		
					input_signal <= (others => '0');	
					strobe_in <= '0';
				else
				
					strobe_in <= '1';
					input_signal <= input_signal+1;
					--input_signal <= "111";
				

					
				end if;
			end if;
   end process;

END;
