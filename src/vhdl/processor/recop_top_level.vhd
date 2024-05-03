

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

entity recop_top_level is
    port (
        clk   : in  bit_1;
        reset : in  bit_1;

        -- External Enable Signal
        ER    : in  std_logic;

        -- External Signal I/O
        SOP   : out std_logic_vector(15 downto 0);
        SIP   : in  std_logic_vector(15 downto 0);

        -- Communication with NOC
        DPCR  : out std_logic_vector(31 downto 0);
        DPR   : in  std_logic_vector(31 downto 0);

        -- Signal Transmission Done
        EOT   : out std_logic;

    );
end recop_top_level;

architecture bhv of recop_top_level is

    signal PC                  : std_logic_vector(14 downto 0);
    signal SR                  : std_logic;
    signal instruction         : std_logic_vector(15 downto 0);
    signal reset               : std_logic;
    signal wren                : std_logic := '1';

    -- Control unit later
    signal PC_input_select     : std_logic;

    signal instruction_fetched : std_logic;

    -- component prog_mem is
    --     port (
    --         address : in  std_logic_vector (14 downto 0);
    --         clock   : in  std_logic := '1';
    --         q       : out std_logic_vector (15 downto 0)
    --     );
    -- end component;

    -- COMPONENT recop_data_path IS
    --     PORT MAP(

    --     );
    -- END COMPONENT;

    -- COMPONENT recop_control_unit IS
    --     PORT MAP(

    --     );
    -- END COMPONENT;

    -- COMPONENT second_cycle IS
    --     PORT MAP(
    --         clk => clk,
    --         reset  : IN  STD_LOGIC;
    --         enable : IN  STD_LOGIC;
    --         q      : OUT STD_LOGIC;
    --     );
    -- END COMPONENT;
begin

    instruction_memory : entity work.prog_mem port map(
        address => PC,
        clock   => clk,
        q       => instruction
        );

    program_counter : entity work.pc port map(
        clock           => clk,
        reset           => reset,
        wren            => wren,
        pc_input_select => PC_input_select,

        jmp_address = >,
        pc => PC
        );

    -- cycle_counter : second_cycle port map(
    --     clk    => clk,
    --     reset  => reset,
    --     enable => "1",
    --     q      => instruction_fetched
    -- );

    process
    begin
        if (rising_edge(clk)) then
            PC <= PC + 1;
        end if;
    end process;

end bhv;