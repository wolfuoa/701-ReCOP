library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment is
    port (
        input_digit : in  std_logic_vector(3 downto 0);
        sseg_output : out std_logic_vector(6 downto 0)
    );
end entity;

architecture behaviour of seven_segment is
    type digits is array (0 to 15) of std_logic_vector(6 downto 0);
    constant sseg_converted : digits := ("1000000",
                                        "1111001",
                                        "0100100",
                                        "0110000",
                                        "0011001",
                                        "0010010",
                                        "0000010",
                                        "1111000",
                                        "0000000",
                                        "0010000",
                                        "0001000",
                                        "0000011",
                                        "1000110",
                                        "0100001",
                                        "0000110",
                                        "0001110"
                                        );
begin
    sseg_output <= sseg_converted(to_integer(unsigned(input_digit)));
end architecture;