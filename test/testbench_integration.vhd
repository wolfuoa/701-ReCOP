library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_integration is
end entity;

architecture test of testbench_integration is
    signal t_clock             : std_logic;
    signal t_enable            : std_logic := '1';
    signal t_dprr              : std_logic_vector(31 downto 0);
    signal t_sip_data_in       : std_logic_vector(15 downto 0);
    signal t_reset             : std_logic;
    signal t_dpcr_data_out     : std_logic_vector(31 downto 0);
    signal t_sop_data_out      : std_logic_vector(15 downto 0);
    signal t_state_decode_fail : std_logic;

begin

    top_level_inst : entity work.top_level
        generic map(
            program_file_path => "C:\Users\AKLbc\Desktop\Development\701-ReCOP\src\programs\loop.mif"
        )
        port map(
            clock             => t_clock,
            enable            => t_enable,
            dprr              => t_dprr,
            sip_data_in       => t_sip_data_in,
            reset             => t_reset,
            dpcr_data_out     => t_dpcr_data_out,
            sop_data_out      => t_sop_data_out,
            state_decode_fail => t_state_decode_fail
        );

    INIT : process
    begin
        t_reset <= '1';
        wait for 20 ns;
        t_reset <= '0';
        wait;
    end process;

    CLOCK : process
    begin
        t_clock <= '1';
        wait for 10 ns;
        t_clock <= '0';
        wait for 10 ns;
    end process;
end architecture;