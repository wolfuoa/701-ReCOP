library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity testbench_operand_register is
end testbench_operand_register;

architecture arch of testbench_operand_register is
    signal t_clock : std_logic;
    signal t_reset : std_logic;
    signal t_write_enable : std_logic;

    signal t_data_in : std_logic_vector(3 downto 0);
    signal t_data_out : std_logic_vector(3 downto 0);
    
begin
    operand_register_inst: entity work.operand_register
     port map(
        clock => t_clock,
        reset => t_reset,
        write_enable => t_write_enable,
        data_in => t_data_in,
        data_out => t_data_out
    );

    process
    begin
        wait for 20 ns;
        t_write_enable <= '1';
        t_data_in <= x"A";
        wait for 20 ns;
        t_write_enable <= '0';
        t_data_in <= x"B";
        wait for 10 ns;
        t_data_in <= x"C";
        wait for 10 ns;
        t_write_enable <= '1';
        wait for 20 ns;
        t_data_in <= x"9";
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