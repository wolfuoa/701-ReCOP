library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_memory_register is
   port (
      clock : in std_logic;
      reset : in std_logic;
      write_enable : in std_logic;

      data_in : in std_logic_vector(15 downto 0);
      data_out : out std_logic_vector(15 downto 0)
   );
end data_memory_register;

architecture arch of data_memory_register is

   signal next_data : std_logic_vector(15 downto 0) := (others => '0');

begin

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