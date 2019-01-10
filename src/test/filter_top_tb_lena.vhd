LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

-- require for std_logic etc.
-- https://vhdlguide.readthedocs.io/en/latest/vhdl/testbench.html
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY filter_top_tb_lena IS
END filter_top_tb_lena;
 
ARCHITECTURE behavior OF filter_top_tb_lena IS 
 
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
    FILE debug_file : text;
	FILE lena_in : text;
	FILE lena_out : text;

    -- Lena
    -- A small image is better for inspection
    CONSTANT IMAGE_WIDTH :       INTEGER := 128;
    CONSTANT IMAGE_HEIGHT :      INTEGER := 128;

BEGIN
     -- save data in file : path is relative to Modelsim-project directory
    file_open(debug_file, "src/sims/filter_top_lena.txt", write_mode);
	file_open(lena_in, "lena/Lena128x128g_8bits.dat", read_mode);
	file_open(lena_out, "src/sims/Lena128x128g_8bits_filter1.dat", write_mode);

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
		SW_C <= '1';
        -- hold reset state for 100 ns.
        RESET <= '1';
        WAIT FOR CLK_period * 10;

        RESET <= '0';
        ENABLE <= '1';
        CLOCK_EN <= '1';
        --indefinitely suspend process
        WAIT; 
    END PROCESS;


--
-- Send sequential data to the buffer
--
  read_lena_process : PROCESS (CLK, RESET)
  variable Iline : line;
  variable I1_var :std_logic_vector (7 downto 0);
  BEGIN


    -- There is a sensitivity list, no waits here
    IF (ENABLE = '1') THEN
      IF rising_edge(CLK) THEN
	  readline (lena_in,Iline);
	  read (Iline,I1_var);  
      DIN <= I1_var;
      END IF;
    END IF;
  END PROCESS;
    
    --
    -- Lena file write process
    --
    write_lena : PROCESS (CLK)
    VARIABLE OLine : line;
    BEGIN
      IF (CLK'EVENT AND CLK = '1' AND ENABLE = '1') THEN
		write (OLine, DOUT, right, 8);
		writeline (lena_out, Oline);
      END IF;
    END PROCESS;

    
END;
