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

ENTITY compare_vectors_tb IS
END compare_vectors_tb;

ARCHITECTURE behavior OF compare_vectors_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT compare_vectors
		GENERIC(WIDTH : integer := 64;
				L : integer := 2); 
		PORT(clk : in STD_LOGIC;
				rst : in STD_LOGIC;
				signal_1_in : in STD_LOGIC_VECTOR(63 downto 0);
				signal_2_in : in STD_LOGIC_VECTOR(63 downto 0);
				signal_1_out : out STD_LOGIC_VECTOR(63 downto 0);
				signal_2_out : out STD_LOGIC_VECTOR(63 downto 0);	
				strobe_in : in STD_LOGIC;				
				result : out STD_LOGIC);
    END COMPONENT;
	 
 

   --Inputs
   signal clk : STD_LOGIC := '0';
   signal rst : STD_LOGIC := '1';
	signal signal_1_in : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
   signal signal_2_in : STD_LOGIC_VECTOR(63 downto 0) := (others => '1');
	signal strobe_in : STD_LOGIC;

 	--Outputs
   signal result : STD_LOGIC;
	signal signal_1_out : STD_LOGIC_VECTOR(63 downto 0);
	signal signal_2_out : STD_LOGIC_VECTOR(63 downto 0);

   -- Clock period definitions
	--constant clk_period : time := 1 ns;		--1 GHz
	--constant clk_period : time := 1.25 ns;	--800 MHz
	--constant clk_period : time := 2 ns;		--500 MHz
   --constant clk_period : time := 2.5 ns;	--400 MHz
	constant clk_period : time := 5 ns;
 
	BEGIN

		-- Instantiate the Unit Under Test (UUT)
		uut: compare_vectors
			GENERIC MAP(WIDTH => 64,
				L => 2)
			PORT MAP(clk => clk,
				rst => rst,
				signal_1_in => signal_1_in,
				signal_2_in => signal_2_in,
				signal_1_out => signal_1_out,
				signal_2_out => signal_2_out,
				strobe_in => '1',
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
				wait for clk_period*1000;
				signal_1_in <= "1000100100000000100010010000000010001001000000001000100100000000";
				signal_2_in <= "1000100100000000100010010000000010001001000000001000100100000000";
				wait for clk_period;
				signal_2_in <= (others => '0');
				wait;
		end process;
END;