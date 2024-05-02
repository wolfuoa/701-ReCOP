

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

USE work.recop_types.ALL;
USE work.opcodes.ALL;
USE work.various_constants.ALL;

ENTITY recop_top_level IS
    PORT (
        clk   : IN  bit_1;
        reset : IN  bit_1;

        -- External Enable Signal
        ER    : IN  STD_LOGIC;

        -- External Signal I/O
        SOP   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIP   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

        -- Communication with NOC
        DPCR  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        DPR   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- Signal Transmission Done
        EOT   : OUT STD_LOGIC;

    );
END recop_top_level;

ARCHITECTURE bhv OF recop_top_level IS

    SIGNAL PC                  : STD_LOGIC_VECTOR(14 DOWNTO 0);
    SIGNAL SR                  : STD_LOGIC;
    SIGNAL instruction         : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL instruction_fetched : STD_LOGIC;

    COMPONENT prog_mem IS
        PORT (
            address : IN  STD_LOGIC_VECTOR (14 DOWNTO 0);
            clock   : IN  STD_LOGIC := '1';
            q       : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END COMPONENT;

    -- COMPONENT recop_data_path IS
    --     PORT MAP(

    --     );
    -- END COMPONENT;

    -- COMPONENT recop_control_unit IS
    --     PORT MAP(

    --     );
    -- END COMPONENT;

    COMPONENT second_cycle IS
        PORT MAP(
            clk => clk,
            reset  : IN  STD_LOGIC;
            enable : IN  STD_LOGIC;
            q      : OUT STD_LOGIC;
        );
    END COMPONENT;
BEGIN

    instruction_memory : prog_mem PORT MAP(
        address => PC,
        clock   => clk,
        q       => instruction
    );

    cycle_counter : second_cycle PORT MAP(
        clk    => clk,
        reset  => reset,
        enable => "1",
        q      => instruction_fetched
    );

    PROCESS
    BEGIN
        IF (rising_edge(clk)) THEN
            PC <= PC + 1;
        END IF;
    END PROCESS;

END bhv;