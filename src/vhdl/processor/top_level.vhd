library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.mux_select_constants.all;

entity top_level is
    port (
        clock : in std_logic;
        reset : in std_logic;
        enable : in std_logic;

        -- External Signal I/O
        sop : out std_logic_vector(15 downto 0);
        sip : in std_logic_vector(15 downto 0)
    );
end top_level;

architecture bhv of top_level is
begin
end bhv;