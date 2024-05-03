-- recop_pc.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity pc is
    generic (
        START_ADDR : std_logic_vector(15 downto 0) := (others => '0')
    );
    port (
        clock           : in  std_logic;
        reset           : in  std_logic;

        enable          : in  std_logic;
        -- 0 = internal incrementer, 1 = jmp_address TODO: define as constants somewhere
        pc_input_select : in  std_logic;

        jmp_address     : in  std_logic_vector(15 downto 0);
        pc              : out std_logic_vector(15 downto 0)
    );
end pc;

architecture arch of pc is
    signal pc_internal : std_logic_vector(15 downto 0) := START_ADDR;
    signal pc_plus_1   : std_logic_vector(15 downto 0);
begin

    pc_plus_1 <= pc_internal + 1;
    pc        <= pc_internal;

    process (clock)
    begin
        if reset = '1' then
            pc_internal <= START_ADDR;
        elsif rising_edge(clock) then
            if enable = '1' then
                case pc_input_select is
                    when '1'    => pc_internal    <= jmp_address;
                    when others => pc_internal    <= pc_plus_1;
                end case;
            end if;
        end if;
    end process;

end architecture; -- arch