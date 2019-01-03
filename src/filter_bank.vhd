LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

ENTITY filter_bank_chooser IS
	PORT (
		SW_A : IN STD_LOGIC;
		SW_B : IN STD_LOGIC;
		M1 : OUT signed(MSIZE DOWNTO 0);
		M2 : OUT signed(MSIZE DOWNTO 0);
		M3 : OUT signed(MSIZE DOWNTO 0);
		M4 : OUT signed(MSIZE DOWNTO 0);
		M5 : OUT signed(MSIZE DOWNTO 0);
		M6 : OUT signed(MSIZE DOWNTO 0);
		M7 : OUT signed(MSIZE DOWNTO 0);
		M8 : OUT signed(MSIZE DOWNTO 0);
		M9 : OUT signed(MSIZE DOWNTO 0);
		SUM : OUT signed(MSIZE DOWNTO 0)--;
	);
END filter_bank_chooser;

ARCHITECTURE fb_imp OF filter_bank_chooser IS
BEGIN
	DRIVER : PROCESS (SW_A, SW_B)
		VARIABLE DIN : std_logic_vector(1 DOWNTO 0);
	BEGIN
		DIN := SW_A & SW_B;
		CASE DIN IS
			-- TRIVIAL IDENTITY FILTER
			WHEN "00" => 
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
				-- SOBEL FILTER X
			WHEN "01" => 
				M1 <= to_signed(1, M1'length);
				M2 <= to_signed(0, M2'length);
				M3 <= to_signed(1, M3'length);
				--
				M4 <= to_signed( - 2, M4'length);
				M5 <= to_signed(0, M5'length);
				M6 <= to_signed( + 2, M6'length);
				--
				M7 <= to_signed( - 1, M7'length);
				M8 <= to_signed(0, M8'length);
				M9 <= to_signed( + 1, M9'length);
				-- SOBEL FILTER Y
			WHEN "10" => 
				M1 <= to_signed( - 1, M1'length);
				M2 <= to_signed( - 2, M2'length);
				M3 <= to_signed( - 1, M3'length);
				--
				M4 <= to_signed(0, M4'length);
				M5 <= to_signed(0, M5'length);
				M6 <= to_signed(0, M6'length);
				--
				M7 <= to_signed(1, M7'length);
				M8 <= to_signed(2, M8'length);
				M9 <= to_signed(1, M9'length);
				-- GAUSIAN FILTER
			WHEN OTHERS => 
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
		END CASE;
	END PROCESS;
END fb_imp;