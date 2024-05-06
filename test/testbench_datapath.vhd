library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.recop_types.all;
use work.opcodes;
use work.mux_select_constants.all;

entity testbench_datapath is
end entity;

architecture test of testbench_datapath is
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

    signal program_memory_data                 : std_logic_vector(31 downto 0);
    signal program_memory_address              : std_logic_vector(15 downto 0);

begin

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

    -- Program
    process
    begin
        wait for 20 ns;
        t_packet                     <= opcodes.am_immediate & opcodes.ldr & "0001" & "0000" & x"1fff";
        t_register_file_write_enable <= '1';
        t_register_file_write_select <= "00";
        wait for 20 ns;
        t_packet                     <= opcodes.am_immediate & opcodes.ldr & "0001" & "0000" & x"0123";
        t_register_file_write_enable <= '1';
        t_register_file_write_select <= "00";
    end process;

    -- Clock
    process
    begin
        wait for 10 ns;
        t_clock <= '0';
        wait for 10 ns;
        t_clock <= '1';
    end process;

    -- Reset
    process
    begin
        t_reset <= '1';
        wait for 10 ns;
        t_reset <= '0';
        wait;
    end process;

end architecture;