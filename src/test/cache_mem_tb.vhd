LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

-- require for std_logic etc.
-- https://vhdlguide.readthedocs.io/en/latest/vhdl/testbench.html
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY cache_mem_tb IS
END cache_mem_tb;

ARCHITECTURE behavior OF cache_mem_tb IS

-- Calculations
-- A small image is better for inspection
CONSTANT IMAGE_WIDTH :       INTEGER := 10;
--CONSTANT IMAGE_WIDTH :       INTEGER := 20;
CONSTANT IMAGE_HEIGHT :      INTEGER := 12;
CONSTANT IMAGE_LAST_VALUE :  INTEGER := IMAGE_WIDTH * IMAGE_HEIGHT;

-- Constant size
CONSTANT BUFFER_SIZE : unsigned(PRG_FULL_CONST DOWNTO 0) := to_unsigned(IMAGE_WIDTH - 2 * 3, PRG_FULL_CONST + 1);

-- Component Declaration for the Unit Under Test (UUT)
COMPONENT cache_mem
PORT (
  CLK : IN std_logic;
  ENABLE : IN std_logic;
  RESET : IN std_logic;
  DIN : IN std_logic_vector(UBIT DOWNTO 0);
  prog_full_thresh : IN std_logic_vector(PRG_FULL_CONST DOWNTO 0);
  P1 : OUT std_logic_vector(UBIT DOWNTO 0);
  P2 : OUT std_logic_vector(UBIT DOWNTO 0);
  P3 : OUT std_logic_vector(UBIT DOWNTO 0);
  P4 : OUT std_logic_vector(UBIT DOWNTO 0);
  P5 : OUT std_logic_vector(UBIT DOWNTO 0);
  P6 : OUT std_logic_vector(UBIT DOWNTO 0);
  P7 : OUT std_logic_vector(UBIT DOWNTO 0);
  P8 : OUT std_logic_vector(UBIT DOWNTO 0);
  P9 : OUT std_logic_vector(UBIT DOWNTO 0);
  READY : OUT std_logic
  );
END COMPONENT;


--Inputs
SIGNAL CLK : std_logic := '0';
SIGNAL ENABLE : std_logic := '0';
SIGNAL RESET : std_logic := '0';
SIGNAL DIN : std_logic_vector(UBIT DOWNTO 0) := (OTHERS => '0');
SIGNAL prog_full_thresh : std_logic_vector(PRG_FULL_CONST DOWNTO 0) := std_logic_vector(BUFFER_SIZE);

--Outputs
SIGNAL P1 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL P2 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL P3 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL P4 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL P5 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL P6 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL P7 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL P8 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL P9 : std_logic_vector(UBIT DOWNTO 0);
SIGNAL READY : std_logic;

-- Clock period definitions
CONSTANT CLK_period : TIME := 10 ns;
SIGNAL CLOCK_EN : std_logic;

-- FILES
FILE debug_file : text; -- text is keyword

BEGIN
  -- Process
  -- CLK_process     (Handle clock)
  -- start_circuit   (Handle RESET)
  -- print_header    (Print the header once)
  -- counter_process (Do the counting) ON (CLK,RESET)
  -- debug_write     (Print debug line) ON (CLK)

  -- Instantiate the Unit Under Test (UUT)
  uut : cache_mem
  PORT MAP(
    CLK => CLK, 
    ENABLE => ENABLE, 
    RESET => RESET, 
    DIN => DIN, 
    prog_full_thresh => std_logic_vector(BUFFER_SIZE), 
    P1 => P1, 
    P2 => P2, 
    P3 => P3, 
    P4 => P4, 
    P5 => P5, 
    P6 => P6, 
    P7 => P7, 
    P8 => P8, 
    P9 => P9, 
    READY => READY
    );

-- save data in file : path is relative to Modelsim-project directory
file_open(debug_file, "src/sims/cache_mem.txt", write_mode);

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
    -- hold reset state for 100 ns.
    RESET <= '1';
    WAIT FOR CLK_period * 10;
    -- Set the BUFFER_SIZE
    prog_full_thresh <= std_logic_vector(BUFFER_SIZE); 
    RESET <= '0';
    ENABLE <= '1';
    CLOCK_EN <= '1';

    -- Test RESET circuit
    wait for CLK_period*17;
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

    IF (delay_print = '1') THEN
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
    -- Print size info
    write(OLine, STRING'("IMAGE_WIDTH: ")); write(OLine, IMAGE_WIDTH); writeline(debug_file, OLine);
    write(OLine, STRING'("IMAGE_HEIGHT: ")); write(OLine, IMAGE_HEIGHT); writeline(debug_file, OLine);
    write(OLine, STRING'("BUFFER_SIZE: ")); write(OLine, to_integer(unsigned(BUFFER_SIZE))); 
    writeline(debug_file, OLine);
    -- Print an empty line
    writeline(debug_file, OLine);
    write(OLine, STRING'("DIN"));
    write(OLine, ht); write(OLine, STRING'("|"));
    write(OLine, ht); write(OLine, STRING'("P1"));
    write(OLine, ht); write(OLine, STRING'("P2"));
    write(OLine, ht); write(OLine, STRING'("P3"));
    write(OLine, ht); write(OLine, STRING'("P4"));
    write(OLine, ht); write(OLine, STRING'("P5"));
    write(OLine, ht); write(OLine, STRING'("P6"));
    write(OLine, ht); write(OLine, STRING'("P7"));
    write(OLine, ht); write(OLine, STRING'("P8"));
    write(OLine, ht); write(OLine, STRING'("P9"));
    write(OLine, ht); write(OLine, STRING'("READY"));
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
    write(OLine, to_integer(unsigned(P1)));write(OLine, ht); 
    write(OLine, to_integer(unsigned(P2)));write(OLine, ht); 
    write(OLine, to_integer(unsigned(P3)));write(OLine, ht); 
    write(OLine, to_integer(unsigned(P4)));write(OLine, ht); 
    write(OLine, to_integer(unsigned(P5)));write(OLine, ht); 
    write(OLine, to_integer(unsigned(P6)));write(OLine, ht); 
    write(OLine, to_integer(unsigned(P7)));write(OLine, ht); 
    write(OLine, to_integer(unsigned(P8)));write(OLine, ht); 
    write(OLine, to_integer(unsigned(P9)));write(OLine, ht); 
    write(OLine, string'(" | ")); write(OLine, ht); 
    write(OLine, READY);
    -- And now write the line to file
    writeline(debug_file, OLine);
  END IF;
END PROCESS;

END;