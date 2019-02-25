--------------------------------------------------------------------------------------
-- Compares if two vectors are equal. Pipelined is ensured by proper setting the size
-- of the AND_sync entity.
--------------------------------------------------------------------------------------
-- **** INPUTS ****
--	WIDTH	->	Input signal width
--	L -> Gate size (from 2 to WIDTH)
--	clk -> Clock
-- rst -> Synchronous reset, active high
--	signal_1_in, signal_2_in -> Input signals
--
-- **** OUTPUTS  ****
-- result -> '1' if equal
-- signal_1_out, signal_2_out -> Input signals delayed by the latency of the entity
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

entity compare_vectors is
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
end compare_vectors;

architecture Behavioral of compare_vectors is

	constant A : integer := integer(ceil(log(real(WIDTH))/log(real(L))))+1;

	signal signal_nXOR : STD_LOGIC_VECTOR(WIDTH-1 downto 0);

	type array_signal is array (0 to A) of STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	signal signal_1_delayed, signal_2_delayed : array_signal;
	
	signal strobe_delayed : std_logic_vector(A downto 0);

	COMPONENT AND_sync
		GENERIC(WIDTH : integer := 14;
				L : integer := 3);
		PORT(clk : in STD_LOGIC;
				rst : in STD_LOGIC;
				x_in : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
				x_out : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
				result : out STD_LOGIC);
	END COMPONENT;

	begin

		AND_sync_inst : AND_sync
			GENERIC MAP(WIDTH => WIDTH,
				L => L)
			PORT MAP(clk => clk,
				rst => rst,
				x_in => signal_nXOR,
				x_out => open,
				result => result);

		signal_1_out <= signal_1_delayed(A)(WIDTH-1 downto 0);
		signal_2_out <= signal_2_delayed(A)(WIDTH-1 downto 0);
		strobe_out <= strobe_delayed(A);

		process (clk)
			begin
				if (rising_edge(clk)) then
					if (rst = '1') then
						signal_nXOR <= (others => '0');
						signal_1_delayed <= ((others=>(others=>'0')));
						signal_2_delayed <= ((others=>(others=>'0')));
						
						strobe_delayed <= (others => '0');
					else
						signal_nXOR <= not(signal_1_in xor signal_2_in);
						
						signal_1_delayed(0)(WIDTH-1 downto 0) <= signal_1_in;
						signal_2_delayed(0)(WIDTH-1 downto 0) <= signal_2_in;
						strobe_delayed(0) <= strobe_in;
						for I in 1 to A loop
							signal_1_delayed(I)(WIDTH-1 downto 0) <= signal_1_delayed(I-1)(WIDTH-1 downto 0);
							signal_2_delayed(I)(WIDTH-1 downto 0) <= signal_2_delayed(I-1)(WIDTH-1 downto 0);
							strobe_delayed(I) <= strobe_delayed(I-1);
						end loop;
					end if;
				end if;
		end process;
end Behavioral;