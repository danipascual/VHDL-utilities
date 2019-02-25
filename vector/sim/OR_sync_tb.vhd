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
 
ENTITY OR_sync_tb IS
END OR_sync_tb;
 
ARCHITECTURE behavior OF OR_sync_tb IS 
    COMPONENT OR_sync
		GENERIC(WIDTH : integer := 14;
				L : integer := 3);		 
		PORT(clk : IN STD_LOGIC;
				rst : IN STD_LOGIC;
				x_in : IN STD_LOGIC_VECTOR(13 downto 0);
				x_out : OUT STD_LOGIC_VECTOR(13 downto 0);
				result : OUT STD_LOGIC);
    END COMPONENT;

   --Inputs
   signal clk : STD_LOGIC := '0';
   signal rst : STD_LOGIC := '1';
   signal x_in : STD_LOGIC_VECTOR(13 downto 0) := (others => '0');

 	--Outputs
   signal x_out : STD_LOGIC_VECTOR(13 downto 0);
   signal result : STD_LOGIC;

   -- Clock period definitions
   constant clk_period : time := 2.5 ns; -- 400 MHz
 
	BEGIN
 
		-- Instantiate the Unit Under Test (UUT)
		uut : OR_sync 
			GENERIC MAP(WIDTH => 14,
				L => 3)		
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
				x_in <= (others => '0');
				wait for clk_period*1;
				x_in <= "10000001010010";
				wait;
		end process;
END;