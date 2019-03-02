--------------------------------------------------------------------------------------
-- To be finished.
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

entity perncentile50_4_64 is
end perncentile50_4_64;

architecture Behavioral of perncentile50_4_64 is

	component cdf_4_64
		PORT(clk : in STD_LOGIC;
				rst : in STD_LOGIC;
				input_signal : in std_logic_vector(4-1 downto 0);
				strobe_in : in std_logic;
				strobe_out : out std_logic);			
	end component;
	
	COMPONENT compare_vectors
		GENERIC(WIDTH : integer := 6;
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


end Behavioral;

