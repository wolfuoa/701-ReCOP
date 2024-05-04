library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity testbench_pc is
    port (
        signal out_pc : out std_logic_vector(15 downto 0);
        signal valid : out boolean
    );
end testbench_pc;

architecture arch of testbench_pc is
    signal t_clock : std_logic := '0';
    signal t_write_enable : std_logic := '0';
    signal t_reset : std_logic := '0';
    signal t_pc_input_select : std_logic := '0';

    signal jump_address : std_logic_vector(15 downto 0);
    signal alu_out : std_logic_vector(15 downto 0);
    signal pc : std_logic_vector(15 downto 0);
begin

    out_pc <= pc;

    DUT : entity work.pc
        port map(
            clock => t_clock,
            reset => t_reset,
            write_enable => t_write_enable,
            pc_input_select => t_pc_input_select,
            jump_address => jump_address,
            alu_out => alu_out,
            pc => pc
        );

    CLOCK : process
    begin
        wait for 10 ns;
        t_clock <= '1';
        wait for 10 ns;
        t_clock <= '0';
    end process;

    process
    begin
        t_pc_input_select <= '0';
        alu_out <= x"BEEF";
        t_write_enable <= '1';
        wait until rising_edge(t_clock);
        wait for 0 ns;
        valid <= pc = x"BEEF";

        t_pc_input_select <= '1';
        jump_address <= x"B00B";
        t_write_enable <= '1';
        wait until rising_edge(t_clock);
        wait for 0 ns;
        valid <= pc = x"B00B";

        t_pc_input_select <= '0';
        alu_out <= x"F00D";
        t_write_enable <= '0';
        wait until rising_edge(t_clock);
        wait for 0 ns;
        valid <= pc = x"B00B";

        t_reset <= '1';
        wait until rising_edge(t_clock);
        wait for 0 ns;
        valid <= pc = x"0000";

        wait;
            
    end process;

end arch; -- testbench_recop_pc