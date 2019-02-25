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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY agc_complex_16_tb IS
END agc_complex_16_tb;
 
ARCHITECTURE behavior OF agc_complex_16_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	constant L : integer := 16;
 
    COMPONENT agc_complex_16
		PORT(rst : IN  std_logic;
			clk : IN  std_logic;
         signal_out : OUT  std_logic_vector(15 downto 0);
         signal_in : IN  std_logic_vector(31 downto 0);
         strobe_out : OUT  std_logic;
         strobe_in : IN  std_logic;
         MSB : in integer range 0 to L-1);
    END COMPONENT;

   --Inputs
   signal rst : std_logic := '1';
   signal clk : std_logic := '0';
	signal strobe_in : std_logic := '0';
--	signal signal_in : std_logic_vector(31 downto 0) := "0000010000110110" & "0001011010010010"; signal MSB : integer range 0 to L-1 := 12;
--	signal signal_in : std_logic_vector(31 downto 0) := "0000000000110110" & "0000000000010010"; signal MSB : integer range 0 to L-1 := 5;
	signal signal_in : std_logic_vector(31 downto 0) := "0000000010110110" & "0000000000010010"; signal MSB : integer range 0 to L-1 := 7;
--	signal signal_in : std_logic_vector(31 downto 0) := "1010000000110110" & "1000010000010010"; signal MSB : integer range 0 to L-1 := 15;
   
   

 	--Outputs
   signal signal_out : std_logic_vector(15 downto 0);
   signal strobe_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: agc_complex_16 PORT MAP (
          rst => rst,
          clk => clk,
          signal_out => signal_out,
          signal_in => signal_in,
          strobe_out => strobe_out,
          strobe_in => '1',
          MSB => MSB
        );

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

      -- insert stimulus here 

      wait;
   end process;

END;
