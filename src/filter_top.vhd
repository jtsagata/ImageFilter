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
		SW_C : IN STD_LOGIC;
        DIN  : IN  STD_LOGIC_VECTOR (UBIT downto 0);
        -- PIXEL OUT
        DOUT : OUT  STD_LOGIC_VECTOR (UBIT downto 0);
        -- Control Signals
        READY    : OUT  STD_LOGIC;
        DONE     : OUT  STD_LOGIC;
        F2_START : OUT  STD_LOGIC;
        FN_END   : OUT  STD_LOGIC--;
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
		 SW_C : IN  std_logic;
         Enable : IN  std_logic;
         CLK : IN  std_logic;
         
         sum : OUT std_logic_vector(UBIT DOWNTO 0)--;
        );
    END COMPONENT;

    SIGNAL FILTER_OUT : std_logic_vector(UBIT DOWNTO 0);

    COMPONENT filter_controller is
    Port ( 
        CLK :    IN  STD_LOGIC;
        ENABLE : IN  STD_LOGIC;
        RESET :  IN std_logic;
        -- Image Dimensions
        I_WIDTH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        I_HEIGH : IN STD_LOGIC_VECTOR (UBIT downto 0);
        THRESHSIZE : OUT std_logic_vector(PRG_FULL_CONST DOWNTO 0);
        -- Data in/out
        DIN      : IN  STD_LOGIC_VECTOR (UBIT downto 0);        
        DOUT     : OUT  STD_LOGIC_VECTOR (UBIT downto 0);
        -- Control Signals
        READY    : OUT  STD_LOGIC;
        DONE     : OUT  STD_LOGIC;
        F2_START : OUT  STD_LOGIC;
        FN_END   : OUT  STD_LOGIC--;
    );
    end COMPONENT;

	COMPONENT controller_enabler
	PORT(
		ENABLE : IN std_logic;
		CLK : IN std_logic;
		RESET : IN std_logic;          
		ENABLE_OUT : OUT std_logic
		);
	END COMPONENT;
	
	SIGNAL ENABLE_OUT : std_logic;
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
		  SW_C => SW_C,
          Enable => Enable,
          CLK => CLK,
          sum => FILTER_OUT
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
        ENABLE => ENABLE_OUT,
        RESET => RESET,
        I_WIDTH => I_WIDTH,
        I_HEIGH => I_HEIGH,
        DIN => FILTER_OUT,
        THRESHSIZE => THRESHSIZE,
        DOUT => DOUT ,
 
        -- Control Signals
        READY    => READY,
        DONE     => DONE,
        F2_START => F2_START,
        FN_END   => FN_END--;
    );


	enabler: controller_enabler PORT MAP(
		ENABLE => ENABLE,
		CLK => CLK,
		RESET => RESET,
		ENABLE_OUT => ENABLE_OUT
	);

end filter_top_i;

