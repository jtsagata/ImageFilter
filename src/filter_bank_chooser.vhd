library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.constants.all;

entity filter_bank is
    Port ( SW_A : in  STD_LOGIC;
           SW_B : in  STD_LOGIC;
           M1 : out  signed(MSIZE downto 0);
		   M2 : out  signed(MSIZE downto 0);
		   M3 : out  signed(MSIZE downto 0);
		   M4 : out  signed(MSIZE downto 0);
		   M5 : out  signed(MSIZE downto 0);
		   M6 : out  signed(MSIZE downto 0);
		   M7 : out  signed(MSIZE downto 0);
		   M8 : out  signed(MSIZE downto 0);
		   M9 : out  signed(MSIZE downto 0);
		   SUM: out  signed(MSIZE downto 0)--;
	);
end filter_bank;

architecture fb_imp of filter_bank is
begin
	DRIVER: process(SW_A,SW_B)
	variable DIN : std_logic_vector(1 downto 0);
	begin
		DIN := SW_A & SW_B;
		case DIN is
			-- TRIVIAL IDENTITY FILTER
			when "00" => 
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
			when "01" => 
				M1 <= to_signed(1, M1'length);
				M2 <= to_signed(0, M2'length);
				M3 <= to_signed(1, M3'length);
				--
				M4 <= to_signed(-2, M4'length);
				M5 <= to_signed( 0, M5'length);
				M6 <= to_signed(+2, M6'length);
				--
				M7 <= to_signed(-1, M7'length);
				M8 <= to_signed( 0, M8'length);
				M9 <= to_signed(+1 ,M9'length);
			-- SOBEL FILTER Y
			when "10" => 
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
				M9 <= to_signed(1 ,M9'length);
			-- GAUSIAN FILTER
			when others =>
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
				M9 <= to_signed(1 ,M9'length);
		end case;
	end process;
end fb_imp;

