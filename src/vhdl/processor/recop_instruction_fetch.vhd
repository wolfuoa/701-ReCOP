-- recop_pc.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity instruction_fetcher is
    generic (
        START_ADDR: std_logic_vector(15 downto 0)
    );
    port (
        clock: in std_logic;
        enable: in std_logic;

        pc: in std_logic_vector(15 downto 0);

        program_mem_addr: out std_logic_vector(15 downto 0);
        program_mem_data: in std_logic_vector(15 downto 0);

        instruction_valid: out std_logic;
        instruction: out std_logic_vector(31 downto 0)
    );
end instruction_fetcher;

architecture arch of instruction_fetcher is
    signal lower_instruction_word: std_logic_vector(15 downto 0);
begin
    program_mem_addr <= pc;
    -- Little endian system
    instruction <= program_mem_data(7 downto 0) & program_mem_data(15 downto 8) & lower_instruction_word;
    
    -- The instruction is only valid once we have read a full 4 bytes of data.
    -- This means that while the 2s place of the instruction is set we are not in a valid
    -- instruction location.
    instruction_valid <= pc(1);

    -- Little endian systems have the lowest bytes at the lowest address
    lower_byte_load: process(clock)
    begin
        if rising_edge(clock) then
            if pc(1) = '0' and enable = '1' then
                lower_instruction_word <= program_mem_data(7 downto 0) & program_mem_data(15 downto 8);
            end if;
        end if;
    end process;


end architecture; -- arch