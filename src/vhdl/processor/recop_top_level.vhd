

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

entity toplevel is
    port (
        clock   : in  std_logic;
        reset : in std_logic;
        enable : in std_logic;

        -- External Signal I/O
        sop   : out std_logic_vector(15 downto 0);
        sip   : in  std_logic_vector(15 downto 0)
    );
end toplevel;

architecture bhv of toplevel is
begin


end bhv;