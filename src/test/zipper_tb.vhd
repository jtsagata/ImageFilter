LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;
 
ENTITY zipper_tb IS
END zipper_tb;
 
ARCHITECTURE behavior OF zipper_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT zipper
    PORT(
        Enable : IN STD_LOGIC;
        CLK :    IN STD_LOGIC;
		DIVIDER : IN std_logic_vector(1 DOWNTO 0);
        INPUT  : IN  signed(MRESULT DOWNTO 0);
        OUTPUT : OUT std_logic_vector(UBIT DOWNTO 0) --;
        );
    END COMPONENT;
    

   --Inputs
   signal Enable : std_logic := '0';
   signal CLK : std_logic := '0';
   signal INPUT : signed(MRESULT DOWNTO 0) := (others => '0');
   signal DIVIDER : std_logic_vector(1 DOWNTO 0);

    --Outputs
   signal OUTPUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   signal CLOCK_EN: std_logic;

BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: zipper PORT MAP (
          Enable => Enable,
          CLK => CLK,
		  DIVIDER => DIVIDER,
          INPUT => INPUT,
          OUTPUT => OUTPUT
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
	  DIVIDER <= "00";
      wait for 100 ns;
      
      -- Start simulation
      CLOCK_EN <= '1';

      -- Let's change the input value
      wait until rising_edge(clk);
      INPUT  <= to_signed(1024, MRESULT+1); 
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT OUTPUT = std_logic_vector(to_unsigned(255,UBIT+1)) REPORT "ABS(1024)" SEVERITY error;
	  
      -- Let's change the input value
      wait until rising_edge(clk);
      INPUT  <= to_signed(255, MRESULT+1); 
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT OUTPUT = std_logic_vector(to_unsigned(255,UBIT+1)) REPORT "ABS(255)" SEVERITY error;

	  -- Lets go to DIVIDER/unknown mode
	  DIVIDER <= "11";

      -- Let's change the input value
      wait until rising_edge(clk);
      INPUT  <= to_signed(128, MRESULT+1); 
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT OUTPUT = std_logic_vector(to_unsigned(128,UBIT+1)) REPORT "ABS(128)" SEVERITY error;

      -- Let's change the input value
      wait until rising_edge(clk);
      INPUT  <= to_signed(0, MRESULT+1); 
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT OUTPUT = std_logic_vector(to_unsigned(0,UBIT+1)) REPORT "ABS(0)" SEVERITY error;

      -- Let's change the input value
      wait until rising_edge(clk);
      INPUT  <= -to_signed(128, MRESULT+1); 
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT OUTPUT = std_logic_vector(to_unsigned(0,UBIT+1)) REPORT "ABS(-128)" SEVERITY error;


	  -- Lets go to DIVIDER/16 mode
	  DIVIDER <= "01";
	  
	  -- Let's change the input value
      wait until rising_edge(clk);
      INPUT  <= to_signed(128, MRESULT+1); 
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT OUTPUT = std_logic_vector(to_unsigned(8,UBIT+1)) REPORT "128/16=8" SEVERITY error;

	  -- Lets go to DIVIDER/8 mode
	  DIVIDER <= "10";
	  
	  -- Let's change the input value
      wait until rising_edge(clk);
      INPUT  <= to_signed(128, MRESULT+1); 
      wait until rising_edge(clk);
      wait for CLK_period/4;
      ASSERT OUTPUT = std_logic_vector(to_unsigned(16,UBIT+1)) REPORT "128/8=16" SEVERITY error;

      wait;
   end process;

END;
