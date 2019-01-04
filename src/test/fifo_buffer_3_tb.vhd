LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;
 
ENTITY fifo_buffer_3_tb IS
END fifo_buffer_3_tb;
 
ARCHITECTURE behavior OF fifo_buffer_3_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fifo_buffer_3
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         ENABLE : IN  std_logic;
         DIN : IN  std_logic_vector(UBIT downto 0);
         DOUT : OUT  std_logic_vector(7 downto 0);
         DA : OUT  std_logic_vector(7 downto 0);
         DB : OUT  std_logic_vector(7 downto 0);
         DC : OUT  std_logic_vector(7 downto 0);
         READY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal ENABLE : std_logic := '0';
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal DOUT : std_logic_vector(7 downto 0);
   signal DA : std_logic_vector(7 downto 0);
   signal DB : std_logic_vector(7 downto 0);
   signal DC : std_logic_vector(7 downto 0);
   signal READY : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fifo_buffer_3 PORT MAP (
          CLK => CLK,
          RESET => RESET,
          ENABLE => ENABLE,
          DIN => DIN,
          DOUT => DOUT,
          DA => DA,
          DB => DB,
          DC => DC,
          READY => READY
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
