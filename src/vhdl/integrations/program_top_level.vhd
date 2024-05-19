library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.file_paths;

entity program_top_level is
    port (
        CLOCK_50 : in  std_logic;
        SW       : in  std_logic_vector(9 downto 0);
        LEDG     : out std_logic_vector(8 downto 0);
        LEDR     : out std_logic_vector(17 downto 0);
        KEY      : in  std_logic_vector(3 downto 0);

        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0);
        HEX3     : out std_logic_vector(6 downto 0)
    );
end entity;

architecture b of program_top_level is
    signal reset            : std_logic;
    signal sop_data_out     : std_logic_vector(15 downto 0);
    signal dpcr_data_out    : std_logic_vector(31 downto 0);
    signal unblock_datacall : std_logic;
begin
    reset <= not KEY(0);
    -- unblock_datacall <= not KEY(1);

    LEDG  <= dpcr_data_out(8 downto 0);
    LEDR  <= dpcr_data_out(31 downto 15);

    top_level_inst : entity work.top_level
        generic map(
            program_file_path => file_paths.calculator_program
        )
        port map(
            clock                   => CLOCK_50,
            enable                  => '1',
            dprr(1)                 => unblock_datacall,
            sip_data_in(9 downto 0) => SW,
            reset                   => reset,
            dpcr_data_out           => dpcr_data_out,
            sop_data_out            => sop_data_out,
            state_decode_fail       => open
        );

    sseg_0 : entity work.seven_segment
        port map(
            input_digit => sop_data_out(3 downto 0),
            sseg_output => HEX0
        );

    sseg_1 : entity work.seven_segment
        port map(
            input_digit => sop_data_out(7 downto 4),
            sseg_output => HEX1
        );

    sseg_2 : entity work.seven_segment
        port map(
            input_digit => sop_data_out(11 downto 8),
            sseg_output => HEX2
        );

    sseg_3 : entity work.seven_segment
        port map(
            input_digit => sop_data_out(15 downto 12),
            sseg_output => HEX3
        );

    process (CLOCK_50)
        variable edge : std_logic;
    begin
        if rising_edge(CLOCK_50) then
            if KEY(1) = '0' and edge = '1' then
                unblock_datacall <= '1';
            else
                unblock_datacall <= '0';
            end if;
            edge := KEY(1);
        end if;
    end process;

end architecture;