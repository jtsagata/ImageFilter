LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constants.ALL;

entity zipper is
    Port (
        Enable : IN STD_LOGIC;
        CLK :    IN STD_LOGIC;
        
		DIVIDER : IN std_logic_vector(1 DOWNTO 0);
        INPUT  : IN  signed(MRESULT DOWNTO 0);
        OUTPUT : OUT std_logic_vector(UBIT DOWNTO 0) --;
    
    );
end zipper;

architecture z_impl of zipper is
begin
    PROCESS (Enable, CLK, INPUT)
		variable INPUT_VECTOR  : std_logic_vector(MRESULT DOWNTO 0);
		variable INPUT_SHIFTED : unsigned(MRESULT DOWNTO 0);		
    BEGIN		
        IF (CLK'EVENT AND CLK = '1') THEN	
			IF (Enable = '1') THEN
				CASE DIVIDER IS
					WHEN "10" =>
						-- sum=8, 2^3 average
						INPUT_SHIFTED := unsigned(INPUT);
						INPUT_SHIFTED := shift_right(unsigned(INPUT_SHIFTED), 3);
						INPUT_VECTOR  := std_logic_vector(INPUT_SHIFTED);
					WHEN "01" =>
						-- sum=16, 2^4 gausian
						INPUT_SHIFTED := unsigned(INPUT);
						INPUT_SHIFTED := shift_right(unsigned(INPUT_SHIFTED), 4);
						INPUT_VECTOR  := std_logic_vector(INPUT_SHIFTED);
					WHEN others =>
						INPUT_VECTOR := std_logic_vector(INPUT);
				END CASE;
				
				IF INPUT < 0 THEN
                    OUTPUT <= (others => '0');
                ELSIF INPUT > 255 THEN 
                    OUTPUT <= (others => '1');
                ELSE
                    OUTPUT <= INPUT_VECTOR(UBIT DOWNTO 0);
                END IF;
            END IF; --Enable
        END IF; -- CLK'EVENT
    END PROCESS;

end z_impl;

