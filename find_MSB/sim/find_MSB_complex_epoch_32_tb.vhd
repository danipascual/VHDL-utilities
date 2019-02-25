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
use IEEE.std_logic_signed.all;	-- Addtions
 
ENTITY find_MSB_complex_epoch_32_tb IS
END find_MSB_complex_epoch_32_tb;
 
ARCHITECTURE behavior OF find_MSB_complex_epoch_32_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT find_MSB_complex_epoch_32
    PORT(
         input_signal_1 : IN  std_logic_vector(31 downto 0);
         input_signal_2 : IN  std_logic_vector(31 downto 0);
         output_signal : OUT  std_logic_vector(4 downto 0);
         enable_in : IN  std_logic;
         valid_out : OUT  std_logic;
         clock : IN  std_logic;
         reset : IN  std_logic;
         strobe_in : IN  std_logic;
         strobe_out : OUT  std_logic); 			
    END COMPONENT;
	 

   --Inputs
   signal input_signal_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal input_signal_2 : std_logic_vector(31 downto 0) := (others => '0');
   signal enable_in : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal strobe_in : std_logic := '0';
	
   signal areset_aux : std_logic := '1';
   signal strobe_in_aux : std_logic := '0';		

 	--Outputs
   signal output_signal : std_logic_vector(4 downto 0);
   signal valid_out : std_logic;
   signal strobe_out : std_logic;
	signal position_max : std_logic_vector(14-1 downto 0);
	signal strobe_tmp : std_logic;

   -- Clock period definitions
   --constant clock_period : time := 10 ns;
	constant clock_period : time := 2.5 ns;
	
--	constant N : integer := 50;		--  MHz
--	constant N : integer := 20;		--  MHz
	constant N : integer := 25;		--  MHz
	--constant X : integer := integer(real(100)/real(N))-1;
	constant X : integer := integer(real(400)/real(N))-1;
	signal strobe_boc : std_logic;		
	
	signal contador : integer range 0 to 16384-1 := 0;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: find_MSB_complex_epoch_32 PORT MAP (
          input_signal_1 => input_signal_1,
          input_signal_2 => input_signal_2,
          output_signal => output_signal,
          enable_in => '1',
          valid_out => open,
          clock => clock,
          reset => reset,
          strobe_in => strobe_in,
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
		areset_aux <= '0';

      wait;
   end process;
	
	-- Create strobe BOC signal
	process
		begin
			strobe_boc <= '1';
			wait for clock_period;
			strobe_boc <= '0';
			wait for X*clock_period;
	end process;	

	process (clock)
		begin
			if (rising_edge(clock)) then
				if areset_aux = '1' then
					reset <= '1';
					strobe_in <= '0';
--					input_signal_1 <= "00000000000000000000001111111111";
--					input_signal_2 <= "00000000000000000000000010000000";
					input_signal_2 <= (others => '0');
					input_signal_1 <= (others => '0');
--					input_signal_1 <= "00000000000000000000000000000001";
					contador <= 16384-1;
				else
					
					reset <= '0';
					strobe_in <= strobe_boc;
					
					if strobe_boc = '1' then
					
						if contador < 16384-1 then
							contador <= contador+1;
						else
							contador <= 0;
						end if;
						
						if contador = 7999 then
							input_signal_1 <= "00000000000000000000001111111111";
						else
							input_signal_1 <= (others => '0');
						end if;
						
--					
--					
--						if input_signal_1 < 4096 then
----						if input_signal_1 < 2 then
--					
--							input_signal_1 <= input_signal_1+1;
--						else
--							input_signal_1 <= "00000000000000000000000000000001";
--						end if;
--						
----						if input_signal_2 < 4096 then
----					
----							input_signal_2 <= input_signal_2+1;
----						else
----							input_signal_2 <= "00000000000000000000000010000000";
----						end if;						
					end if;
				end if;
			end if;
	end process;		
END;