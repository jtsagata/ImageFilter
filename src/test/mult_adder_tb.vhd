LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;
 
 
ENTITY mult_adder_tb IS
END mult_adder_tb;
 
ARCHITECTURE behavior OF mult_adder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mult_adder
    PORT(
        S1 : IN std_logic_vector(UBIT DOWNTO 0);
        S2 : IN std_logic_vector(UBIT DOWNTO 0);
        S3 : IN std_logic_vector(UBIT DOWNTO 0);
        S4 : IN std_logic_vector(UBIT DOWNTO 0);
        S5 : IN std_logic_vector(UBIT DOWNTO 0);
        S6 : IN std_logic_vector(UBIT DOWNTO 0);
        S7 : IN std_logic_vector(UBIT DOWNTO 0);
        S8 : IN std_logic_vector(UBIT DOWNTO 0);
        S9 : IN std_logic_vector(UBIT DOWNTO 0);

        M1 : IN signed (MSIZE DOWNTO 0);
        M2 : IN signed (MSIZE DOWNTO 0);
        M3 : IN signed (MSIZE DOWNTO 0);
        M4 : IN signed (MSIZE DOWNTO 0);
        M5 : IN signed (MSIZE DOWNTO 0);
        M6 : IN signed (MSIZE DOWNTO 0);
        M7 : IN signed (MSIZE DOWNTO 0);
        M8 : IN signed (MSIZE DOWNTO 0);
        M9 : IN signed (MSIZE DOWNTO 0);

        sum : OUT signed (MRESULT DOWNTO 0);
         Enable : IN  std_logic;
         CLK : IN  std_logic;
         Ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal S1 : std_logic_vector(UBIT downto 0) := ( others => '0');
   signal S2 : std_logic_vector(UBIT downto 0) := ( others => '0');
   signal S3 : std_logic_vector(UBIT downto 0) := ( others => '0');
   signal S4 : std_logic_vector(UBIT downto 0) := ( others => '0');
   signal S5 : std_logic_vector(UBIT downto 0) := ( others => '0');
   signal S6 : std_logic_vector(UBIT downto 0) := ( others => '0');
   signal S7 : std_logic_vector(UBIT downto 0) := ( others => '0');
   signal S8 : std_logic_vector(UBIT downto 0) := ( others => '0');
   signal S9 : std_logic_vector(UBIT downto 0) := ( others => '0');
   
   signal M1 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal M2 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal M3 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal M4 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal M5 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal M6 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal M7 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal M8 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal M9 : signed (MSIZE DOWNTO 0) := to_signed(1, MSIZE+1);
   signal Enable : std_logic := '0';
   signal CLK : std_logic := '0';

    --Outputs
   signal sum : signed (MRESULT DOWNTO 0);
   signal Ready : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   signal CLOCK_EN: std_logic;
   
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: mult_adder PORT MAP (
          S1 => S1,
          S2 => S2,
          S3 => S3,
          S4 => S4,
          S5 => S5,
          S6 => S6,
          S7 => S7,
          S8 => S8,
          S9 => S9,
          M1 => M1,
          M2 => M2,
          M3 => M3,
          M4 => M4,
          M5 => M5,
          M6 => M6,
          M7 => M7,
          M8 => M8,
          M9 => M9,
          sum => sum,
          Enable => Enable,
          CLK => CLK,
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
      wait for 100 ns;
      
      -- Start simulation
      CLOCK_EN <= '1';
      
      -- Let's change a pixel
      wait until rising_edge(clk);
      S1 <= ( 0=>'1', others => '0');

      -- Let's change one more pixel
      wait until rising_edge(clk);
      S2 <= ( 0=>'1', others => '0');

      -- Let's change 3nd pixel
      wait until rising_edge(clk);
      S3 <= ( 0=>'1', others => '0');

      -- Reset state
      wait until rising_edge(clk);
      S1 <= ( others => '0');
      S2 <= ( others => '0');
      S3 <= ( others => '0');

      -- We feed 2 pixels more and a reset
      wait for CLK_period*(WAIT_MULT_ADDER - 3);
      wait for CLK_period/4;
      ASSERT SUM = to_signed(1, SUM'length) REPORT "In Correct Sum step 1" SEVERITY error;  
        
      -- Test 2nd pixel change
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT SUM = to_signed(2, SUM'length) REPORT "In Correct Sum step 2" SEVERITY error;  
        
      -- Test 3nd pixel change
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT SUM = to_signed(3, SUM'length) REPORT "In Correct Sum step 3" SEVERITY error;  

      -- Test after reste
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT SUM = to_signed(0, SUM'length) REPORT "In Correct Sum after reset" SEVERITY error; 

      wait;
   end process;

END;
