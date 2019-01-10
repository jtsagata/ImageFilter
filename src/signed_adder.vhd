LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

ENTITY signed_adder IS
    PORT (
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
        Enable : IN STD_LOGIC;
        CLK : IN STD_LOGIC--;
    );
END signed_adder;

ARCHITECTURE signed_adder_impl OF signed_adder IS

    SIGNAL tempS0 : signed (MRESULT DOWNTO 0);
    SIGNAL tempS1 : signed (MRESULT DOWNTO 0);
    SIGNAL tempS2 : signed (MRESULT DOWNTO 0);
    SIGNAL tempS3 : signed (MRESULT DOWNTO 0);
    SIGNAL tempS4 : signed (MRESULT DOWNTO 0);
    SIGNAL tempS5 : signed (MRESULT DOWNTO 0);
    SIGNAL tempS6 : signed (MRESULT DOWNTO 0);

    SIGNAL temp_delay1 : signed (MRESULT DOWNTO 0);
    SIGNAL temp_delay2 : signed (MRESULT DOWNTO 0);
    SIGNAL temp_delay3 : signed (MRESULT DOWNTO 0);

    SIGNAL result : signed(MRESULT DOWNTO 0);

BEGIN
    PROCESS (Enable, CLK)

    BEGIN
        IF (Enable = '1') AND (CLK'EVENT AND CLK = '1') THEN

            tempS0 <= P1 + P2;
            tempS1 <= P3 + P4;
            tempS2 <= P6 + P5;
            tempS3 <= P7 + P8;
            tempS4 <= tempS0 + tempS1;
            tempS5 <= tempS2 + tempS3;
            tempS6 <= tempS5 + tempS4;

            temp_delay1 <= P9;
            temp_delay2 <= temp_delay1;
            temp_delay3 <= temp_delay2;

            result <= tempS6 + temp_delay3;
            --+ P3_intern + P4_intern + P5_intern + P6_intern + P7_intern + P8_intern + P9_intern;
            sum <= result;
        END IF;

    END PROCESS;
END signed_adder_impl;