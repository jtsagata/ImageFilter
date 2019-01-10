LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

ENTITY filter_bank IS
    PORT (
        P1 : IN std_logic_vector(UBIT DOWNTO 0);
        P2 : IN std_logic_vector(UBIT DOWNTO 0);
        P3 : IN std_logic_vector(UBIT DOWNTO 0);
        P4 : IN std_logic_vector(UBIT DOWNTO 0);
        P5 : IN std_logic_vector(UBIT DOWNTO 0);
        P6 : IN std_logic_vector(UBIT DOWNTO 0);
        P7 : IN std_logic_vector(UBIT DOWNTO 0);
        P8 : IN std_logic_vector(UBIT DOWNTO 0);
        P9 : IN std_logic_vector(UBIT DOWNTO 0);
        SW_A : IN STD_LOGIC;
        SW_B : IN STD_LOGIC;
		SW_C : IN STD_LOGIC;
        Enable : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        
        sum :   OUT std_logic_vector(UBIT DOWNTO 0)--;
    );
END filter_bank;

ARCHITECTURE fb_impl OF filter_bank IS
 
COMPONENT filter_bank_choser
    PORT (
        SW_A : IN std_logic;
        SW_B : IN std_logic; 
		SW_C : IN STD_LOGIC;
        M1 : OUT signed(MSIZE DOWNTO 0);
        M2 : OUT signed(MSIZE DOWNTO 0);
        M3 : OUT signed(MSIZE DOWNTO 0);
        M4 : OUT signed(MSIZE DOWNTO 0);
        M5 : OUT signed(MSIZE DOWNTO 0);
        M6 : OUT signed(MSIZE DOWNTO 0);
        M7 : OUT signed(MSIZE DOWNTO 0);
        M8 : OUT signed(MSIZE DOWNTO 0);
        M9 : OUT signed(MSIZE DOWNTO 0);
        DIVIDER : OUT signed(MSIZE DOWNTO 0)
    );
END COMPONENT;
 
COMPONENT mult_adder IS
    PORT (
        S1 : IN std_logic_vector(UBIT DOWNTO 0);
        S2 : IN std_logic_vector(UBIT DOWNTO 0);
        S3 : IN std_logic_vector(UBIT DOWNTO 0);
        S4 : IN std_logic_vector(UBIT DOWNTO 0);
        S5 : IN std_logic_vector(UBIT DOWNTO 0);
        S6 : IN std_logic_vector(UBIT DOWNTO 0);
        S7 : IN std_logic_vector(UBIT DOWNTO 0);
        S8 : IN std_logic_vector(UBIT DOWNTO 0);
        S9 : IN std_logic_vector(UBIT DOWNTO 0);

        M1 : IN signed (MSIZE DOWNTO 0);
        M2 : IN signed (MSIZE DOWNTO 0);
        M3 : IN signed (MSIZE DOWNTO 0);
        M4 : IN signed (MSIZE DOWNTO 0);
        M5 : IN signed (MSIZE DOWNTO 0);
        M6 : IN signed (MSIZE DOWNTO 0);
        M7 : IN signed (MSIZE DOWNTO 0);
        M8 : IN signed (MSIZE DOWNTO 0);
        M9 : IN signed (MSIZE DOWNTO 0);

        sum : OUT signed (MRESULT DOWNTO 0);
        
        Enable : IN std_logic;
        CLK : IN std_logic--; 
    );
END COMPONENT;

COMPONENT zipper is
    Port (
        Enable : IN STD_LOGIC;
        CLK :    IN STD_LOGIC;
        
        INPUT  : IN  signed(MRESULT DOWNTO 0);
        OUTPUT : OUT std_logic_vector(UBIT DOWNTO 0) --;
    
    );
END COMPONENT;

 
signal M1_OUT: signed (MSIZE DOWNTO 0); 
signal M2_OUT: signed (MSIZE DOWNTO 0); 
signal M3_OUT: signed (MSIZE DOWNTO 0); 
signal M4_OUT: signed (MSIZE DOWNTO 0); 
signal M5_OUT: signed (MSIZE DOWNTO 0); 
signal M6_OUT: signed (MSIZE DOWNTO 0); 
signal M7_OUT: signed (MSIZE DOWNTO 0); 
signal M8_OUT: signed (MSIZE DOWNTO 0); 
signal M9_OUT: signed (MSIZE DOWNTO 0); 
signal M_OUT:  signed (MRESULT DOWNTO 0);
 
BEGIN

    Inst_filter_bank_choser : filter_bank_choser
    PORT MAP(
        SW_A => SW_A, 
        SW_B => SW_B, 
		SW_C => SW_C,
        M1 => M1_OUT, 
        M2 => M2_OUT, 
        M3 => M3_OUT, 
        M4 => M4_OUT, 
        M5 => M5_OUT, 
        M6 => M6_OUT, 
        M7 => M7_OUT, 
        M8 => M8_OUT, 
        M9 => M9_OUT, 
        DIVIDER => OPEN
    ); 

    Inst_multiplier: mult_adder PORT MAP(
        S1 => P1,
        S2 => P2,
        S3 => P3,
        S4 => P4,
        S5 => P5,
        S6 => P6,
        S7 => P7,
        S8 => P8,
        S9 => P9,
        M1 => M1_OUT, 
        M2 => M2_OUT, 
        M3 => M3_OUT, 
        M4 => M4_OUT, 
        M5 => M5_OUT, 
        M6 => M6_OUT, 
        M7 => M7_OUT, 
        M8 => M8_OUT, 
        M9 => M9_OUT,       
        Enable => Enable,
        CLK => CLK,
        sum => M_OUT--,
    );

    Inst_zipper: zipper PORT MAP(
        Enable => Enable,
        CLK => CLK,
        INPUT => M_OUT,
        OUTPUT => SUM
    );

END fb_impl;