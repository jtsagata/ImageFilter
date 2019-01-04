LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY signed_adder_tb IS
END signed_adder_tb;
 
ARCHITECTURE behavior OF signed_adder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT signed_adder
    PORT(
		P1 : IN signed (MRESULT DOWNTO 0);
		P2 : IN signed (MRESULT DOWNTO 0);
		P3 : IN signed (MRESULT DOWNTO 0);
		P4 : IN signed (MRESULT DOWNTO 0);
		P5 : IN signed (MRESULT DOWNTO 0);
		P6 : IN signed (MRESULT DOWNTO 0);
		P7 : IN signed (MRESULT DOWNTO 0);
		P8 : IN signed (MRESULT DOWNTO 0);
		P9 : IN signed (MRESULT DOWNTO 0);
		sum : OUT signed (MRESULT DOWNTO 0);
         Enable : IN  std_logic;
         CLK : IN  std_logic;
         Ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal P1 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal P2 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal P3 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal P4 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal P5 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal P6 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal P7 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal P8 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal P9 : signed (MRESULT DOWNTO 0) := (others => '0');
   signal Enable : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal sum: signed (MRESULT DOWNTO 0);
   signal Ready : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   signal CLOCK_EN: std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: signed_adder PORT MAP (
          P1 => P1,
          P2 => P2,
          P3 => P3,
          P4 => P4,
          P5 => P5,
          P6 => P6,
          P7 => P7,
          P8 => P8,
          P9 => P9,
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
	  wait until rising_edge(clk);

      -- insert stimulus here 
	  P1 <=  -to_signed(4, P1'length);
	  P2 <=  to_signed(4, P1'length);
	  P3 <=  to_signed(3, P1'length);
	  P4 <=  -to_signed(2, P1'length);
	  
	  -- Keep feeding numbers
	  wait until rising_edge(clk);
	  P5 <=  to_signed(1, P1'length);
	  
	  wait until rising_edge(clk);
	  P6 <=  -to_signed(1, P1'length);
	  
	  wait for CLK_period*(WAIT_ADDER-2);
	  wait for CLK_period/4;
	  ASSERT SUM = to_signed(1, P1'length) REPORT "In Correct Sum" SEVERITY error;
	  
	  -- The result flow is constant
	  wait until rising_edge(clk);
	  -- Need some extra time
	  wait for CLK_period/4; 
	  ASSERT SUM = to_signed(2, P1'length) REPORT "In Correct Sum" SEVERITY error;

	  wait until rising_edge(clk);
	  wait for CLK_period/4;
	  ASSERT SUM = to_signed(1, P1'length) REPORT "In Correct Sum" SEVERITY error;
      
	  wait;
   end process;

END;
