--------------------------------------------------------------------------------------
-- Ensures a pipelined AND operation of large vectors by nesting smaller ANDs.
--------------------------------------------------------------------------------------
-- **** INPUTS ****
--	WIDTH	->	Input signal width
--	L -> Gate AND size (from 2 to WIDTH)
--	clk -> Clock
-- rst --> Synchronous reset, active high
--	x_in -> Input signal
--
-- **** OUTPUTS  ****
-- result -> Result of the AND operation
-- x_out --> x_in delayed by the latency of the entity
--
-- LATENCY = log(WIDTH)/log(L)
--------------------------------------------------------------------------------------
-- Diary:	29/11/2017	Start
--				29/11/2017	Version 1.0	Dani
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

entity AND_sync is
	GENERIC(WIDTH : integer := 14;
			L : integer := 8);
	PORT(clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			x_in : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
			x_out : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
			result : out STD_LOGIC);
end AND_sync;

architecture Behavioral of AND_sync is

	constant A : integer := integer(ceil(log(real(WIDTH))/log(real(L))));
	constant B : integer := integer(L**A);

	type array_AND is array (0 to A) of STD_LOGIC_VECTOR(B-1 downto 0);
	signal aux : array_AND;

	type array_signal is array (0 to A) of STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	signal signal_delayed : array_signal;

	function function_AND (X : STD_LOGIC_VECTOR(L-1 downto 0)) return STD_LOGIC is
		begin
			for j in 0 to L-1 loop
				if X(j) = '0' then
					return '0';
				end if;
			end loop;
			return '1';
	end function_AND;

	begin

		result <= aux(A)(0);
		x_out <= signal_delayed(A)(WIDTH-1 downto 0);

		process (clk)
			begin
				if (rising_edge(clk)) then
					if (rst = '1') then

						aux(0)(WIDTH-1 downto 0) <= (others => '0');
						aux(0)(B-1 downto WIDTH) <= (others => '1');
						for M in 1 to A loop
							aux(M)(WIDTH-1 downto 0) <= (others => '0');
						end loop;

						signal_delayed <= ((others=>(others=>'0')));
					else
						aux(0)(WIDTH-1 downto 0) <= x_in;
						signal_delayed(0)(WIDTH-1 downto 0) <= x_in;

						for J in 1 to A loop
							for K in 0 to ((L**(A-J))-1) loop
								aux(J)(K) <= function_AND(aux(J-1)((K+1)*L-1 downto K*L));
							end loop;
						end loop;

						for I in 1 to A loop
							signal_delayed(I)(WIDTH-1 downto 0) <= signal_delayed(I-1)(WIDTH-1 downto 0);
						end loop;
					end if;
				end if;
		end process;
end Behavioral;