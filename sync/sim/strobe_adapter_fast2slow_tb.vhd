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
use IEEE.std_logic_signed.all; 	-- Additions
 
ENTITY strobe_adapter_fast2slow_tb IS
END strobe_adapter_fast2slow_tb;
 
ARCHITECTURE behavior OF strobe_adapter_fast2slow_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT strobe_adapter_fast2slow
		GENERIC(WIDTH : integer := 32;
			RATIO : integer := 5);	 
		 PORT(
				clk : IN  std_logic;
				data : IN  std_logic_vector(31 downto 0);
				strobe_in : IN  std_logic;
				rst : IN  std_logic;
				strobe_out : OUT  std_logic;
				outputa : OUT  std_logic_vector(31 downto 0));
    END COMPONENT;

   --Inputs
   signal clk, clk_2 : std_logic := '0';
   signal data : std_logic_vector(31 downto 0) := (others => '0');
   signal strobe_in : std_logic := '0';
   signal rst : std_logic := '1';

 	--Outputs
   signal strobe_out : std_logic;
   signal outputa : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period_2 : time := 2.5 ns;	-- 400 MHz
	constant clk_period : time := 12.5 ns;	-- 80 MHz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: strobe_adapter_fast2slow 
		Generic map(WIDTH=>32,
			RATIO => 5)
		PORT MAP (
          clk => clk_2,
          data => data,
          strobe_in => strobe_in,
          rst => rst,
          strobe_out => strobe_out,
          outputa => outputa);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
   clk_process_2 :process
   begin
		clk_2 <= '0';
		wait for clk_period_2/2;
		clk_2 <= '1';
		wait for clk_period_2/2;
   end process;	
 
   -- Stimulus process
   stim_proc: process
   begin		
      wait for 100 ns;	
      wait for clk_period_2*10;
		rst <= '0';
      wait;
   end process;
	
	-- strobe_in 20 MHz @ 400 MHz
	process
		begin
			wait for clk_period_2/2;
			strobe_in <= '0';
			wait for 19*clk_period_2; 
			strobe_in <= '1';
			wait for clk_period_2/2;
	end process;	
END;