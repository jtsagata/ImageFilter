LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;
  
ENTITY filter_bank_chooser_tb IS
END filter_bank_chooser_tb;
 
ARCHITECTURE behavior OF filter_bank_chooser_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT filter_bank_choser
    PORT(
        SW_A : IN  std_logic;
        SW_B : IN  std_logic;
		SW_C : IN  std_logic;
        M1 : OUT signed(MSIZE DOWNTO 0);
        M2 : OUT signed(MSIZE DOWNTO 0);
        M3 : OUT signed(MSIZE DOWNTO 0);
        M4 : OUT signed(MSIZE DOWNTO 0);
        M5 : OUT signed(MSIZE DOWNTO 0);
        M6 : OUT signed(MSIZE DOWNTO 0);
        M7 : OUT signed(MSIZE DOWNTO 0);
        M8 : OUT signed(MSIZE DOWNTO 0);
        M9 : OUT signed(MSIZE DOWNTO 0);
        DIVIDER : OUT signed(MSIZE DOWNTO 0)--;
        );
    END COMPONENT;
    

   --Inputs
   signal SW_A : std_logic := '0';
   signal SW_B : std_logic := '0';
   signal SW_C : std_logic := '0';

    --Outputs
   signal M1 : signed(MSIZE DOWNTO 0);
   signal M2 : signed(MSIZE DOWNTO 0);
   signal M3 : signed(MSIZE DOWNTO 0);
   signal M4 : signed(MSIZE DOWNTO 0);
   signal M5 : signed(MSIZE DOWNTO 0);
   signal M6 : signed(MSIZE DOWNTO 0);
   signal M7 : signed(MSIZE DOWNTO 0);
   signal M8 : signed(MSIZE DOWNTO 0);
   signal M9 : signed(MSIZE DOWNTO 0);
   signal DIVIDER : signed(MSIZE DOWNTO 0);
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: filter_bank_choser PORT MAP (
          SW_A => SW_A,
          SW_B => SW_B,
		  SW_C => SW_C,
          M1 => M1,
          M2 => M2,
          M3 => M3,
          M4 => M4,
          M5 => M5,
          M6 => M6,
          M7 => M7,
          M8 => M8,
          M9 => M9,
          DIVIDER => DIVIDER
        );

 
   -- Stimulus process
   stim_proc: process
   begin        
      -- There is no clock no worries!
      wait for clock_period*10;
      SW_A <= '0';
      SW_B <= '0';
	  SW_C <= '0';

      wait for clock_period*10;
      SW_A <= '0';
      SW_B <= '0';
	  SW_C <= '1';

      wait for clock_period*10;
      SW_A <= '0';
      SW_B <= '1';
	  SW_C <= '0';

      wait for clock_period*10;
      SW_A <= '1';
      SW_B <= '0';
	  SW_C <= '0';
        
    
      wait;
   end process;

END;
