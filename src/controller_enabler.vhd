LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

entity controller_enabler is
    Port ( ENABLE : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
		   RESET : in  STD_LOGIC;
           ENABLE_OUT : out  STD_LOGIC--;
    );
end controller_enabler;

architecture Behavioral of controller_enabler is
	signal buffer1, buffer2, buffer3, buffer4 : STD_LOGIC;
	signal buffer5, buffer6, buffer7, buffer8 : STD_LOGIC;
begin
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
				buffer5 <= buffer4;
				buffer6 <= buffer5;
				buffer7 <= buffer6;
				buffer8 <= buffer7;
				ENABLE_OUT <= buffer8;
            end if;
        end if;
    end process; 

end Behavioral;

