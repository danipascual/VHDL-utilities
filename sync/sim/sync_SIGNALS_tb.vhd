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
 
ENTITY sync_SIGNALS_tb IS
END sync_SIGNALS_tb;
 
ARCHITECTURE behavior OF sync_SIGNALS_tb IS 
 
	COMPONENT sync_SIGNALS
		PORT(clk : IN  std_logic;
			rst : IN  std_logic;
         data_in_1 : IN  std_logic_vector(31 downto 0);
         data_in_2 : IN  std_logic_vector(31 downto 0);
         data_out_1 : OUT  std_logic_vector(31 downto 0);
         data_out_2 : OUT  std_logic_vector(31 downto 0);
         strobe_in_1 : IN  std_logic;
         strobe_in_2 : IN  std_logic;
         strobe_out : OUT  std_logic);
    END COMPONENT;
    
	--Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal data_in_1 : std_logic_vector(31 downto 0) := "10101101111100011111000010101010";
   signal data_in_2 : std_logic_vector(31 downto 0) := "00000000001010011001110101101000";
   signal strobe_in_1 : std_logic := '0';
   signal strobe_in_2 : std_logic := '0';

 	--Outputs
   signal data_out_1 : std_logic_vector(31 downto 0);
   signal data_out_2 : std_logic_vector(31 downto 0);
   signal strobe_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 5 ns;
	
	signal strobe_1 : std_logic;
 
BEGIN
 
   uut: sync_SIGNALS 
		PORT MAP (clk => clk,
		 rst => rst,
		 data_in_1 => data_in_1,
		 data_in_2 => data_in_2,
		 data_out_1 => data_out_1,
		 data_out_2 => data_out_2,
		 strobe_in_1 => strobe_in_1,
		 strobe_in_2 => strobe_in_2,
		 strobe_out => strobe_out);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	process
		begin
			strobe_1 <= '1';
			wait for clk_period;
			strobe_1 <= '0';
			wait for 12*clk_period;
		end process;
 
   -- Stimulus process
   stim_proc: process
		begin		
			-- hold reset state for 100 ns.
			wait for 100 ns;	
			rst <= '0';

			wait for clk_period*10;

			wait;
   end process;
	
	process (clk)
		begin
			if (rising_edge(clk)) then
				if rst = '1' then
					strobe_in_1 <= '0';
					strobe_in_2 <= '0';
				else
					
					strobe_in_1 <= strobe_1;
					strobe_in_2 <= strobe_in_1;
					
					if strobe_1 = '1' then
						data_in_1 <= data_in_1+1;
					end if;
					
					if strobe_in_1 = '1' then
						data_in_2 <= data_in_2+1;
					end if;				
				
				end if;
			end if;
	end process;
END;