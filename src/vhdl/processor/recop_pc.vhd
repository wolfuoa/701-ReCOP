-- recop_pc.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY pc IS
    PORT (
        clock           : IN  STD_LOGIC;
        reset           : IN  STD_LOGIC;

        wren            : IN  STD_LOGIC;
        -- 0 = internal incrementer, 1 = jmp_address TODO: define as constants somewhere
        pc_input_select : IN STD_LOGIC;

        jmp_address     : IN STD_LOGIC_VECTOR(15 downto 0);
        pc              : OUT STD_LOGIC_VECTOR(15 downto 0)
    );
END pc;

ARCHITECTURE arch OF pc IS
    SIGNAL addr_new_temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal pc_plus_2 : std_logic_vector(15 downto 0);
BEGIN

    PROCESS (clock)
        VARIABLE next_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF reset = '1' THEN
            next_addr := (others => '0');
        ELSIF rising_edge(clock) THEN
            IF wren = '1' THEN
                next_addr := addr_new_temp;
            ELSE
                next_addr := next_addr;
            END IF;
        END IF;
        out_addr <= next_addr;
    END PROCESS;
END ARCHITECTURE; -- arch