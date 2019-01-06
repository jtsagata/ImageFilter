LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

entity filter_top is
    Port ( 
        CLK :    IN  STD_LOGIC;
        ENABLE : IN  STD_LOGIC;
        RESET :  IN std_logic;
        
        I_WIDTH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        I_HEIGH : IN STD_LOGIC_VECTOR (UBIT downto 0);


		SW_A : IN STD_LOGIC;
		SW_B : IN STD_LOGIC;

        DIN  : IN  STD_LOGIC_VECTOR (UBIT downto 0);
        
        DOUT : OUT  STD_LOGIC_VECTOR (UBIT downto 0);
        F_START : OUT  STD_LOGIC;
        F_END : OUT  STD_LOGIC--;

    );
end filter_top;

architecture filter_top_i of filter_top is

	COMPONENT cache_mem
	PORT (
	  CLK : IN std_logic;
	  ENABLE : IN std_logic;
	  RESET : IN std_logic;
	  DIN : IN std_logic_vector(UBIT DOWNTO 0);
	  prog_full_thresh : IN std_logic_vector(PRG_FULL_CONST DOWNTO 0);
	  P1 : OUT std_logic_vector(UBIT DOWNTO 0);
	  P2 : OUT std_logic_vector(UBIT DOWNTO 0);
	  P3 : OUT std_logic_vector(UBIT DOWNTO 0);
	  P4 : OUT std_logic_vector(UBIT DOWNTO 0);
	  P5 : OUT std_logic_vector(UBIT DOWNTO 0);
	  P6 : OUT std_logic_vector(UBIT DOWNTO 0);
	  P7 : OUT std_logic_vector(UBIT DOWNTO 0);
	  P8 : OUT std_logic_vector(UBIT DOWNTO 0);
	  P9 : OUT std_logic_vector(UBIT DOWNTO 0)--;
	  );
	END COMPONENT;

	SIGNAL P1 : std_logic_vector(UBIT DOWNTO 0);
	SIGNAL P2 : std_logic_vector(UBIT DOWNTO 0);
	SIGNAL P3 : std_logic_vector(UBIT DOWNTO 0);
	SIGNAL P4 : std_logic_vector(UBIT DOWNTO 0);
	SIGNAL P5 : std_logic_vector(UBIT DOWNTO 0);
	SIGNAL P6 : std_logic_vector(UBIT DOWNTO 0);
	SIGNAL P7 : std_logic_vector(UBIT DOWNTO 0);
	SIGNAL P8 : std_logic_vector(UBIT DOWNTO 0);
	SIGNAL P9 : std_logic_vector(UBIT DOWNTO 0);

	SIGNAL THRESHSIZE :std_logic_vector(PRG_FULL_CONST DOWNTO 0);


    COMPONENT filter_bank
    PORT(
         P1 : IN  std_logic_vector(7 downto 0);
         P2 : IN  std_logic_vector(7 downto 0);
         P3 : IN  std_logic_vector(7 downto 0);
         P4 : IN  std_logic_vector(7 downto 0);
         P5 : IN  std_logic_vector(7 downto 0);
         P6 : IN  std_logic_vector(7 downto 0);
         P7 : IN  std_logic_vector(7 downto 0);
         P8 : IN  std_logic_vector(7 downto 0);
         P9 : IN  std_logic_vector(7 downto 0);
         SW_A : IN  std_logic;
         SW_B : IN  std_logic;
         Enable : IN  std_logic;
         CLK : IN  std_logic;
		 
         sum : OUT std_logic_vector(UBIT DOWNTO 0);
         Ready : OUT  std_logic
        );
    END COMPONENT;

    SIGNAL FILTER_OUT : std_logic_vector(UBIT DOWNTO 0);

	COMPONENT filter_controller is
    Port ( 
		CLK :    IN  STD_LOGIC;
        ENABLE : IN  STD_LOGIC;
        RESET :  IN std_logic;
		I_WIDTH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        I_HEIGH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        FILTER_IN  : IN  STD_LOGIC_VECTOR (UBIT downto 0);
	    THRESHSIZE :std_logic_vector(PRG_FULL_CONST DOWNTO 0);
		DOUT :    OUT  STD_LOGIC_VECTOR (UBIT downto 0);
        F_START : OUT  STD_LOGIC;
        F_END :   OUT  STD_LOGIC--;
	);
	end COMPONENT;

begin

   fbank: filter_bank 
   PORT MAP (
          P1 => P1,
          P2 => P2,
          P3 => P3,
          P4 => P4,
          P5 => P5,
          P6 => P6,
          P7 => P7,
          P8 => P8,
          P9 => P9,
          SW_A => SW_A,
          SW_B => SW_B,
          Enable => Enable,
          CLK => CLK,
          sum => FILTER_OUT,
          Ready => open
    );

  cmem : cache_mem
  PORT MAP(
    CLK => CLK, 
    ENABLE => ENABLE, 
    RESET => RESET, 
    DIN => DIN, 
    prog_full_thresh => THRESHSIZE, 
    P1 => P1, 
    P2 => P2, 
    P3 => P3, 
    P4 => P4, 
    P5 => P5, 
    P6 => P6, 
    P7 => P7, 
    P8 => P8, 
    P9 => P9
  );

	cntrl: filter_controller PORT MAP(
		CLK => CLK,
		ENABLE => ENABLE,
		RESET => RESET,
		I_WIDTH => I_WIDTH,
		I_HEIGH => I_HEIGH,
		FILTER_IN => FILTER_OUT,
		THRESHSIZE => THRESHSIZE,
		DOUT => DOUT ,
		F_START => F_START,
		F_END => F_END
	);

	-- DOUT <= FILTER_OUT;

end filter_top_i;

