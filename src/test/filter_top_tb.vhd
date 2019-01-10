LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

-- require for std_logic etc.
-- https://vhdlguide.readthedocs.io/en/latest/vhdl/testbench.html
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY filter_top_tb IS
END filter_top_tb;
 
ARCHITECTURE behavior OF filter_top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT filter_top is
        Port ( 
        CLK :    IN  STD_LOGIC;
        ENABLE : IN  STD_LOGIC;
        RESET :  IN std_logic;
        I_WIDTH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        I_HEIGH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        SW_A : IN STD_LOGIC;
        SW_B : IN STD_LOGIC;
		SW_C : IN STD_LOGIC;
        DIN  : IN  STD_LOGIC_VECTOR (UBIT downto 0);
        -- PIXEL OUT
        DOUT : OUT  STD_LOGIC_VECTOR (UBIT downto 0);
        -- Control Signals
        READY    : OUT  STD_LOGIC;
        DONE     : OUT  STD_LOGIC;
        F2_START : OUT  STD_LOGIC;
        FN_END   : OUT  STD_LOGIC--;
        );
    end COMPONENT;

   --Inputs
   signal CLK : std_logic := '0';
   signal ENABLE : std_logic := '0';
   signal RESET : std_logic := '0';
   signal I_WIDTH : std_logic_vector(UBIT downto 0) := (others => '0');
   signal I_HEIGH : std_logic_vector(UBIT downto 0) := (others => '0');
   signal SW_A : std_logic := '0';
   signal SW_B : std_logic := '0';
   signal SW_C : std_logic := '0';
   signal DIN : std_logic_vector(UBIT downto 0) := (others => '0');

    --Outputs
   signal DOUT : std_logic_vector(UBIT downto 0);
   signal READY : std_logic;
   signal DONE : std_logic;   
   signal F2_START : std_logic;
   signal FN_END : std_logic;

    -- FOR DEBUG
    signal COUNTER : std_logic_vector(PRG_FULL_CONST DOWNTO 0);
    --

    -- Clock period definitions
    CONSTANT CLK_period : TIME := 10 ns;
    SIGNAL CLOCK_EN : std_logic;

    -- FILES
    FILE debug_file : text; -- text is keyword

    -- Calculations
    -- A small image is better for inspection
    CONSTANT IMAGE_WIDTH :       INTEGER := 10;
    --CONSTANT IMAGE_WIDTH :       INTEGER := 20;
    CONSTANT IMAGE_HEIGHT :      INTEGER := 12;
    CONSTANT IMAGE_LAST_VALUE :  INTEGER := IMAGE_WIDTH * IMAGE_HEIGHT;

  -- Process
  -- CLK_process     (Handle clock)
  -- start_circuit   (Handle RESET)
  -- print_header    (Print the header once)
  -- counter_process (Do the counting) ON (CLK,RESET)
  -- debug_write     (Print debug line) ON (CLK) 
BEGIN
     -- save data in file : path is relative to Modelsim-project directory
    file_open(debug_file, "src/sims/filter_top_count.txt", write_mode);

    -- Instantiate the Unit Under Test (UUT)
   uut: filter_top PORT MAP (
          CLK      => CLK,
          ENABLE   => ENABLE,
          RESET    => RESET,
          I_WIDTH  => I_WIDTH,
          I_HEIGH  => I_HEIGH,
          SW_A     => SW_A,
          SW_B     => SW_B,
		  SW_C     => SW_C,
          -- PIXEL IN/OUT
		  DIN      => DIN,
          DOUT     => DOUT,
          -- Control Signals
          READY    => READY,
          DONE     => DONE,
          F2_START => F2_START,
          FN_END   => FN_END--;
        );

    -- Clock process definitions
    CLK_process : PROCESS
    BEGIN
        CLK <= '0';
        WAIT FOR CLK_period/2;
        CLK <= CLOCK_EN;
        WAIT FOR CLK_period/2;
    END PROCESS;
 

    -- start_circuit process
    start_circuit : PROCESS
    BEGIN
        -- configure and enable
        -- Set the BUFFER_SIZE
        I_HEIGH <= std_logic_vector(to_unsigned(IMAGE_HEIGHT, UBIT+1));
        I_WIDTH <= std_logic_vector(to_unsigned(IMAGE_WIDTH, UBIT+1));      
        -- Select identity filter
        SW_A <= '0';
        SW_B <= '0';
		SW_C <= '0';
        -- hold reset state for 100 ns.
        RESET <= '1';
        WAIT FOR CLK_period * 10;

        RESET <= '0';
        ENABLE <= '1';
        CLOCK_EN <= '1';

        -- TODO: There is a problem in reset circuit		
--        -- Test RESET circuit
--        wait for CLK_period*40;
--        RESET <= '1';
--        wait for CLK_period;
--        RESET <= '0';

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
    IF (RESET = '1') AND (CLOCK_EN = '1') THEN
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
        writeline(debug_file, OLine);
      END IF;
    END PROCESS;
    
END;
