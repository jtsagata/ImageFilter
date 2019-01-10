LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

ENTITY mult_adder IS
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
END mult_adder;

ARCHITECTURE mult_adder_impl OF mult_adder IS

    -- Convert std_logic_vector to signed
    SIGNAL P1_S : signed (SBIT DOWNTO 0);
    SIGNAL P2_S : signed (SBIT DOWNTO 0);
    SIGNAL P3_S : signed (SBIT DOWNTO 0);
    SIGNAL P4_S : signed (SBIT DOWNTO 0);
    SIGNAL P5_S : signed (SBIT DOWNTO 0);
    SIGNAL P6_S : signed (SBIT DOWNTO 0);
    SIGNAL P7_S : signed (SBIT DOWNTO 0);
    SIGNAL P8_S : signed (SBIT DOWNTO 0);
    SIGNAL P9_S : signed (SBIT DOWNTO 0);
    
    -- Multiplied values
    SIGNAL IN1 : signed (MRESULT DOWNTO 0);
    SIGNAL IN2 : signed (MRESULT DOWNTO 0);
    SIGNAL IN3 : signed (MRESULT DOWNTO 0);
    SIGNAL IN4 : signed (MRESULT DOWNTO 0);
    SIGNAL IN5 : signed (MRESULT DOWNTO 0);
    SIGNAL IN6 : signed (MRESULT DOWNTO 0);
    SIGNAL IN7 : signed (MRESULT DOWNTO 0);
    SIGNAL IN8 : signed (MRESULT DOWNTO 0);
    SIGNAL IN9 : signed (MRESULT DOWNTO 0);
    
    COMPONENT signed_adder is
    Port ( P1 : in signed (MRESULT downto 0);
           P2 : in signed (MRESULT downto 0);
           P3 : in signed (MRESULT downto 0);
           P4 : in signed (MRESULT downto 0);
           P5 : in signed (MRESULT downto 0);
           P6 : in signed (MRESULT downto 0);
           P7 : in signed (MRESULT downto 0);
           P8 : in signed (MRESULT downto 0);
           P9 : in signed (MRESULT downto 0);
           sum : out   signed (MRESULT downto 0);
           Enable : in  STD_LOGIC;
           CLK : in  STD_LOGIC
	);
    END COMPONENT;
    
BEGIN
    -- Convert std_logic_vector to signed
    P1_S <= signed('0' & S1);
    P2_S <= signed('0' & S2);
    P3_S <= signed('0' & S3);
    P4_S <= signed('0' & S4);
    P5_S <= signed('0' & S5);
    P6_S <= signed('0' & S6);
    P7_S <= signed('0' & S7);
    P8_S <= signed('0' & S8);
    P9_S <= signed('0' & S9);
        
    PROCESS (Enable, CLK)
    BEGIN
        IF (CLK'EVENT AND CLK = '1') THEN
        IF (Enable = '1') THEN
            IN1 <= P1_S * M1;
            IN2 <= P2_S * M2;
            IN3 <= P3_S * M3;
            IN4 <= P4_S * M4;
            IN5 <= P5_S * M5;
            IN6 <= P6_S * M6;
            IN7 <= P7_S * M7;
            IN8 <= P8_S * M8;
            IN9 <= P9_S * M9;
        END IF;
        END IF;
    END PROCESS;

    Inst_ADDER: signed_adder PORT MAP(
        P1 => IN1,
        P2 => IN2,
        P3 => IN3,
        P4 => IN4,
        P5 => IN5,
        P6 => IN6,
        P7 => IN7,
        P8 => IN8,
        P9 => IN9,
        sum => SUM,
        Enable => Enable,
        CLK => CLK
    );

END mult_adder_impl;