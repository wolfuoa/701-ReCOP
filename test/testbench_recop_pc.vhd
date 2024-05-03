library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity testbench_recop_pc is
end testbench_recop_pc;

architecture arch of testbench_recop_pc is
    signal t_clk             : std_logic;
    signal t_wren            : std_logic;
    signal t_reset           : std_logic;
    signal t_pc_input_select : std_logic := '0';

    signal t_addr_new        : std_logic_vector(15 downto 0);
    signal t_out_addr        : std_logic_vector(15 downto 0);

begin

    DUT : entity work.pc port map(
        clock           => t_clk,
        reset           => t_reset,
        enable          => t_wren,
        pc_input_select => t_pc_input_select,
        jmp_address     => t_addr_new,
        pc              => t_out_addr
        );

    process
    begin

        wait for 1000 ns;
        t_addr_new        <= x"0F0F";
        t_pc_input_select <= '1';
        wait for 100 ns;
        t_pc_input_select <= '0';
        wait for 100 ns;
        t_pc_input_select <= '1';
        t_addr_new        <= x"7EA5";
        wait for 100 ns;
        t_addr_new <= x"6432";
        wait for 1000 ns;
        t_addr_new <= x"DEAD";
        wait for 100 ns;
        t_addr_new <= x"BEEF";
        wait for 100 ns;
        t_addr_new <= x"BADD";
        wait for 100 ns;
        t_addr_new <= x"BEAD";
        wait for 100 ns;
        t_addr_new <= x"9A2B";

    end process;

    process
    begin
        t_reset <= '1';
        wait for 10 ns;
        t_reset <= '0';
        wait;
    end process;

    process
    begin
        t_wren <= '0';
        wait for 10 ns;
        t_wren <= '1';
        wait for 200 ns;
        t_wren <= '0';
        wait for 100 ns;
        t_wren <= '1';
        wait;
    end process;

    process
    begin
        t_clk <= '1';
        wait for 10 ns;
        t_clk <= '0';
        wait for 10 ns;
    end process;
end arch; -- testbench_recop_pc