library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_memory_register is
    port
    (
        clock        : in  std_logic;
        reset        : in  std_logic;
        write_enable : in  std_logic;

        -- 2 bit multiplexer
        input_select : in  std_logic_vector(1 downto 0);
        immediate    : in  std_logic_vector(15 downto 0);
        alu_out      : in  std_logic_vector(15 downto 0);
        rx           : in  std_logic_vector(15 downto 0);

        data_out     : out std_logic_vector(15 downto 0)
    );
end data_memory_register;

architecture arch of data_memory_register is

    signal next_data : std_logic_vector(15 downto 0) := (others => '0');
    signal data_in   : std_logic_vector(15 downto 0) := (others => '0');

begin

    with input_select select data_in <=
                                       immediate when "00",
                                       alu_out when "01",
                                       rx when "10",
                                       x"0000" when others;

    process (clock)
    begin
        if reset = '1' then
            next_data <= (others => '0');
        elsif rising_edge(clock) then
            if write_enable = '1' then
                next_data <= data_in;
            end if;
        end if;
    end process;

    data_out <= next_data;

end architecture; -- arch