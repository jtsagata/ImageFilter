LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE constants IS
	CONSTANT UBIT    : NATURAL := 8-1;  -- 8 bits
	CONSTANT UBIT16  : NATURAL := 16-1; -- 16 bits
	CONSTANT SBIT    : NATURAL := 9-1;  -- 9 bits
	CONSTANT MSIZE   : NATURAL := 4-1;  -- 4 bits
	CONSTANT MRESULT : NATURAL := 12;   -- 13 bits 4 bit X 9 bit 
	
	-- WAIT values
	CONSTANT WAIT_ADDER : NATURAL := 5;      -- cycles
	CONSTANT WAIT_MULT_ADDER : NATURAL := 7;  -- cycles
	
	-- PRG_FULL_THRESHOLD IS AT is 512 bytes 
	CONSTANT PRG_FULL_CONST : NATURAL:= 9-1; -- 9 bits
END constants;

PACKAGE BODY constants IS

END constants;
