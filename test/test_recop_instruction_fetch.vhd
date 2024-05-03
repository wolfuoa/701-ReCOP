library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity testbench_recop_instruction_fetch is
end testbench_recop_instruction_fetch;

architecture arch of testbench_recop_instruction_fetch is
    signal t_clk      : std_logic;
    signal t_wren     : std_logic;
    signal t_reset    : std_logic;

    signal t_addr_new : std_logic_vector(15 downto 0);
    signal t_out_addr : std_logic_vector(15 downto 0);
begin

    dut : pc port map(
        clock    => t_clk,
        reset    => t_reset,
        wren     => t_wren,
        addr_new => t_addr_new,
        out_addr => t_out_addr
    );

    process
    begin

        wait for 100 ns;
        t_addr_new <= x"0f0f";
        wait for 100 ns;
        t_addr_new <= x"7ea5";
        wait for 100 ns;
        t_addr_new <= x"6432";
        wait for 100 ns;
        t_addr_new <= x"dead";
        wait for 100 ns;
        t_addr_new <= x"beef";
        wait for 100 ns;
        t_addr_new <= x"badd";
        wait for 100 ns;
        t_addr_new <= x"bead";
        wait for 100 ns;
        t_addr_new <= x"9a2b";

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