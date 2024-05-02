-- recop_pc.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY pc IS
    PORT (
        clock    : IN  STD_LOGIC;
        reset    : IN  STD_LOGIC;

        -- Control Signals
        wren     : IN  STD_LOGIC;

        -- Data Signals
        addr_new : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END pc;

ARCHITECTURE arch OF pc IS

    SIGNAL addr_new_temp : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    addr_new_temp <= addr_new;

    PROCESS (clock)
        VARIABLE next_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF rising_edge(clock) THEN
            IF wren = '1' THEN
                next_addr := addr_new_temp;
            ELSE
                next_addr := next_addr;
            END IF;
            IF reset = '1' THEN
                next_addr := (OTHERS => '0');
            END IF;

        END IF;
        out_addr <= next_addr;
    END PROCESS;
END ARCHITECTURE; -- arch