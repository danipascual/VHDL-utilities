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

use ieee.numeric_std.all;

 
ENTITY priority_encoder_nested_tb IS
END priority_encoder_nested_tb;
 
ARCHITECTURE behavior OF priority_encoder_nested_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT priority_encoder_nested
    PORT(
         input_signal : IN  std_logic_vector(32-1 downto 0);
         output_signal : OUT  std_logic_vector(5-1 downto 0);
         enable_in : IN  std_logic;
         valid_out : OUT  std_logic;
         clock : IN  std_logic;
         reset : IN  std_logic;
			strobe_in : in std_logic;
			strobe_out : out std_logic);			
    END COMPONENT;
	 
   --Inputs
	signal input_signal_aux : std_logic_vector(32-1 downto 0) := (others => '0');	
--	signal input_signal_aux : std_logic_vector(64-1 downto 0) := (others => '0');
--	signal input_signal_aux : std_logic_vector(64-1 downto 0) :=   std_logic_vector(to_unsigned(685420, 64));
--	signal input_signal_aux : std_logic_vector(64-1 downto 0) :=   std_logic_vector(to_unsigned(1, 64));
	--signal input_signal_aux : std_logic_vector(128-1 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001";	
	
	
   signal enable_in : std_logic := '1';
   signal clock : std_logic := '0';
   signal reset : std_logic := '1';
	signal strobe_in : std_logic := '1';
	signal strobe_out : std_logic;
	signal strobe_in_aux : std_logic;
	
	signal input_signal : std_logic_vector(32-1 downto 0) := (others => '0');
	signal cont : std_logic;
	

 	--Outputs
   signal output_signal : std_logic_vector(5-1 downto 0);
   signal valid_out : std_logic;

   -- Clock period definitions
   --constant clock_period : time := 10 ns; -- 100 MHz
	constant clock_period : time := 5 ns; -- 200 MHz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: priority_encoder_nested 
		PORT MAP (
          input_signal => input_signal,
          output_signal => output_signal,
          enable_in => enable_in,
          valid_out => valid_out,
          clock => clock,
          reset => reset,
			 strobe_in => strobe_in_aux,
			 --strobe_in => '1',
			 strobe_out => strobe_out);

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
		
		wait for clock_period*10+clock_period/2;

		input_signal_aux <= std_logic_vector(to_unsigned(685420, input_signal_aux'length));	
		
		wait for clock_period*100;
		input_signal_aux <= (others => '0');
		
		wait for clock_period*100;
		input_signal_aux <= "10000000000000000000000000000000";

		wait for clock_period*100;
		input_signal_aux <= std_logic_vector(to_unsigned((2147483647-1)/2, input_signal_aux'length));	

		wait for clock_period*100;
		input_signal_aux(input_signal_aux'length-1) <= '1'; 
		input_signal_aux(input_signal_aux'length-2 downto 0) <= (others => '0');

		wait for clock_period*100;		
		input_signal_aux <= std_logic_vector(to_unsigned(3989504, input_signal_aux'length));	
		
		wait for clock_period*100;
		input_signal_aux <= (others => '0');
		
		wait for clock_period*100;
		input_signal_aux <= "01100000000000100000000000000000";
		
		wait for clock_period*100;
		input_signal_aux <= (others => '0');

		wait for clock_period*100;
		input_signal_aux <= std_logic_vector(to_unsigned(645890, input_signal_aux'length));

      wait;
   end process;
	
		-- strobe_signal
		process
			begin
				strobe_in_aux <= '1';
				wait for clock_period;
				strobe_in_aux <= '0';
				--wait for 1*clock_period; -- 100 MHz @ 200 MHz // 50 MHz @ 100 MHz
				wait for 3*clock_period; -- 50 MHz @ 200 MHz // 25 MHz @ 100 MHz
				--wait for 19*clock_period; -- 10 MHz @ 200 MHz // 5 MHz @ 100 MHz
				
				--wait for 199*clock_period; -- 1 MHz @ 200 MHz
				
				
		end process;	
	

 process(clock)
		begin		
   
			if (rising_edge(clock)) then
				if (reset = '1') then		
					input_signal <= (others => '0');	
					strobe_in <= '0';
					--input_signal <= std_logic_vector(to_unsigned(685420, input_signal_aux'length));
					--input_signal_aux <= "00000000000000000000000000000001";
				else
				
					--input_signal_aux(0) <= input_signal_aux(32-1);
					--input_signal_aux(32-1 downto 1) <= input_signal_aux(32-2 downto 0);					
					input_signal <= input_signal_aux;
					
					strobe_in <= strobe_in_aux;
					
				end if;
			end if;
   end process;		

END;
