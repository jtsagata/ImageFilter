LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;
 
ENTITY filter_bank_tb IS
END filter_bank_tb;
 
ARCHITECTURE behavior OF filter_bank_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT filter_bank
    PORT(
         P1 : IN  std_logic_vector(7 downto 0);
         P2 : IN  std_logic_vector(7 downto 0);
         P3 : IN  std_logic_vector(7 downto 0);
         P4 : IN  std_logic_vector(7 downto 0);
         P5 : IN  std_logic_vector(7 downto 0);
         P6 : IN  std_logic_vector(7 downto 0);
         P7 : IN  std_logic_vector(7 downto 0);
         P8 : IN  std_logic_vector(7 downto 0);
         P9 : IN  std_logic_vector(7 downto 0);
         SW_A : IN  std_logic;
         SW_B : IN  std_logic;
         Enable : IN  std_logic;
         CLK : IN  std_logic;
		 
         sum : OUT std_logic_vector(UBIT DOWNTO 0);
         Ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal P1 : std_logic_vector(7 downto 0) := (others => '0');
   signal P2 : std_logic_vector(7 downto 0) := (others => '0');
   signal P3 : std_logic_vector(7 downto 0) := (others => '0');
   signal P4 : std_logic_vector(7 downto 0) := (others => '0');
   signal P5 : std_logic_vector(7 downto 0) := (others => '0');
   signal P6 : std_logic_vector(7 downto 0) := (others => '0');
   signal P7 : std_logic_vector(7 downto 0) := (others => '0');
   signal P8 : std_logic_vector(7 downto 0) := (others => '0');
   signal P9 : std_logic_vector(7 downto 0) := (others => '0');
   signal SW_A : std_logic := '0';
   signal SW_B : std_logic := '0';
   signal Enable : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal sum : std_logic_vector(UBIT DOWNTO 0);
   signal Ready : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   signal CLOCK_EN: std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: filter_bank PORT MAP (
          P1 => P1,
          P2 => P2,
          P3 => P3,
          P4 => P4,
          P5 => P5,
          P6 => P6,
          P7 => P7,
          P8 => P8,
          P9 => P9,
          SW_A => SW_A,
          SW_B => SW_B,
          Enable => Enable,
          CLK => CLK,
          sum => sum,
          Ready => Ready
        );

   -- Clock process definitions
   CLK_process :process

   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= CLOCK_EN;
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
	  ENABLE <= '1';
	  -- Select identity filter
	  SW_A <= '0';
	  SW_B <= '0';
	  wait for 100 ns;
	  
	  -- Start simulation
	  CLOCK_EN <= '1';	

	  -- Let's change a pixel
	  wait until rising_edge(clk);
	  P5 <= ( 0=>'1', others => '0');

	  -- Let's change it again to 2
	  wait until rising_edge(clk);
	  P5 <= ( 1=>'1', 0=>'0', others => '0');

	  -- Let's change it again to 3
	  wait until rising_edge(clk);
	  P5 <= ( 1=>'1', 0=>'1', others => '0');

	  -- Let's reset
	  wait until rising_edge(clk);
	  P5 <= (  others => '0');

	  -- We feed 2 pixels more and a reset
	  wait for CLK_period*(WAIT_MULT_ADDER -3);
	  wait for CLK_period/4;
	  ASSERT SUM = std_logic_vector(to_unsigned(1, SUM'length)) 
	  REPORT "In Correct Sum step 1" SEVERITY error;	

	  -- Test 2nd pixel change
	  wait until rising_edge(clk);
	  wait for CLK_period/4;
	  ASSERT SUM = std_logic_vector(to_unsigned(2, SUM'length)) 
	  REPORT "In Correct Sum step 2" SEVERITY error;	
	
	  -- Test 3nd pixel change
	  wait until rising_edge(clk);
	  wait for CLK_period/4;
	  ASSERT SUM = std_logic_vector(to_unsigned(3, SUM'length)) 
	  REPORT "In Correct Sum step 2" SEVERITY error;	

	  -- Test after reset input
	  wait until rising_edge(clk);
	  wait for CLK_period/4;
	  ASSERT SUM = std_logic_vector(to_unsigned(0, SUM'length)) 
	  REPORT "In Correct Sum step 2" SEVERITY error;	


      wait;
   end process;

END;
