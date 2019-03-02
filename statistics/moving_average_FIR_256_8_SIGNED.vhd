--------------------------------------------------------------------------------------
-- Moving average 
--------------------------------------------------------------------------------------
-- Diary:	29/11/2017	Start
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

entity moving_average_FIR_256_8_SIGNED is
	Generic(WIDTH : integer := 8);
	PORT (areset : IN STD_LOGIC;
		aclk : IN STD_LOGIC;
		signal_in : IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
		strobe_in : in  std_logic;
		signal_out : out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
		strobe_out : out  std_logic);
end moving_average_FIR_256_8_SIGNED;

architecture Behavioral of moving_average_FIR_256_8_SIGNED is

	signal aresetn : std_logic;
	--signal m_axis_data_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0);	-- full precision
	signal m_axis_data_tdata : STD_LOGIC_VECTOR(7 DOWNTO 0);	-- rounding
	signal s_axis_data_tdata : STD_LOGIC_VECTOR(7 DOWNTO 0);

	COMPONENT FIR_256_8_SIGNED
		PORT (aresetn : IN STD_LOGIC;
			aclk : IN STD_LOGIC;
			s_axis_data_tvalid : IN STD_LOGIC;
			s_axis_data_tready : OUT STD_LOGIC;
			s_axis_data_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			m_axis_data_tvalid : OUT STD_LOGIC;
			--m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- full precisio
			m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- rounding
	END COMPONENT;

	begin

		aresetn <= not areset;

		FIR_256_8_SIGNED_inst : FIR_256_8_SIGNED	 -- See VHDL-utilities\matlab\moving_average.m
			PORT MAP (aresetn => aresetn,
				aclk => aclk,
				s_axis_data_tvalid => strobe_in,
				s_axis_data_tready => open,
				s_axis_data_tdata => s_axis_data_tdata,
				m_axis_data_tvalid => strobe_out,
				m_axis_data_tdata => m_axis_data_tdata);
		  
		s_axis_data_tdata <= signal_in;
		--signal_out <= m_axis_data_tdata(31 downto 31-WIDTH+1);	-- full precision (truncate LSB)
		signal_out <= m_axis_data_tdata;	-- rounding

end Behavioral;