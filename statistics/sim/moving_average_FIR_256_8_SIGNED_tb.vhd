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
 
ENTITY moving_average_FIR_256_8_SIGNED_tb IS
END moving_average_FIR_256_8_SIGNED_tb;
 
ARCHITECTURE behavior OF moving_average_FIR_256_8_SIGNED_tb IS 
 
    COMPONENT moving_average_FIR_256_8_SIGNED
    PORT(
         areset : IN  std_logic;
         aclk : IN  std_logic;
         signal_in : IN  std_logic_vector(7 downto 0);
         strobe_in : IN  std_logic;
--         signal_out : OUT  std_logic_vector(31 downto 0);
			signal_out : OUT  std_logic_vector(7 downto 0);
         strobe_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal areset : std_logic := '1';
   signal aclk : std_logic := '0';
--   signal signal_in : std_logic_vector(7 downto 0) := (others => '0');
   --signal signal_in : std_logic_vector(7 downto 0) := "00000001";
	signal signal_in : std_logic_vector(7 downto 0) := "01111111";
   signal strobe_in : std_logic := '1';

 	--Outputs
--   signal signal_out : std_logic_vector(31 downto 0);
	signal signal_out : std_logic_vector(7 downto 0);
   signal strobe_out : std_logic;

   -- Clock period definitions
   constant aclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: moving_average_FIR_256_8_SIGNED PORT MAP (
          areset => areset,
          aclk => aclk,
          signal_in => signal_in,
          strobe_in => strobe_in,
          signal_out => signal_out,
          strobe_out => strobe_out
        );

   -- Clock process definitions
   aclk_process :process
   begin
		aclk <= '0';
		wait for aclk_period/2;
		aclk <= '1';
		wait for aclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		areset <= '0';
      
--		wait for aclk_period*1;
--		signal_in <= "00010001"; --17
--		
--		wait for aclk_period*1;
--		signal_in <= "00001100"; --12
--		
--		wait for aclk_period*1;
--		signal_in <= "00001111"; --15		
--		
--		wait for aclk_period*1;
--		signal_in <= "00011011"; --27
--		
--		wait for aclk_period*1;
--		signal_in <= "00000011"; --3
--		
--		wait for aclk_period*1;
--		signal_in <= "00001000"; --8
--		
--		wait for aclk_period*1;
--		signal_in <= "00000110"; --6		
		
		

      -- insert stimulus here 

      wait;
   end process;

END;
