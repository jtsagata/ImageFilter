LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

-- require for std_logic etc.
-- https://vhdlguide.readthedocs.io/en/latest/vhdl/testbench.html 
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL; 
 
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
         DOUT : OUT  std_logic_vector(UBIT downto 0);
         DA : OUT  std_logic_vector(UBIT downto 0);
         DB : OUT  std_logic_vector(UBIT downto 0);
         DC : OUT  std_logic_vector(UBIT downto 0);
         READY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal ENABLE : std_logic := '0';
   signal DIN : std_logic_vector(UBIT downto 0) := (others => '1');

    --Outputs
   signal DOUT : std_logic_vector(UBIT downto 0);
   signal DA : std_logic_vector(UBIT downto 0);
   signal DB : std_logic_vector(UBIT downto 0);
   signal DC : std_logic_vector(UBIT downto 0);
   signal READY : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   signal CLOCK_EN: std_logic;

    -- FILES
    file debug_file : text;  -- text is keyword
    
    -- COUNT SIGNAL
    signal COUNT : unsigned(UBIT downto 0) := (0=>'1', others => '0');
    
BEGIN
    -- Process
    -- CLK_process     (Handle clock)
    -- start_circuit   (Handle RESET)
    -- print_header    (Print the header once)
    -- counter_process ( Do the counting)  ON (CLK,RESET)
    -- debug_write     ( Print debug line) ON (CLK)
 
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

   -- save data in file : path is relative to Modelsim-project directory
   file_open(debug_file, "src/sims/fifo_3.txt", write_mode);

--  -- Wire RESET
--  RESET <= reset_signal;

   -- Clock process definitions
   CLK_process :process
   begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= CLOCK_EN;
        wait for CLK_period/2;
   end process;
 

   -- start_circuit process
   start_circuit: process
   begin        
    -- configure and enable
    -- hold reset state for 100 ns.
    RESET <= '1';
        wait for CLK_period*10;      
        RESET <= '0';
        ENABLE <= '1';
        CLOCK_EN <= '1';
        
        -- Test RESET circuit
        wait for CLK_period*17;
        RESET <= '1';
        wait for CLK_period;
        RESET <= '0';

        -- Test EARLY RESET circuit
        wait for CLK_period*2;
        RESET <= '1';
        wait for CLK_period;
        RESET <= '0';
        
    -- indefinitely suspend process
        wait;  
   end process;
   
   
   -- print header process
   print_header: process
   variable OLine : line;
   begin        
        -- Print file header
        write(OLine, string'("DIN"));
        write(OLine, ht);write(OLine, string'("|"));
        write(OLine, string'("  DOUT"));
        write(OLine, ht);write(OLine, string'("|"));
        write(OLine, ht);write(OLine, string'("DC"));
        write(OLine, ht);write(OLine, string'("DB"));
        write(OLine, ht);write(OLine, string'("DA"));
        write(OLine, ht);write(OLine, string'("|"));
        write(OLine, ht);write(OLine, string'("RDY"));
        writeline(debug_file, OLine);
        
    -- indefinitely suspend process
        wait;  
   end process;
   
   
    --
    -- Send sequential data to the buffer
    --
    counter_process: process(CLK,RESET)
    variable OLine : line;
    variable delay_print : std_logic := '0';
    begin
        -- There is a sensitivity list, no waits here
        if(CLK'event and CLK='1' and ENABLE ='1') then
            DIN <= std_logic_vector(COUNT);
            COUNT <= COUNT + 1;
            IF ( RESET ='1' ) THEN
                COUNT <= (0=>'1', others => '0');
                delay_print := '1';
            END IF;
            IF (delay_print = '1') AND (CLOCK_EN='1') THEN
                write(OLine, string'("[RESET event]"));
                writeline(debug_file, OLine);
                delay_print := '0';
            END IF;
        end if;
    end process;
    
    --
    -- Debug file write process
    --
    debug_write: process(CLK)
        variable OLine : line;
    begin
        if(CLK'event and CLK='1' and ENABLE ='1') then
            write(OLine, to_integer(unsigned(DIN)));
            write(OLine, ht); write(OLine, string'("|"));
            write(OLine, ht); write(OLine, to_integer(unsigned(DIN)));
            write(OLine, ht); write(OLine, string'("|"));
            write(OLine, ht); write(OLine, to_integer(unsigned(DC)));
            write(OLine, ht); write(OLine, to_integer(unsigned(DB)));
            write(OLine, ht); write(OLine, to_integer(unsigned(DA)));
            write(OLine, ht); write(OLine, string'("|"));
            write(OLine, ht); write(OLine, READY);
            -- And now write the line to file
            writeline(debug_file, OLine);
        end if;
    end process;

END;
