--------------------------------------------------------------------------------------
-- Average of a 1024 samples vector over 64 realizations without a sliding window. 
-- Samples are 6 bits unsigned. Pipeline is ensured.
--------------------------------------------------------------------------------------
-- Authors: Daniel Pascual (daniel.pascual at protonmail.com) and Jorge Querol 
-- (querol at pm.com)
-- Copyright 2017 Daniel Pascual and Jorge Querol
-- License: GNU GPLv3
--------------------------------------------------------------------------------------
-- Copyright 2017 Daniel Pascual and Jorge Querol
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
use IEEE.std_logic_signed.all; 	-- additions

entity average_16bU_1024_64 is
	PORT (areset : IN STD_LOGIC;
		aclk : IN STD_LOGIC;
		signal_in : IN STD_LOGIC_VECTOR(16-1 DOWNTO 0);
		strobe_in : in  std_logic;
		signal_out : out STD_LOGIC_VECTOR(16-1 DOWNTO 0);		
		strobe_out : out  std_logic);
end average_16bU_1024_64;

architecture Behavioral of average_16bU_1024_64 is

	signal adder_output : std_logic_vector(22-1 downto 0);
	signal signal_adder : std_logic_vector(22-1 downto 0);
	
	signal contador : integer range 0 to 1024*64-1;
	
	signal FIFO_out,FIFO_in : std_logic_vector(22-1 downto 0);
	signal rd_en : std_logic;
	signal strobe_in_d : std_logic;
	
	signal rst_FIFO_aux, rst_FIFO : std_logic;
	
	signal signal_out_aux : std_logic_vector(22-1 downto 0);

	COMPONENT ADDER_16U_22U_22
		PORT (a : IN STD_LOGIC_VECTOR(16-1 DOWNTO 0);
			b : IN STD_LOGIC_VECTOR(22-1 DOWNTO 0);
			clk : IN STD_LOGIC;
			sclr : IN STD_LOGIC;
			s : OUT STD_LOGIC_VECTOR(22-1 DOWNTO 0));
	END COMPONENT;	

	COMPONENT FIFO_22_1024
	PORT (clk : IN STD_LOGIC;
		 srst : IN STD_LOGIC;
		 din : IN STD_LOGIC_VECTOR(22-1 DOWNTO 0);
		 wr_en : IN STD_LOGIC;
		 rd_en : IN STD_LOGIC;
		 dout : OUT STD_LOGIC_VECTOR(22-1 DOWNTO 0);
		 full : OUT STD_LOGIC;
		 almost_full : OUT STD_LOGIC;
		 empty : OUT STD_LOGIC);
	END COMPONENT;	

	begin

		ADDER : ADDER_16U_22U_22
			PORT MAP (a => signal_in,
				b => signal_adder,
				clk => aclk,
				sclr => areset,
				s => adder_output);
				
		FIFO_22_1024_inst : FIFO_22_1024
			PORT MAP (clk => aclk,
				srst => rst_FIFO_aux,
				din => FIFO_in,
				wr_en => strobe_in_d,
				rd_en => rd_en,
				dout => FIFO_out,
				full => open,			
				almost_full => open, 
				empty => open);				
			 
	FIFO_in <= adder_output;
	
	signal_adder <= FIFO_out;
	
	rst_FIFO_aux <= rst_FIFO or areset;
	
	signal_out <= signal_out_aux(22-1 downto 22-1-16+1); -- Divide by 64 (truncate LSB)
				
	process(aclk)
		begin
			if (rising_edge(aclk)) then		
				if (areset = '1') then
					contador <= 0;
							
					strobe_out <= '0';
					
					signal_out_aux <= (others=>'0');
					
					strobe_in_d <= '0';
					
					rst_FIFO <= '0';
					
					rd_en <= '0';
				
				else
				
					strobe_in_d <= strobe_in;
				
					rst_FIFO <= '0';
					rd_en <= '0';
					
					if strobe_in = '1' then
						if contador < 1024*64-1 then
							contador <= contador+1;
						else
							contador <= 0;
							rst_FIFO <= '1';
						end if;
						
						if contador > 1024-2 then
							rd_en <= '1';					
						end if;	

					end if;
					
					if contador > 1024*(64-1) then
						signal_out_aux <= adder_output;
						strobe_out <= strobe_in_d;
					else
						strobe_out <= '0';
						signal_out_aux <= signal_out_aux;
					end if;

				end if; --rst
			end if; --clk
	end process;					
end Behavioral;