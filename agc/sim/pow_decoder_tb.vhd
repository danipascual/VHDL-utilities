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
 
ENTITY pow_decoder_tb IS
END pow_decoder_tb;
 
ARCHITECTURE behavior OF pow_decoder_tb IS 
 
	constant L : integer := 12;
	constant W : integer := 8;
 
	COMPONENT pow_decoder
		Generic(L : integer := 12;
			W : integer := 8);
		PORT(rst : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			signal_out : out std_logic_vector(L-1 downto 0);
			MSB : in integer range 0 to L-1);
	END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal clk : std_logic := '0';
   signal MSB : integer range 0 to L-1 := 0;

 	--Outputs
   signal signal_out : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pow_decoder 
		Generic map (L => L,
			W => W)
		PORT MAP (rst => rst,
			clk => clk,
			signal_out => signal_out,
			MSB => MSB);

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
		rst <= '0';

      wait for clk_period;
		MSB <= MSB+1;
		
      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;	

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;

      wait for clk_period;
		MSB <= MSB+1;		
		

      -- insert stimulus here 

      wait;
   end process;

END;
