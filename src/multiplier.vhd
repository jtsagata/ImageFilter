LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;
ENTITY multiplier IS
	PORT (
		P1 : IN signed (8 DOWNTO 0);
		P2 : IN signed (8 DOWNTO 0);
		P3 : IN signed (8 DOWNTO 0);
		P4 : IN signed (8 DOWNTO 0);
		P5 : IN signed (8 DOWNTO 0);
		P6 : IN signed (8 DOWNTO 0);
		P7 : IN signed (8 DOWNTO 0);
		P8 : IN signed (8 DOWNTO 0);
		P9 : IN signed (8 DOWNTO 0);

		M1 : IN signed (MSIZE DOWNTO 0);
		M2 : IN signed (MSIZE DOWNTO 0);
		M3 : IN signed (MSIZE DOWNTO 0);
		M4 : IN signed (MSIZE DOWNTO 0);
		M5 : IN signed (MSIZE DOWNTO 0);
		M6 : IN signed (MSIZE DOWNTO 0);
		M7 : IN signed (MSIZE DOWNTO 0);
		M8 : IN signed (MSIZE DOWNTO 0);
		M9 : IN signed (MSIZE DOWNTO 0);

		Enable : IN std_logic;
		CLK : IN std_logic; 
		sum : OUT signed (MRESULT DOWNTO 0);
		Ready : OUT std_logic
	);
END multiplier;

ARCHITECTURE multiplier_impl OF multiplier IS
	SIGNAL IN1 : signed (MRESULT DOWNTO 0);
	SIGNAL IN2 : signed (MRESULT DOWNTO 0);
	SIGNAL IN3 : signed (MRESULT DOWNTO 0);
	SIGNAL IN4 : signed (MRESULT DOWNTO 0);
	SIGNAL IN5 : signed (MRESULT DOWNTO 0);
	SIGNAL IN6 : signed (MRESULT DOWNTO 0);
	SIGNAL IN7 : signed (MRESULT DOWNTO 0);
	SIGNAL IN8 : signed (MRESULT DOWNTO 0);
	SIGNAL IN9 : signed (MRESULT DOWNTO 0);
 
	COMPONENT signed_adder IS
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
			CLK : IN STD_LOGIC;
			Ready : OUT STD_LOGIC
		);

	END COMPONENT;
 

BEGIN
	PROCESS (Enable, CLK)

	BEGIN
		-- TODO: clock first
		IF (Enable = '1') AND (CLK'EVENT AND CLK = '1') THEN
			IN1 <= P1 * M1;
			IN2 <= P2 * M2;
			IN3 <= P3 * M3;
			IN4 <= P4 * M4;
			IN5 <= P5 * M5;
			IN6 <= P6 * M6;
			IN7 <= P7 * M7;
			IN8 <= P8 * M8;
			IN9 <= P9 * M9;
		END IF;
	END PROCESS;

END multiplier_impl;