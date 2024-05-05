library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity data_memory is
   port (
      clock : in std_logic;
      reset : in std_logic;
      data : in std_logic_vector (15 downto 0);
      write_enable : in std_logic;

      address : in std_logic_vector (11 downto 0);
      q : out std_logic_vector (15 downto 0)

   );
end data_memory;

architecture arch of data_memory is

begin

end architecture; -- arch