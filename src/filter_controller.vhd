LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

entity filter_controller is
    Port ( 
		CLK :    IN  STD_LOGIC;
        ENABLE : IN  STD_LOGIC;
        RESET :  IN std_logic;
		
		I_WIDTH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        I_HEIGH : IN STD_LOGIC_VECTOR (UBIT downto 0);
		
        FILTER_IN  : IN  STD_LOGIC_VECTOR (UBIT downto 0);

	    THRESHSIZE : OUT std_logic_vector(PRG_FULL_CONST DOWNTO 0);
		
		DOUT :    OUT  STD_LOGIC_VECTOR (UBIT downto 0);
        F_START : OUT  STD_LOGIC;
        F_END :   OUT  STD_LOGIC--;
	);
end filter_controller;

architecture Behavioral of filter_controller is

begin

	-- Pass input to output from now
	DOUT <= FILTER_IN;
	F_START <= '1';
	F_END <= '1';

	-- Calculate THRESHSIZE
	buf_calc : PROCESS(I_WIDTH)
	variable tmp1 : std_logic_vector(PRG_FULL_CONST downto 0);
	variable tmp2 : unsigned(PRG_FULL_CONST downto 0);
	BEGIN
		tmp1 := '0' & I_WIDTH;
		tmp2 := unsigned(tmp1);
		tmp2 := tmp2 -6;
		THRESHSIZE <= std_logic_vector(tmp2);
	END PROCESS;


end Behavioral;

