LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
USE work.constants.ALL;

entity filter_controller is
    Port ( 
        CLK :    IN  STD_LOGIC;
        ENABLE : IN  STD_LOGIC;
        RESET :  IN std_logic;
        -- Image Dimensions
        I_WIDTH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        I_HEIGH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        THRESHSIZE : OUT std_logic_vector(PRG_FULL_CONST DOWNTO 0);
        -- Data in/out
        DIN      : IN  STD_LOGIC_VECTOR (UBIT downto 0);        
        DOUT     : OUT  STD_LOGIC_VECTOR (UBIT downto 0);
        -- Control Signals
        READY    : OUT  STD_LOGIC;
        DONE     : OUT  STD_LOGIC;
        F2_START : OUT  STD_LOGIC;
        FN_END   : OUT  STD_LOGIC--;
    );
END filter_controller;

architecture fc_impl of filter_controller is
SIGNAL count        : std_logic_vector(PRG_FULL_CONST downto 0);
SIGNAL F2S_COUNT    : std_logic_vector(UBIT16 downto 0);
SIGNAL FN_END_COUNT : std_logic_vector(UBIT16 downto 0);
SIGNAL DONE_COUNT   : std_logic_vector(UBIT16 downto 0);
BEGIN

        
    -- 
    -- Calculate THRESHSIZE (Asynchromus)
    --
    THRESHSIZE_CALC : PROCESS(I_WIDTH,I_HEIGH)
        VARIABLE I_WIDTH_V : STD_LOGIC_VECTOR (PRG_FULL_CONST downto 0);
    BEGIN
        I_WIDTH_V := (PRG_FULL_CONST downto I_WIDTH'length => '0') & I_WIDTH;
        I_WIDTH_V := I_WIDTH_V -6;
        THRESHSIZE <= I_WIDTH_V;
    END PROCESS;
    

    -- 
    -- Calculate Points in time (Asynchromus)
    --
    buf_calc : PROCESS(I_WIDTH,I_HEIGH)
        VARIABLE F2S_COUNT_V  : STD_LOGIC_VECTOR (UBIT16 downto 0);
        VARIABLE DONE_COUNT_V : STD_LOGIC_VECTOR (UBIT16 downto 0);
        VARIABLE I_HEIGH_V : STD_LOGIC_VECTOR (UBIT16 downto 0);
    BEGIN
        F2S_COUNT_V := (UBIT16 downto I_WIDTH'length => '0') & I_WIDTH;
        F2S_COUNT_V := F2S_COUNT_V +1;
        F2S_COUNT <= F2S_COUNT_V;

        DONE_COUNT_V := I_WIDTH * I_HEIGH;
        DONE_COUNT <= DONE_COUNT_V;
        
        I_HEIGH_V := (UBIT16 downto I_WIDTH'length => '0') & I_HEIGH;
        I_HEIGH_V := DONE_COUNT_V - I_HEIGH_V;
        FN_END_COUNT <= I_HEIGH_V;
    END PROCESS;


    --
    -- Counter PROCESS (Synchromus)
    --
     counter_p: PROCESS (clk, RESET) 
     BEGIN
          IF (RESET = '1') THEN
              count <= (others=>'0');
          ELSIF (rising_edge(clk)) THEN
              IF (ENABLE = '1') THEN
                  count <= count + 1;
              END IF;
          END IF;
      END PROCESS;  
    

    -- 
    -- Frame start (Synchromus)
    --
    control: PROCESS(clk, RESET)
    BEGIN
        IF (RESET = '1') THEN
            READY <= '0';
            DONE <= '0';
            F2_START <= '0';
        ELSIF (rising_edge(clk)) THEN
            IF (ENABLE = '1') THEN
                -- READY SIGNAL
                IF count = 0 THEN
                    READY <= '1';
                ELSE
                    READY <= '0';
                END IF;         
                -- F2_START SIGNAL
                IF count = F2S_COUNT THEN
                    F2_START <= '1';
                ELSE
                    F2_START <= '0';
                END IF; 
                -- FN_END SIGNAL
                IF count = FN_END_COUNT THEN
                    FN_END <= '1';
                ELSE
                    FN_END <= '0';
                END IF; 
                -- DONE SIGNAL
                IF count = DONE_COUNT THEN
                    DONE <= '1';
                ELSE
                    DONE <= '0';
                END IF; 
            END IF; -- ENABLE
        END IF; -- MAIN 
     END PROCESS;

    -- 
    -- Frame start (Synchromus)
    --
    dout_c : PROCESS(clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (ENABLE = '1') THEN
                -- DOUT LOGIC
                IF count < F2S_COUNT THEN
                    DOUT <= (others => '1');
                ELSIF count > FN_END_COUNT THEN
                    DOUT <= (others => '1');
                ELSE
                    DOUT <= DIN;
                END IF;
                -- DOUT LOGIC END
            END IF; -- ENABLE
        END IF; -- rising_edge(clk)
    END PROCESS;
    
END fc_impl;

