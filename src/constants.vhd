LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE constants IS
	CONSTANT UBIT  : NATURAL := 8-1;  -- 8 bits
	CONSTANT SBIT  : NATURAL := 8;  -- 9 bits
	CONSTANT MSIZE : NATURAL := 3;  -- 4 bits
	-- 4 bit X 9 bit 
	CONSTANT MRESULT : NATURAL := 12; -- 13 bits
	
	-- WAIT values
	CONSTANT WAIT_ADDER : NATURAL := 5;  -- cycles
	CONSTANT WAIT_MULT_ADDER : NATURAL := 7;  -- cycles
	
	-- 512 bytes 
	CONSTANT PRG_FULL_CONST : NATURAL:= 8; -- 9 bits
END constants;

PACKAGE BODY constants IS

END constants;
