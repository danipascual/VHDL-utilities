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
 
ENTITY AND_sync_tb IS
END AND_sync_tb;
 
ARCHITECTURE behavior OF AND_sync_tb IS 
    COMPONENT AND_sync
		GENERIC(WIDTH : integer := 14;
					L : integer := 8);		 
		PORT(clk : IN  std_logic;
				rst : IN  std_logic;
				x_in : IN  std_logic_vector(13 downto 0);
				x_out : OUT  std_logic_vector(13 downto 0);
				result : OUT  std_logic);
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal x_in : std_logic_vector(13 downto 0) := (others => '0');

 	--Outputs
   signal x_out : std_logic_vector(13 downto 0);
   signal result : std_logic;

   -- Clock period definitions
   constant clk_period : time := 2.5 ns; -- 400 MHz
 
	BEGIN
 
		-- Instantiate the Unit Under Test (UUT)
		uut : AND_sync 
			GENERIC MAP(WIDTH => 14,
				L => 8)
			PORT MAP(clk => clk,
				rst => rst,
				x_in => x_in,
				x_out => x_out,
				result => result);

		-- Clock process definitions
		clk_process :process
			begin
				clk <= '0';
				wait for clk_period/2;
				clk <= '1';
				wait for clk_period/2;
		end process;
	 
		-- Stimulus process
		stim_proc: process
			begin		
				-- hold reset state for 100 ns.
				wait for 100 ns;	
				wait for clk_period*10;
				rst <= '0';
				wait for clk_period*100;
				x_in <= "00010000000010";
				wait for clk_period*1;		-- Check if clock speed is to high for this configuation
				x_in <= (others => '1');
				wait for clk_period*1;
				x_in <= "10000001010010";
				wait;
		end process;
END;