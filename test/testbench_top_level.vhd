library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.recop_types.all;
  use work.opcodes;
  use work.mux_select_constants.all;

entity testbench_top_level is
  port (
    t_DPCRwrite_enable  : out std_logic;
    t_dmr_enable        : out std_logic;
    t_zero_reg_reset    : out std_logic;
    t_dm_write_enable   : out std_logic;
    t_dpcr_select       : out std_logic;
    t_dm_addr_select    : out std_logic;
    t_state_decode_fail : out std_logic
  );
end entity;

architecture test of testbench_top_level is
  signal t_clock  : std_logic := '0';
  signal t_enable : std_logic := '1';
  signal t_reset  : std_logic := '0';
  signal t_dprr   : std_logic := '0';

  signal t_lsip : std_logic := '0';
  signal t_ssop : std_logic := '0';

  signal t_pc_write_enable                   : std_logic;
  signal t_jump_select                       : std_logic;
  signal t_register_file_write_select        : std_logic_vector(1 downto 0) := "00";
  signal t_register_file_rz_select           : std_logic;
  signal t_instruction_register_write_enable : std_logic;
  signal t_alu_register_write_enable         : std_logic;

  signal t_data_memory_data_select    : std_logic_vector(1 downto 0);
  signal t_data_memory_address_select : std_logic;
  signal t_data_memory_write_enable   : std_logic;

  signal t_mdr_write_enable        : std_logic;
  signal t_z_register_write_enable : std_logic;
  signal t_addressing_mode         : std_logic_vector(1 downto 0);
  signal t_opcode                  : std_logic_vector(5 downto 0);
  signal t_z_register_reset        : std_logic;

  signal t_alu_op_sel  : std_logic_vector(1 downto 0);
  signal t_alu_op1_sel : std_logic_vector(1 downto 0);
  signal t_alu_op2_sel : std_logic_vector(1 downto 0);

  signal t_rz_register_write_enable   : std_logic;
  signal t_rx_register_write_enable   : std_logic;
  signal t_register_file_write_enable : std_logic;

  signal t_pc_branch_conditional : std_logic;
  signal t_pc_input_select       : std_logic_vector(1 downto 0);

  signal t_program_memory_read_enable : std_logic;
  signal t_program_memory_address     : std_logic_vector(15 downto 0);
  signal t_program_memory_data        : std_logic_vector(31 downto 0);

  signal t_data_memory_address  : std_logic_vector(15 downto 0);
  signal t_data_memory_data_in  : std_logic_vector(15 downto 0);
  signal t_data_memory_data_out : std_logic_vector(15 downto 0);

  signal t_instruction_register_buffer_enable : std_logic;

  type memory_array is array (0 to 13) of std_logic_vector(31 downto 0);
  signal progam_memory_inst : memory_array := (
    -- AM (2) Opcode (6) Rz (4) Rx (4) Operand (16)
    -- And register-register
    opcodes.am_immediate & opcodes.ldr & "0001" & "0000" & x"1fff",   -- Load 1 0x1fff into Reg(1)
    opcodes.am_register & opcodes.andr & "0001" & "0000" & x"EEEE",   -- And Reg(1) which is 0x1fff with Reg(0) which is 0

    -- And immediate
    opcodes.am_immediate & opcodes.ldr & "0001" & "0000" & x"1fff",   -- Load 1 0x1fff into Reg(1)
    opcodes.am_immediate & opcodes.andr & "0000" & "0001" & x"1fff",  -- 0x1fff and 0x1fff
    -- Or immediate
    opcodes.am_immediate & opcodes.orr & "0010" & "0010" & x"FF00",   -- OR x0000 with xFF00 to Reg(2)
    -- Or regiter-register
    opcodes.am_immediate & opcodes.orr & "0011" & "0011" & x"00FF",   -- OR Reg(3) with x00FF
    opcodes.am_register & opcodes.orr & "0010" & "0011" & x"EEEE",    -- OR Reg(2) with Reg(3) - Output 0xFFFF into Reg(2)
    -- Add Immediate
    opcodes.am_immediate & opcodes.ldr & "0100" & "0000" & x"0001",   -- Load 1 into Reg(4)
    opcodes.am_immediate & opcodes.addr & "0100" & "0100" & x"4444",  -- Add x4444 to Reg(4)
    -- Add register-register
    opcodes.am_immediate & opcodes.ldr & "0101" & "0000" & x"6969",   -- Load 1 0x6969 into Reg(5)
    opcodes.am_register & opcodes.addr & "0101" & "0101" & x"EEEE",   -- 0x6969 + 0x6969
    -- SUBV immediate
    opcodes.am_immediate & opcodes.ldr & "0110" & "0000" & x"B00B",   -- Load 1 0xB00B into Reg(6)
    opcodes.am_immediate & opcodes.subvr & "0000" & "0110" & x"B00B", -- Should be 0
    -- SUB
    opcodes.am_immediate & opcodes.subr & "0111" & "0000" & x"0001" -- 7 - 1
    -- Test Zero

  );

  signal program_memory_data    : std_logic_vector(31 downto 0);
  signal program_memory_address : std_logic_vector(15 downto 0);

