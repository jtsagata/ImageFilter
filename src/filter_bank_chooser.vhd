LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

ENTITY filter_bank_choser IS
    PORT (
        SW_A : IN STD_LOGIC;
        SW_B : IN STD_LOGIC;
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
        DIVIDER : OUT signed(MSIZE DOWNTO 0)--;
    );
END filter_bank_choser;

ARCHITECTURE fbc_imp OF filter_bank_choser IS
BEGIN
    DRIVER : PROCESS (SW_A, SW_B, SW_C)
    VARIABLE DIN : std_logic_vector(2 DOWNTO 0);
    BEGIN
        DIN := SW_A & SW_B & SW_C;
        CASE DIN IS
            
            WHEN "000" => 
                -- TRIVIAL IDENTITY FILTER
                M1 <= to_signed(0, M1'length);
                M2 <= to_signed(0, M2'length);
                M3 <= to_signed(0, M3'length);
                --
                M4 <= to_signed(0, M4'length);
                M5 <= to_signed(1, M5'length);
                M6 <= to_signed(0, M6'length);
                --
                M7 <= to_signed(0, M7'length);
                M8 <= to_signed(0, M8'length);
                M9 <= to_signed(0, M9'length);
                DIVIDER <= to_signed(1, M9'length);
            WHEN "001" => 
                -- SOBEL FILTER X
                M1 <= to_signed(1, M1'length);
                M2 <= to_signed(0, M2'length);
                M3 <= to_signed(1, M3'length);
                --
                M4 <= to_signed(-2, M4'length);
                M5 <= to_signed(0,  M5'length);
                M6 <= to_signed(+2, M6'length);
                --
                M7 <= to_signed(-1, M7'length);
                M8 <= to_signed(0,  M8'length);
                M9 <= to_signed(-1, M9'length);
                DIVIDER <= to_signed(1, M9'length);
                
            WHEN "010" => 
                -- SOBEL FILTER Y
                M1 <= to_signed(-1, M1'length);
                M2 <= to_signed(-2, M2'length);
                M3 <= to_signed(-1, M3'length);
                --
                M4 <= to_signed(0, M4'length);
                M5 <= to_signed(0, M5'length);
                M6 <= to_signed(0, M6'length);
                --
                M7 <= to_signed(1, M7'length);
                M8 <= to_signed(2, M8'length);
                M9 <= to_signed(1, M9'length);
                DIVIDER <= to_signed(1, M9'length);

            WHEN "011" => 
                -- GAUSIAN FILTER
                M1 <= to_signed(18, M1'length);
                M2 <= to_signed(8,  M2'length);
                M3 <= to_signed(16, M3'length);
                --
                M4 <= to_signed(8, M4'length);
                M5 <= to_signed(4, M5'length);
                M6 <= to_signed(8, M6'length);
                --
                M7 <= to_signed(16, M7'length);
                M8 <= to_signed(8, M8'length);
                M9 <= to_signed(16, M9'length);
                DIVIDER <= to_signed(1, M9'length);

                
            WHEN OTHERS => 
                -- AVERAGE FILTER
                M1 <= to_signed(1, M1'length);
                M2 <= to_signed(1, M2'length);
                M3 <= to_signed(1, M3'length);
                --
                M4 <= to_signed(1, M4'length);
                M5 <= to_signed(0, M5'length);
                M6 <= to_signed(1, M6'length);
                --
                M7 <= to_signed(1, M7'length);
                M8 <= to_signed(1, M8'length);
                M9 <= to_signed(1, M9'length);
                DIVIDER <= to_signed(8, M9'length);
        END CASE;
    END PROCESS;
    
END fbc_imp;