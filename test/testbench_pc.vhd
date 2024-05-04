library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity testbench_recop_pc is
    port (
        signal pc : out std_logic_vector(15 downto 0)
    );
end testbench_recop_pc;

architecture arch of testbench_recop_pc is
    signal t_clock : std_logic := '0';
    signal t_write_enable : std_logic := '0';
    signal t_reset : std_logic := '0';
    signal t_pc_input_select : std_logic := '0';

    signal jump_address : std_logic_vector(15 downto 0);
    signal alu_out : std_logic_vector(15 downto 0);
begin

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

    process
    begin
        t_clock <= '1';
        wait for 10 ns;
    end process;

end arch; -- testbench_recop_pc