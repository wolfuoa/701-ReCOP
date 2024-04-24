

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

USE work.recop_types.ALL;
USE work.opcodes.ALL;
USE work.various_constants.ALL;

ENTITY recop_control_unit IS
    PORT (
        clk    : IN  bit_1;
        packet : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        reset  : IN  bit_1

        -- External Signal I/O
        SOP    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIP    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    );
END recop_control_unit;

ARCHITECTURE bhv OF recop_control_unit IS

END bhv;