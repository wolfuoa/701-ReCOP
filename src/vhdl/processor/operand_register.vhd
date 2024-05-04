library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity operand_register is
  port (
    clock : in std_logic;
    reset : in std_logic;
    write_enable : in std_logic;

    data_in : in std_logic_vector(3 downto 0);
    data_out : out std_logic_vector(3 downto 0)
  );
end operand_register;

architecture arch of operand_register is

signal next_data : std_logic_vector(3 downto 0) := (others => '0');

begin

process(clock)
BEGIN
if reset = '1' then
    next_data <= (others => '0');
elsif rising_edge(clock) then
    if write_enable = '1' then
        next_data <= data_in;
    end if;
end if;
end process;

data_out <= next_data;

end architecture ; -- arch