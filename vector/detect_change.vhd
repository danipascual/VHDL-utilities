--------------------------------------------------------------------------------------
-- Detects a change on a vector. Pipelined is ensured by proper setting the size of the
-- compare_vectors entity.
--------------------------------------------------------------------------------------
-- **** INPUTS ****
--	WIDTH	->	Input signal width
--	L -> Gate size (from 2 to WIDTH)
--	clk -> Clock
-- rst --> Synchronous reset, active high
--	signal_in, signal_2_in -> Input signal
--
-- **** OUTPUTS  ****
-- changed -> Indicate change of signal
-- signal_out --> Input signal delayed by the latency of the entity
--
-- LATENCY = log(WIDTH)/log(L)+1
--------------------------------------------------------------------------------------
-- Diary:	29/11/2017	Start
--				29/11/2017	Version 1.0	Dani
--				02/03/2018	Added strobe_in (data rate slower than clock)
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;			-- maths

entity detect_change is
	GENERIC(WIDTH : integer := 14;
			L : integer := 3);
	PORT(clk : in STD_LOGIC;
			rst	: in STD_LOGIC;
			signal_in	: in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
			signal_out : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
			changed : out STD_LOGIC;
			strobe_in : in STD_LOGIC;
			strobe_out : out STD_LOGIC);
end detect_change;

architecture Behavioral of detect_change is

	signal signal_1, signal_2  : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	signal result : STD_LOGIC;
	signal strobe_in_aux : std_logic;

	COMPONENT compare_vectors
		GENERIC(WIDTH : integer := 14;
				L : integer := 3);
		PORT(clk : in STD_LOGIC;
				rst	: in STD_LOGIC;
				signal_1_in	: in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
				signal_2_in : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
				signal_1_out : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
				signal_2_out : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
				result : out STD_LOGIC;
				strobe_in : in STD_LOGIC;
				strobe_out : out STD_LOGIC);
	END COMPONENT;

	begin

		compare_vectors_inst : compare_vectors
			GENERIC MAP(WIDTH => WIDTH,
				L => L)
			PORT MAP(clk => clk,
				rst => rst,
				signal_1_in => signal_1,
				signal_2_in => signal_2,
				signal_1_out => signal_out,
				signal_2_out => open,
				result => result,
				strobe_in => strobe_in_aux,
				strobe_out => strobe_out);

		changed <= not result;

		process (clk)
			begin
				if (rising_edge(clk)) then
					if (rst = '1') then
						signal_1 <= (others => '0');
						signal_2 <= (others => '0');
						strobe_in_aux <= '0';
					else
						strobe_in_aux <= strobe_in;
						if strobe_in = '1' then
							signal_1 <= signal_in;
							signal_2 <= signal_1;
						end if;
					end if;
				end if;
		end process;
end Behavioral;