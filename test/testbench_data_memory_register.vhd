library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity testbench_data_memory_register is
end testbench_data_memory_register;

architecture arch of testbench_data_memory_register is
    signal t_clock        : std_logic;
    signal t_reset        : std_logic;
    signal t_write_enable : std_logic;

    signal t_data_out     : std_logic_vector(15 downto 0);

    signal t_input_select : std_logic_vector(1 downto 0);
    signal t_immediate    : std_logic_vector(15 downto 0);
    signal t_alu_out      : std_logic_vector(15 downto 0);
    signal t_rx           : std_logic_vector(15 downto 0);

begin

    dut : entity work.data_memory_register
        port map(
            clock        => t_clock,
            reset        => t_reset,
            write_enable => t_write_enable,
            input_select => t_input_select,
            immediate    => t_immediate,
            alu_out      => t_alu_out,
            rx           => t_rx,

            data_out     => t_data_out
        );

    process
    begin
        wait for 20 ns;
        t_write_enable <= '1';
        t_input_select <= "00";
        t_immediate    <= x"ABBA";
        t_alu_out      <= x"BAAB";
        t_rx           <= x"CEEC";
        wait for 20 ns;
        t_write_enable <= '0';
        t_input_select <= "01";
        t_immediate    <= x"ABBA";
        t_alu_out      <= x"BAAB";
        t_rx           <= x"CEEC";
        wait for 20 ns;
        t_write_enable <= '1';
        wait for 20 ns;
        t_input_select <= "10";
        t_immediate    <= x"ABBA";
        t_alu_out      <= x"BAAB";
        t_rx           <= x"CEEC";
    end process;

    process
    begin
        t_clock <= '1';
        wait for 10 ns;
        t_clock <= '0';
        wait for 10 ns;
    end process;

    -- Initialise
    process
    begin
        t_reset <= '1';
        wait for 20 ns;
        t_reset <= '0';
        wait;
    end process;

end arch;