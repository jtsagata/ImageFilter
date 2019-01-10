LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.all;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;
USE work.constants.ALL;
 
ENTITY filter_controller_tb IS
END filter_controller_tb;
 
ARCHITECTURE behavior OF filter_controller_tb IS 
 
	--
	-- Calculations
	-- A small image is better for inspection
	--
	CONSTANT IMAGE_WIDTH :       INTEGER := 10;
	--CONSTANT IMAGE_WIDTH :       INTEGER := 20;
	CONSTANT IMAGE_HEIGHT :      INTEGER := 12;
	CONSTANT IMAGE_LAST_VALUE :  INTEGER := IMAGE_WIDTH * IMAGE_HEIGHT;
 
    --
	-- Component Declaration for the Unit Under Test (UUT)
	--
    COMPONENT filter_controller
    PORT(
         CLK : IN  std_logic;
         ENABLE : IN  std_logic;
         RESET : IN  std_logic;
         I_WIDTH : IN  std_logic_vector(7 downto 0);
         I_HEIGH : IN  std_logic_vector(7 downto 0);
         THRESHSIZE : OUT  std_logic_vector(8 downto 0);
         DIN : IN  std_logic_vector(7 downto 0);
         DOUT : OUT  std_logic_vector(7 downto 0);
         READY : OUT  std_logic;
         DONE : OUT  std_logic;
         F2_START : OUT  std_logic;
         FN_END : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal ENABLE : std_logic := '0';
   signal RESET : std_logic := '0';
   signal I_WIDTH : std_logic_vector(7 downto 0) := (others => '0');
   signal I_HEIGH : std_logic_vector(7 downto 0) := (others => '0');
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal THRESHSIZE : std_logic_vector(8 downto 0);
   signal DOUT : std_logic_vector(7 downto 0);
   signal READY : std_logic;
   signal DONE : std_logic;
   signal F2_START : std_logic;
   signal FN_END : std_logic;

	-- Clock period definitions
	CONSTANT CLK_period : TIME := 10 ns;
	SIGNAL CLOCK_EN : std_logic;
 
	-- FILES
	FILE debug_file : text;
 
BEGIN

	-- Process
	-- CLK_process     (Handle clock)
	-- start_circuit   (Handle RESET)
	-- print_header    (Print the header once)
	-- counter_process (Do the counting) ON (CLK,RESET)
	-- debug_write     (Print debug line) ON (CLK) 
 
	-- save data in file : path is relative to Modelsim-project directory
	file_open(debug_file, "src/sims/filter_controller.txt", write_mode);

   -- Instantiate the Unit Under Test (UUT)
   uut: filter_controller PORT MAP (
          CLK => CLK,
          ENABLE => ENABLE,
          RESET => RESET,
          I_WIDTH => I_WIDTH,
          I_HEIGH => I_HEIGH,
          THRESHSIZE => THRESHSIZE,
          DIN => DIN,
          DOUT => DOUT,
          READY => READY,
          DONE => DONE,
          F2_START => F2_START,
          FN_END => FN_END
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

	--
	-- start_circuit process
	--
	start_circuit : PROCESS
	BEGIN
		-- CONFIGURE
		I_HEIGH <= std_logic_vector(to_unsigned(IMAGE_HEIGHT, UBIT+1));
		I_WIDTH <= std_logic_vector(to_unsigned(IMAGE_WIDTH, UBIT+1));
		-- hold reset state for 100 ns.
		RESET <= '1';
		
		-- ENABLE
		WAIT FOR CLK_period * 10;
		RESET <= '0';
		ENABLE <= '1';
		CLOCK_EN <= '1';

		-- Test RESET circuit
		wait for CLK_period*30;
		RESET <= '1';
		wait for CLK_period;
		RESET <= '0';

		--indefinitely suspend process
		WAIT; 
	END PROCESS;

	--
	-- Send sequential data to the buffer
	--
	counter_process : PROCESS (CLK, RESET)
	  VARIABLE OLine : line;
	  VARIABLE delay_print : std_logic := '0';
	  -- We use a larger counter than the UBIT DIN
	  -- And get the last bits
	  VARIABLE count_unsigned : unsigned(PRG_FULL_CONST + 1 downto 0) := (0=>'0', others => '0');
	  VARIABLE count_vector :   std_logic_vector(PRG_FULL_CONST + 1 downto 0); 
	  BEGIN

		-- Handle debug print of reset event
		IF (RESET = '1') THEN
		  delay_print := '1';
		  count_unsigned := (others => '0');
		END IF;

		IF (delay_print = '1') AND (CLOCK_EN='1') THEN
		  write(OLine, STRING'("[RESET event]"));
		  writeline(debug_file, OLine);
		  delay_print := '0';
		END IF;
		
		-- There is a sensitivity list, no waits here
		IF (ENABLE = '1') THEN
		  IF rising_edge(CLK) THEN
			  -- Trim the counter
			  count_vector := std_logic_vector(count_unsigned);
			  DIN <= count_vector(UBIT downto 0);
			  count_unsigned := count_unsigned +1;

			  -- Trimed counter or zero
			  IF (to_integer(count_unsigned) > IMAGE_LAST_VALUE) THEN
				DIN <= (others => '0');
			  ELSE
				DIN <= count_vector(UBIT downto 0);
			  END IF;
		  END IF;
		END IF;
	  END PROCESS;


	--
	-- print header process
	--
	print_header : PROCESS
	VARIABLE OLine : line;
	BEGIN
		write(OLine, STRING'("IMAGE_WIDTH: ")); write(OLine, IMAGE_WIDTH); writeline(debug_file, OLine);
		write(OLine, STRING'("IMAGE_HEIGHT: ")); write(OLine, IMAGE_HEIGHT); writeline(debug_file, OLine);
		writeline(debug_file, OLine);
		-- Print an empty line
		writeline(debug_file, OLine);
		write(OLine, STRING'("DIN"));
		write(OLine, ht); write(OLine, STRING'("|"));
		write(OLine, STRING'("  DOUT  "));
		write(OLine, STRING'("|"));
		write(OLine, STRING'(" R ")); 
		write(OLine, STRING'("|"));
		write(OLine, STRING'(" 2 ")); 
		write(OLine, STRING'(" | "));
		write(OLine, STRING'("N")); 
		write(OLine, STRING'(" | "));
		write(OLine, STRING'("D")); 
		writeline(debug_file, OLine);

		-- indefinitely suspend process
		WAIT; 
	END PROCESS;

	--
	-- Debug file write process
	--
	debug_write : PROCESS (CLK)
	VARIABLE OLine : line;
	BEGIN
	  IF (CLK'EVENT AND CLK = '1' AND ENABLE = '1') THEN
		write(OLine, to_integer(unsigned(DIN)));write(OLine, ht);
		write(OLine, STRING'("|"));write(OLine, ht); 
		write(OLine, to_integer(unsigned(DOUT)));write(OLine, ht); 
		write(OLine, STRING'(" | "));
		write(OLine, READY);  
		write(OLine, STRING'(" | "));
		write(OLine, F2_START); 
		write(OLine, STRING'(" | "));
		write(OLine, FN_END);
		write(OLine, STRING'(" | "));		
		write(OLine, DONE);
		IF (READY = '1') OR (F2_START = '1') OR (FN_END = '1') OR (DONE = '1')  THEN
			write(OLine, STRING'(" <=="));
		END IF;
		-- And now write the line to file
		writeline(debug_file, OLine);
	  END IF;
	END PROCESS;

END;
