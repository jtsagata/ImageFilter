LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;


entity cache_mem is
    Port ( CLK : in  STD_LOGIC;
        ENABLE : in  STD_LOGIC;
        RESET : IN std_logic;
        DIN : in  STD_LOGIC_VECTOR (UBIT downto 0);
        prog_full_thresh : IN STD_LOGIC_VECTOR(PRG_FULL_CONST DOWNTO 0);
        P1 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        P2 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        P3 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        P4 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        P5 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        P6 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        P7 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        P8 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        P9 : out  STD_LOGIC_VECTOR (UBIT downto 0);
        READY : OUT std_logic
    );
end cache_mem;

architecture cache_mem_impl of cache_mem is

signal connect1,connect2,connect3 : std_logic_vector(7 downto 0);
signal fifo_enable1,fifo_enable2: std_logic;
signal fifo_read_enable1,fifo_read_enable2,fifo_read_enable3: std_logic;
signal fifo_out1,fifo_out2 : std_logic_vector(7 downto 0);

signal READY_SIGNAL: std_logic;

COMPONENT fifo_buffer_3
PORT(
    CLK : IN std_logic;
    RESET : IN std_logic;
    ENABLE : IN std_logic;
    DIN : IN std_logic_vector(7 downto 0); 
    DOUT : OUT std_logic_vector(7 downto 0);
    DA : OUT std_logic_vector(7 downto 0);
    DB : OUT std_logic_vector(7 downto 0);
    DC : OUT std_logic_vector(7 downto 0);
    READY : OUT std_logic
);
END COMPONENT;

COMPONENT fifo_core
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    prog_full_thresh : IN STD_LOGIC_VECTOR(PRG_FULL_CONST DOWNTO 0);
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC
  );
END COMPONENT;

begin

	READY <= READY_SIGNAL;

    buffer_1: fifo_buffer_3 PORT MAP(
        CLK => CLK,
        RESET => RESET,
        ENABLE => ENABLE,
        DIN => DIN,
        DOUT => connect1,
        DA => P9,
        DB => P8,
        DC => P7,
        READY => fifo_enable1
    );

    fifo1 : fifo_core PORT MAP (
        clk => clk,
        rst => RESET,
        din => connect1,
        wr_en => fifo_enable1,
        rd_en => fifo_read_enable1,
        prog_full_thresh => prog_full_thresh,
        dout => fifo_out1,
        full => open,
        empty => open,
        prog_full => fifo_read_enable1
    );

    buffer_2: fifo_buffer_3 PORT MAP(
        CLK => CLK,
        RESET => RESET,
        ENABLE => fifo_read_enable1,
        DIN => fifo_out1,
        DOUT => connect2,
        DA => P6,
        DB => P5,
        DC => P4,
        READY => fifo_enable2
    );

    fifo2 : fifo_core PORT MAP (
        clk => clk,
        rst => RESET,
        din => connect2,
        wr_en => fifo_enable2,
        rd_en => fifo_read_enable2,
        prog_full_thresh => prog_full_thresh,
        dout => fifo_out2,
        full => open,
        empty => open,
        prog_full => fifo_read_enable2
    );

    buffer_3: fifo_buffer_3 PORT MAP(
        CLK => CLK,
        RESET => RESET,
        ENABLE => fifo_read_enable2,
        DIN => fifo_out2,
        DOUT => connect3,
        DA => P3,
        DB => P2,
        DC => P1,
        READY => open
        --READY => READY_SIGNAL
    );
end cache_mem_impl;