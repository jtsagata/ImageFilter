LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;


entity fifo_buffer_3 is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           DIN : in  STD_LOGIC_VECTOR (UBIT downto 0);
           
           DOUT : out  STD_LOGIC_VECTOR (UBIT downto 0);
           DA : out  STD_LOGIC_VECTOR (UBIT downto 0);
           DB : out  STD_LOGIC_VECTOR (UBIT downto 0);
           DC : out  STD_LOGIC_VECTOR (UBIT downto 0);
           READY : out  STD_LOGIC);
end fifo_buffer_3;

architecture Behavioral of fifo_buffer_3 is
signal delay1, delay2, delay3, delay4 : STD_LOGIC_VECTOR (UBIT downto 0);
signal buffer1, buffer2, buffer3, buffer4 : STD_LOGIC;
signal ready_signal : STD_LOGIC := '1';

begin

    --
    -- Propagete numbers
    -- 
    p1: process(CLK,RESET)
    begin
        if RESET = '1' then
            delay1 <= x"00";  delay2 <= x"00";
            delay3 <= x"00";  delay4 <= x"00"; 
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                delay1 <= DIN;
                delay2 <= delay1;
                delay3 <= delay2;
                delay4 <= delay3;
            end if;
        end if;
    end process;
     
    -- Wire connections
    DOUT <= delay4;
    DA <= delay1;
    DB <= delay2;
    DC <= delay3;
    READY <= buffer4;    

    --
    -- Get READY signal
    -- 
    p2: process(CLK,RESET)
    begin
        if RESET = '1' then
            buffer1 <= '0';    buffer2 <= '0';
            buffer3 <= '0';    buffer4 <= '0'; 
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                buffer1 <= '1';
                buffer2 <= buffer1;
                buffer3 <= buffer2;
                buffer4 <= buffer3;
            end if;
        end if;
    end process;     
end Behavioral;

