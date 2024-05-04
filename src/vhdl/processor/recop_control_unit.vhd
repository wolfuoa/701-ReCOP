library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

entity recop_control_unit is
    port (
        clk : in bit_1;
        packet : in STD_LOGIC_VECTOR(31 downto 0);
        reset : in bit_1;

        -- External Signal I/O  
        SOP : out STD_LOGIC_VECTOR(15 downto 0);
        SIP : in STD_LOGIC_VECTOR(15 downto 0)

    );
end recop_control_unit;

architecture bhv of recop_control_unit is

begin

end bhv;