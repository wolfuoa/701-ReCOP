-- recop_pc.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.various_constants.all;

entity pc is
    generic (
        START_ADDR : std_logic_vector(15 downto 0) := (others => '0')
    );
    port (
        clock : in std_logic;
        reset : in std_logic;
        write_enable : in std_logic;
        -- see various_constants.vhd for options for this input
        pc_input_select : in std_logic;
        jump_address : in std_logic_vector(15 downto 0);
        alu_out : in std_logic_vector(15 downto 0);

        pc : out std_logic_vector(15 downto 0)
    );
end pc;

architecture arch of pc is
    signal pc_internal : std_logic_vector(15 downto 0) := START_ADDR;
begin

    pc <= pc_internal;

    process (clock)
    begin
        if reset = '1' then
            pc_internal <= START_ADDR;
        elsif rising_edge(clock) then
            if write_enable = '1' then
                case pc_input_select is
                    when pc_input_select_aluout => pc_internal <= alu_out;
                    when pc_input_select_jmp => pc_internal <= jump_address;
                end case;
            end if;
        end if;
    end process;

end architecture; -- arch