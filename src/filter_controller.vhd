LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all;
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
		
		-- FOR DEBUG
		COUNTER : OUT std_logic_vector(PRG_FULL_CONST DOWNTO 0);
		
		DOUT :    OUT  STD_LOGIC_VECTOR (UBIT downto 0);
        F_START : OUT  STD_LOGIC;
        F_END :   OUT  STD_LOGIC--;
	);
END filter_controller;

architecture Behavioral of filter_controller is
SIGNAL count :std_logic_vector (PRG_FULL_CONST downto 0);
SIGNAL row2_start : std_logic_vector(PRG_FULL_CONST downto 0);
SIGNAL row_last   : std_logic_vector(PRG_FULL_CONST downto 0);
SIGNAL row_END    : std_logic_vector(PRG_FULL_CONST downto 0);
BEGIN

	-- Calculate THRESHSIZE, row possitions
	buf_calc : PROCESS(I_WIDTH)
	variable therh_v : std_logic_vector(PRG_FULL_CONST downto 0);
	variable therh_u : unsigned(PRG_FULL_CONST downto 0);
	variable rowB_v : std_logic_vector(PRG_FULL_CONST downto 0);
	variable rowB_u : unsigned(PRG_FULL_CONST downto 0);
	variable rowL_v : std_logic_vector(PRG_FULL_CONST downto 0);
	variable rowL_u : unsigned(PRG_FULL_CONST downto 0);
	variable colL_v : std_logic_vector(PRG_FULL_CONST downto 0);
	variable colL_u : unsigned(PRG_FULL_CONST downto 0);
	variable lastL_v : std_logic_vector(PRG_FULL_CONST downto 0);
	variable lastL_u : unsigned(PRG_FULL_CONST downto 0);
	BEGIN
		-- Claculate thershsize
		therh_v := '0' & I_WIDTH;
		therh_u := unsigned(therh_v);
		therh_u := therh_u -6;
		THRESHSIZE <= std_logic_vector(therh_u);
		
		-- Calculate 2nd row start
		rowB_v := '0' & I_WIDTH;
		rowB_u := unsigned(rowB_v);
		--rowB_u := rowB_u +1;
		row2_start <= std_logic_vector(rowB_u);
		
		-- Calculate LAST row start
		rowL_v := '0' & I_WIDTH;
		colL_v := '0' & I_HEIGH;
		rowL_u := unsigned(rowL_v);
		colL_u := unsigned(colL_v);
		lastL_u := rowL_u + rowL_u;
		row_last <= std_logic_vector(lastL_u);
	END PROCESS;

	-- Counter PROCESS
	 count_p: PROCESS (clk, RESET) 
	 BEGIN
          IF (RESET = '1') THEN
              count <= (others=>'0');
          ELSIF (rising_edge(clk)) THEN
              IF (ENABLE = '1') THEN
                  count <= count + 1;
              END IF;
          END IF;
      END PROCESS;
  
	-- Frame start and END
	 control: PROCESS(clk, RESET)
	 BEGIN
		IF (RESET = '1') THEN
              F_START <= '0';
			  F_END <= '0';
          ELSIF (rising_edge(clk)) THEN
			IF (ENABLE = '1') THEN
				IF count = 0 THEN
					F_START <= '1';
				ELSE
					F_START <= '0';
				END IF;
			END IF;
		END IF;
     END PROCESS;
  
	-- Calculate DOUT
--	dout_c : PROCESS(clk)
--	BEGIN
--		IF (rising_edge(clk)) THEN
--			--IF (ENABLE = '1') THEN
--				IF count < row2_start THEN
--					DOUT <= (others => '1');
--				ELSIF count > row_last THEN
--					DOUT <= (others => '1');
--				ELSE
--					DOUT <= FILTER_IN;
--				END IF;
--			--END IF;
--		END IF;
--	END PROCESS;
  DOUT <= FILTER_IN;
  
	  -- DEBUG CONNECT COUNTER
	  COUNTER <= count;

END Behavioral;

