LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE constants IS
	CONSTANT UBIT  : NATURAL := 7;  -- 8 bits
	CONSTANT SBIT  : NATURAL := 8;  -- 9 bits
	CONSTANT MSIZE : NATURAL := 3;  -- 4 bits
	-- 4 bit X 9 bit 
	CONSTANT MRESULT : NATURAL := 12; -- 13 bits
	
	-- WAIT values
	CONSTANT WAIT_ADDER : NATURAL := 5;  -- cycles
END constants;

PACKAGE BODY constants IS

END constants;
