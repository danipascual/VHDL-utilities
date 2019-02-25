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
use ieee.numeric_std.all; 			-- to_signed, etc
use IEEE.math_real.all; 			-- maths

entity agc_complex_16 is
	Generic(W : integer := 8);
	PORT(rst : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		signal_out : out std_logic_vector(2*W-1 downto 0);
		signal_in : in std_logic_vector(31 downto 0);	-- 16*2
		strobe_out : out std_logic;
		strobe_in : in std_logic;
		MSB : in integer range 0 to 16-1);
end agc_complex_16;

architecture Behavioral of agc_complex_16 is

	constant L : integer := 16;
	signal m_axis_dout_tdata_1, m_axis_dout_tdata_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal aresetn : std_logic;
	signal divisor :  STD_LOGIC_VECTOR(L-1 DOWNTO 0);
	signal signal_in_d : std_logic_vector(31 downto 0);
	signal strobe_in_d : std_logic;

	component pow_decoder is
		Generic(L : integer := 12;
			W : integer := 8);
	  PORT(rst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 signal_out : out std_logic_vector(L-1 downto 0);
		 MSB : in integer range 0 to L-1);
	end component;
	
	COMPONENT DIVIDER_UNSIGNED_16_RESETN
		PORT (aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_divisor_tvalid : IN STD_LOGIC;
			s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			s_axis_dividend_tvalid : IN STD_LOGIC;
			s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			m_axis_dout_tvalid : OUT STD_LOGIC;
			m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;	

	begin
		aresetn <= not rst;
	
		pow_decoder_inst : pow_decoder
			Generic map(L => L,
				W => 8)
		  PORT map(rst => rst,
			 clk => clk,
			 signal_out => divisor,
			 MSB =>  MSB);
			 
		DIVIDOR_REAL : DIVIDER_UNSIGNED_16_RESETN
			PORT MAP (aclk => clk,
				aresetn => aresetn,
				s_axis_divisor_tvalid => strobe_in_d,
				s_axis_divisor_tdata => divisor,
				s_axis_dividend_tvalid => strobe_in_d,
				s_axis_dividend_tdata => signal_in_d(15 downto 0),
				m_axis_dout_tvalid => strobe_out,
				m_axis_dout_tdata => m_axis_dout_tdata_1);	
				
		DIVIDOR_IMAG : DIVIDER_UNSIGNED_16_RESETN
			PORT MAP (aclk => clk,
				aresetn => aresetn,
				s_axis_divisor_tvalid => '1',
				s_axis_divisor_tdata => divisor,
				s_axis_dividend_tvalid => strobe_in_d,
				s_axis_dividend_tdata => signal_in_d(31 downto 16),
				m_axis_dout_tvalid => open,
				m_axis_dout_tdata => m_axis_dout_tdata_2);					
				
	signal_out(W-1 downto 0) <= m_axis_dout_tdata_1(16+W-1 downto 16);
	signal_out(2*W-1 downto W) <= m_axis_dout_tdata_2(16+W-1 downto 16);

	process(clk)
		begin
			if (rising_edge(clk)) then		
				if (rst = '1') then
					signal_in_d <= (others => '0');
					strobe_in_d <= '0';
				else
					signal_in_d <= signal_in;
					strobe_in_d <= strobe_in;
				end if; --rst
			end if; --clk
	end process;					
end Behavioral;