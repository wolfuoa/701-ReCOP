library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.recop_types.all;
use work.opcodes;
use work.mux_select_constants.all;

entity testbench_top_level is
    port (
        t_aluOp2_select        : out   std_logic_vector(1 downto 0);
        t_DPCRwrite_enable     : out   std_logic;
        t_dmr_enable           : out   std_logic;
        t_rz_write_enable      : out   std_logic;
        t_rx_write_enable      : out   std_logic;
        t_alu_reg_write_enable : out   std_logic;
        t_sop_write_enable     : out   std_logic;
        t_zero_reg_reset       : out   std_logic;
        t_dm_write_enable      : out   std_logic;
        t_dpcr_select          : out   std_logic;
        t_alu_op               : out   std_logic_vector(1 downto 0);
        t_dm_addr_select       : out   std_logic;
        t_regfile_write_enable : out   std_logic;
        t_aluOp1_select        : out   std_logic_vector(1 downto 0);
        t_reg_write_select     : out   std_logic_vector(1 downto 0);
        t_zero_write_enable    : out   std_logic;
        t_sip_ld               : out   std_logic;
        t_pm_read_enable       : inout std_logic;
        t_ir_write_enable      : out   std_logic;
        t_pc_branch_cond       : out   std_logic;
        t_pc_write_select      : out   std_logic;
        t_state_decode_fail    : out   std_logic
    );
end entity;

architecture test of testbench_top_level is
    signal t_clock                             : std_logic := '0';
    signal t_enable                            : std_logic := '1';
    signal t_reset                             : std_logic;
    signal t_dprr                              : std_logic;
    signal t_t_sop                             : std_logic_vector(15 downto 0);
    signal t_t_sip                             : std_logic_vector(15 downto 0);

    signal t_packet                            : std_logic_vector(31 downto 0);
    signal t_pc_input_select                   : std_logic;
    signal t_pc_write_enable                   : std_logic;
    signal t_pc_branch_conditional             : std_logic;
    signal t_jump_select                       : std_logic;
    signal t_register_file_write_enable        : std_logic;
    signal t_register_file_write_select        : std_logic_vector(1 downto 0);
    signal t_register_file_rz_select           : std_logic;
    signal t_instruction_register_write_enable : std_logic;
    signal t_rz_register_write_enable          : std_logic;
    signal t_rx_register_write_enable          : std_logic;
    signal t_alu_register_write_enable         : std_logic;
    signal t_alu_op1_sel                       : std_logic_vector(1 downto 0);
    signal t_alu_op2_sel                       : std_logic_vector(1 downto 0);
    signal t_alu_op_sel                        : std_logic_vector(1 downto 0);
    signal t_data_memory_data_select           : std_logic_vector(1 downto 0);
    signal t_data_memory_address_select        : std_logic;
    signal t_data_memory_write_enable          : std_logic;
    signal t_mdr_write_enable                  : std_logic;
    signal t_z_register_write_enable           : std_logic;
    signal t_lsip                              : std_logic;
    signal t_ssop                              : std_logic;
    signal t_addressing_mode                   : std_logic_vector(1 downto 0);
    signal t_opcode                            : std_logic_vector(5 downto 0);
    signal t_z_register_reset                  : std_logic;

    signal t_program_memory_address            : std_logic_vector(15 downto 0);
    signal t_program_memory_data               : std_logic_vector(31 downto 0);

    signal t_data_memory_address               : std_logic_vector(15 downto 0);
    signal t_data_memory_data_in               : std_logic_vector(15 downto 0);
    signal t_data_memory_data_out              : std_logic_vector(15 downto 0);

    type memory_array is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal progam_memory_inst : memory_array := (
        opcodes.am_immediate & opcodes.ldr & "0001" & "0000" & x"1fff",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000",
        x"00000000"
    );

    signal program_memory_data    : std_logic_vector(31 downto 0);
    signal program_memory_address : std_logic_vector(15 downto 0);

begin

    program_memory_data <= progam_memory_inst(to_integer(unsigned(program_memory_address(4 downto 0))));

    data_path_inst : entity work.data_path
        port map(
            clock                             => t_clock,
            packet                            => t_packet,
            reset                             => t_reset,
            program_memory_address            => program_memory_address,
            program_memory_data               => program_memory_data,
            data_memory_address               => t_data_memory_address,
            data_memory_data_out              => t_data_memory_data_out,
            data_memory_data_in               => t_data_memory_data_in,
            pc_input_select                   => t_pc_input_select,
            pc_write_enable                   => t_pc_write_enable,
            pc_branch_conditional             => t_pc_branch_conditional,
            jump_select                       => t_jump_select,
            register_file_write_enable        => t_register_file_write_enable,
            register_file_write_select        => t_register_file_write_select,
            register_file_rz_select           => t_register_file_rz_select,
            instruction_register_write_enable => t_instruction_register_write_enable,
            rz_register_write_enable          => t_rz_register_write_enable,
            rx_register_write_enable          => t_rx_register_write_enable,
            alu_register_write_enable         => t_alu_register_write_enable,
            alu_op1_sel                       => t_alu_op1_sel,
            alu_op2_sel                       => t_alu_op2_sel,
            alu_op_sel                        => t_alu_op_sel,
            data_memory_data_select           => t_data_memory_data_select,
            data_memory_address_select        => t_data_memory_address_select,
            data_memory_write_enable          => t_data_memory_write_enable,
            mdr_write_enable                  => t_mdr_write_enable,
            z_register_write_enable           => t_z_register_write_enable,
            z_register_reset                  => t_z_register_reset,
            lsip                              => t_lsip,
            ssop                              => t_ssop,
            sip_register_value_in             => x"0000",
            sop_register_value_out            => open,
            addressing_mode                   => t_addressing_mode,
            opcode                            => t_opcode
        );

    control_unit_inst : entity work.control_unit
        port map(
            clock                => t_clock,
            enable               => t_enable,
            reset                => t_reset,
            addressing_mode      => t_addressing_mode,
            opcode               => t_opcode,
            dprr                 => t_dprr,
            aluOp2_select        => t_aluOp2_select,
            jump_select          => t_jump_select,
            DPCRwrite_enable     => t_DPCRwrite_enable,
            dmr_enable           => t_dmr_enable,
            rz_write_enable      => t_rz_write_enable,
            rx_write_enable      => t_rx_write_enable,
            alu_reg_write_enable => t_alu_reg_write_enable,
            sop_write_enable     => t_sop_write_enable,
            zero_reg_reset       => t_zero_reg_reset,
            dm_write_enable      => t_dm_write_enable,
            dpcr_select          => t_dpcr_select,
            alu_op               => t_alu_op,
            dm_addr_select       => t_dm_addr_select,
            regfile_write_enable => t_regfile_write_enable,
            aluOp1_select        => t_aluOp1_select,
            reg_write_select     => t_reg_write_select,
            zero_write_enable    => t_zero_write_enable,
            sip_ld               => t_sip_ld,
            pm_read_enable       => t_pm_read_enable,
            ir_write_enable      => t_ir_write_enable,
            pc_write_enable      => t_pc_write_enable,
            pc_branch_cond       => t_pc_branch_cond,
            pc_write_select      => t_pc_write_select,
            state_decode_fail    => t_state_decode_fail
        );

    -- Clock
    process
    begin
        wait for 10 ns;
        t_clock <= '0';
        wait for 10 ns;
        t_clock <= '1';
    end process;

end architecture;