LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY detect_change_tb IS
END detect_change_tb;
 
ARCHITECTURE behavior OF detect_change_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT detect_change
		GENERIC(WIDTH : integer := 14;
				L : integer := 3);	 
		 PORT(clk : IN  std_logic;
				rst : IN  std_logic;
				signal_in : IN  std_logic_vector(13 downto 0);
				signal_out : OUT  std_logic_vector(13 downto 0);
				changed : out STD_LOGIC;
				strobe_in : in STD_LOGIC;
				strobe_out : out STD_LOGIC);	 
    END COMPONENT;
	 
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal signal_in : std_logic_vector(13 downto 0) := (others => '0');
	signal strobe_in : STD_LOGIC;

 	--Outputs
   signal signal_out : std_logic_vector(13 downto 0);
   signal changed : std_logic;
	signal strobe_out : STD_LOGIC;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
	BEGIN
	 
		-- Instantiate the Unit Under Test (UUT)
		uut: detect_change
			GENERIC MAP(WIDTH => 14,
				L => 3)		
			PORT MAP(clk => clk,
				 rst => rst,
				 signal_in => signal_in,
				 signal_out => signal_out,
				 changed => changed,
				 strobe_in => '1',
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
				signal_in <= "01010000000000";
				wait for clk_period*5;
				signal_in <= "01010000000001";
				wait for clk_period;
				signal_in <= "00000000000000";
				wait;
		end process;
END;