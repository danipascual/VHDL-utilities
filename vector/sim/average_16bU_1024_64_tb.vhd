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
use IEEE.std_logic_signed.all;	-- Addtions
 

ENTITY average_16bU_1024_64_tb IS
END average_16bU_1024_64_tb;
 
ARCHITECTURE behavior OF average_16bU_1024_64_tb IS 
 
    COMPONENT average_16bU_1024_64
		PORT(areset : IN  std_logic;
         aclk : IN  std_logic;
         signal_in : IN  std_logic_vector(16-1 downto 0);
         strobe_in : IN  std_logic;
         --signal_out : OUT  std_logic_vector(79-1 downto 0);
			signal_out : OUT  std_logic_vector(16-1 downto 0);
         strobe_out : OUT  std_logic);
    END COMPONENT;
    
   --Inputs
   signal areset : std_logic := '1';
   signal aclk : std_logic;
   --signal signal_in, signal_in_aux : std_logic_vector(16-1 downto 0) := (others => '0');
	signal signal_in : std_logic_vector(16-1 downto 0) := "0000000000000000";
   signal strobe_in : std_logic := '0';
	
   signal areset_aux : std_logic := '1';
   signal strobe_in_aux : std_logic := '0';	

 	--Outputs
   --signal signal_out : std_logic_vector(79-1 downto 0);
	signal signal_out : std_logic_vector(16-1 downto 0);
   signal strobe_out : std_logic;

   -- Clock period definitions
   constant aclk_period : time := 10 ns;	-- 100 MHz
	
	signal cont : integer range 0 to 1024-1 := 0;
	
	--constant N : integer := 50;
	constant N : integer := 20;
	constant X : integer := integer(real(100)/real(N))-1;
	signal strobe_boc : std_logic;
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: average_16bU_1024_64 
		PORT MAP (areset => areset,
			aclk => aclk,
			signal_in => signal_in,
         strobe_in => strobe_in,
         signal_out => signal_out,
         strobe_out => strobe_out);

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

      wait for aclk_period*10;
		areset_aux <= '0';
		--strobe_in_aux <= '1';

      -- insert stimulus here 

      wait;
   end process;
	
	-- Create strobe BOC signal
	process
		begin
			strobe_boc <= '1';
			wait for aclk_period;
			strobe_boc <= '0';
			wait for X*aclk_period;
	end process;		
	
	process (aclk)
		begin
			if (rising_edge(aclk)) then
				if areset_aux = '1' then
					areset <= '1';
					strobe_in <= '0';
					signal_in <= (others => '0');
--					signal_in_aux <= (others => '0');
					cont <= 0;
				else
					
					areset <= '0';
					strobe_in <= strobe_boc;
					--signal_in <= signal_in_aux;
					
					if strobe_boc = '1' then
					
						if cont <1024-1 then
							cont <= cont+1;					
						else
							cont <= 0;				
						end if;
						
--						if cont = 832 then
--							signal_in <= "0000000000100000";
--						else
--							signal_in <= (others => '0');
--						end if;					
					
					end if;
					
					signal_in <= "0000000000000001";
					--signal_in <= "1111111111111111";

				end if;
			end if;
	end process;	
END;