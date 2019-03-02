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

ENTITY sync_EPOCH_tb IS
END sync_EPOCH_tb;

ARCHITECTURE behavior OF sync_EPOCH_tb IS 
	COMPONENT sync_EPOCH
		GENERIC(WIDTH : integer := 32;
			COMP : integer := 1024);
		PORT(clk : IN  std_logic;
			rst : IN  std_logic;
			data_in : IN  std_logic_vector(31 downto 0);
			data_out : OUT  std_logic_vector(31 downto 0);
			strobe_in : IN  std_logic;
			strobe_out : OUT  std_logic;
			strobe_cont : in std_logic);	
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal strobe_in : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(31 downto 0);
   signal strobe_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: sync_EPOCH 
		GENERIC MAP(WIDTH => 32,
			COMP => 1024)
		PORT MAP(clk => clk,
			rst => rst,
			data_in => data_in,
			data_out => data_out,
			strobe_in => strobe_in,
			strobe_out => strobe_out);

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
			wait for clk_period*10;
			data_in <= (others => '1');
			wait for clk_period;
			data_in <= "00000000000000000000000000000100";
			wait;
   end process;

	strobe_process : process(clk)
		begin
			if (rising_edge(clk)) then
				if rst = '1' then
					strobe_in <= '0';
				else
					strobe_in <= not strobe_in;
				end if;
			end if;
	end process;
END;