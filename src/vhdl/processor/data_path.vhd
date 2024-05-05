library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types;
use work.opcodes;
use work.mux_select_constants;

entity data_path is
    port (
    clock  : in std_logic;
    packet : in std_logic_vector(31 downto 0);
    reset  : in std_logic;
    port (
        clock                             : in  std_logic;
        packet                            : in  std_logic_vector(31 downto 0);
        reset                             : in  std_logic;

        -- Control unit inputs
        pc_input_select                   : in  std_logic;
        pc_write_enable                   : in  std_logic;
        pc_branch_conditional             : in  std_logic;

        jump_select                       : in  std_logic;

        instruction_register_write_enable : in  std_logic;
        rz_register_write_enable          : in  std_logic;
        rx_register_write_enable          : in  std_logic;
        alu_register_write_enable         : in  std_logic;
        mdr_write_enable                  : in  std_logic;
        z_register_write_enable           : in  std_logic;

        -- Outputs for the control unit
        addressing_mode                   : out std_logic_vector(1 downto 0);
        opcode                            : out std_logic_vector(5 downto 0)
    );
end entity;

-- 

architecture bhv of data_path is
    signal jump_address           : std_logic_vector(15 downto 0);
    signal alu_out                : std_logic_vector(15 downto 0);

    signal pc                     : std_logic_vector(15 downto 0);
    signal pc_write               : std_logic;

    signal instruction            : std_logic_vector(31 downto 0);
    signal rz_index               : std_logic_vector(3 downto 0);
    signal rx_index               : std_logic_vector(3 downto 0);
    signal immediate              : std_logic_vector(15 downto 0);
    signal instruction            : std_logic_vector(31 downto 0);
    signal rz_index               : std_logic_vector(3 downto 0);
    signal rx_index               : std_logic_vector(3 downto 0);
    signal immediate              : std_logic_vector(15 downto 0);

    signal rz_register_value_in   : std_logic_vector(15 downto 0);
    signal rx_register_value_in   : std_logic_vector(15 downto 0);
    signal rz_register_value_in   : std_logic_vector(15 downto 0);
    signal rx_register_value_in   : std_logic_vector(15 downto 0);

    signal rz_register_value_out  : std_logic_vector(15 downto 0);
    signal rx_register_value_out  : std_logic_vector(15 downto 0);
    signal rz_register_value_out  : std_logic_vector(15 downto 0);
    signal rx_register_value_out  : std_logic_vector(15 downto 0);

    signal alu_register_value_in  : std_logic_vector(15 downto 0);
    signal alu_register_value_out : std_logic_vector(15 downto 0);
    signal alu_register_value_in  : std_logic_vector(15 downto 0);
    signal alu_register_value_out : std_logic_vector(15 downto 0);

    signal mdr_value_in           : std_logic_vector(15 downto 0);
    signal mdr_value_out          : std_logic_vector(15 downto 0);
    signal mdr_value_in           : std_logic_vector(15 downto 0);
    signal mdr_value_out          : std_logic_vector(15 downto 0);

    signal z_register_value_in    : std_logic_vector(0 downto 0);
    signal z_register_value_out   : std_logic_vector(0 downto 0);
    signal z_register_value_in    : std_logic_vector(0 downto 0);
    signal z_register_value_out   : std_logic_vector(0 downto 0);

begin

    -- Calculate jump address
    with jump_select select jump_address <=
                                           rx_register_value_out when '1',
                                           immediate when '0';

    pc_write                             <= (z_register_value_out(0) and pc_branch_conditional) or pc_write_enable;

    -- Calculate jump address
    with jump_select select jump_address <=
                                           rx_register_value_out when '1',
                                           immediate when '0';

    pc_write <= (z_register_value_out and pc_branch_conditional) or pc_write_enable;

    pc_inst : entity work.pc
        generic map(
            START_ADDR => (others => '0')
        )
        port map(
            clock           => clock,
            reset           => reset,
            write_enable    => pc_write, -- Needs to be different from the input port one
            pc_input_select => pc_input_select,
            jump_address    => jump_address,
            alu_out         => alu_out,
            pc              => pc
        );

    prog_mem_inst : entity work.prog_mem
        port map(
            address => pc,
            clock   => clock,
            q       => instruction
        );
    prog_mem_inst : entity work.prog_mem
        port map(
            address => pc,
            clock   => clock,
            q       => instruction
        );

    instruction_register_inst : entity work.instruction_register
        port map(
            clock           => clock,
            reset           => reset,
            write_enable    => instruction_register_write_enable,
            instruction     => instruction,
            addressing_mode => addressing_mode,
            opcode          => opcode,
            rz              => rz_index,
            rx              => rx_index,
            immediate       => immediate
        );
    -- Register file
    register_file : entity work.register_file
        port map(
            clock                 => clock,
            reset                 => reset,
            write_enable          => write_enable,
            rz_index              => rz_index,
            rx_index              => rx_index,
            rz_select             => rz_select,
            register_write_select => register_write_select,
            immediate             => immediate,
            data_memory           => data_memory,
            alu_out               => alu_out,
            sip                   => sip,
            rx                    => rx,
            rz                    => rz
        );
    -- Operand Registers
    rx_register : entity work.register_buffer
        generic map(
            width => 16
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => rx_register_write_enable,
            data_in      => rx_register_value_in,
            data_out     => rx_register_value_out
        );

    rz_register : entity work.register_buffer
        generic map(
            width => 16
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => rz_register_write_enable,
            data_in      => rz_register_value_in,
            data_out     => rz_register_value_out
        );
    rz_register : entity work.register_buffer
        generic map(
            width => 16
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => rz_register_write_enable,
            data_in      => rz_register_value_in,
            data_out     => rz_register_value_out
        );

    -- ALU
    alu : entity work.alu
        port map(
            zero          => zero,
            alu_operation => alu_operation,
            alu_op1_sel   => alu_op1_sel,
            alu_op2_sel   => alu_op2_sel,
            rz            => rz,
            immediate     => immediate,
            pc            => pc,
            rx            => rx,
            reset         => reset,
            alu_result    => alu_result
        );

    -- ALU Reg
    alu_register : entity work.register_buffer
        generic map(
            width => 16
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => alu_register_write_enable,
            data_in      => alu_register_value_in,
            data_out     => alu_register_value_out
        );

    -- Data Memory
    data_memory : entity work.data_memory
        port map(
            clock        => clock,
            reset        => reset,
            data_in      => data_in,
            write_enable => write_enable,
            address      => address,
            data_out     => mdr_value_in
        );

    -- MDR
    mdr : entity work.register_buffer
        generic map(
            width => 16
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => mdr_write_enable,
            data_in      => mdr_value_in,
            data_out     => mdr_value_out
        );

    z_register : entity work.register_buffer
        generic map(
            width => 1
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => z_register_write_enable,
            data_in      => z_register_value_in,
            data_out     => z_register_value_out
        );
end architecture;