begin
  program_memory_data <= progam_memory_inst(to_integer(unsigned(program_memory_address)));

  data_path_inst: entity work.data_path
    port map (
      -- outputs
      addressing_mode                    => t_addressing_mode,
      opcode                             => t_opcode,

      -- inputs
      clock                              => t_clock,
      reset                              => t_reset,

      program_memory_address             => program_memory_address,
      program_memory_data                => program_memory_data,

      data_memory_address                => t_data_memory_address,
      data_memory_data_out               => t_data_memory_data_out,
      data_memory_data_in                => t_data_memory_data_in,

      pc_input_select                    => t_pc_input_select,
      pc_write_enable                    => t_pc_write_enable,
      pc_branch_conditional              => t_pc_branch_conditional,

      jump_select                        => t_jump_select,

      register_file_write_enable         => t_register_file_write_enable,
      register_file_write_select         => t_register_file_write_select,
      register_file_rz_select            => t_register_file_rz_select,

      instruction_register_write_enable  => t_instruction_register_write_enable,

      instruction_register_buffer_enable => t_instruction_register_buffer_enable,

      rz_register_write_enable           => t_rz_register_write_enable,
      rx_register_write_enable           => t_rx_register_write_enable,

      alu_register_write_enable          => t_alu_register_write_enable,
      alu_op1_sel                        => t_alu_op1_sel,
      alu_op2_sel                        => t_alu_op2_sel,
      alu_op_sel                         => t_alu_op_sel,

      data_memory_data_select            => t_data_memory_data_select,
      data_memory_address_select         => t_data_memory_address_select,

      dmr_write_enable                   => t_mdr_write_enable,

      z_register_write_enable            => t_z_register_write_enable,
      z_register_reset                   => t_z_register_reset,

      lsip                               => t_lsip,
      ssop                               => t_ssop,
      sip_register_value_in              => x"0000",
      sop_register_value_out             => open
    );

  control_unit_inst: entity work.control_unit
    port map (
      clock                              => t_clock,
      enable                             => t_enable,
      reset                              => t_reset,
      addressing_mode                    => t_addressing_mode,
      opcode                             => t_opcode,

      dprr                               => t_dprr,
      jump_select                        => t_jump_select,
      DPCRwrite_enable                   => t_DPCRwrite_enable,

      alu_register_write_enable          => t_alu_register_write_enable,
      dpcr_select                        => t_dpcr_select,

      alu_op_sel                         => t_alu_op_sel,
      alu_op1_sel                        => t_alu_op1_sel,
      alu_op2_sel                        => t_alu_op2_sel,

      data_memory_address_select         => t_dm_addr_select,

      register_file_write_enable         => t_register_file_write_enable,
      register_file_write_select         => t_register_file_write_select,
      register_file_rz_select            => t_register_file_rz_select,

      rz_register_write_enable           => t_rz_register_write_enable,
      rx_register_write_enable           => t_rx_register_write_enable,

      z_register_write_enable            => t_z_register_write_enable,
      z_register_reset                   => t_zero_reg_reset,

      instruction_register_buffer_enable => t_instruction_register_buffer_enable,

      lsip                               => t_lsip,
      ssop                               => t_ssop,

      data_memory_write_enable           => t_dm_write_enable,
      dmr_write_enable                   => t_dmr_enable,

      program_memory_read_enable         => t_program_memory_read_enable,
      instruction_register_write_enable  => t_instruction_register_write_enable,

      pc_write_enable                    => t_pc_write_enable,
      pc_branch_conditional              => t_pc_branch_conditional,
      pc_input_select                    => t_pc_input_select,

      state_decode_fail                  => t_state_decode_fail
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
