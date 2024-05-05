library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

  use work.recop_types.all;
  use work.opcodes.all;
  use work.mux_select_constants.all;

entity top_level is
  port (
    clock  : in  std_logic;
    reset  : in  std_logic;
    enable : in  std_logic;

    -- External Signal I/O
    sop    : out std_logic_vector(15 downto 0);
    sip    : in  std_logic_vector(15 downto 0)
  );
end entity;

architecture bhv of top_level is

  signal packet                            : std_logic_vector(31 downto 0);
  signal pc_input_select                   : std_logic;
  signal pc_write_enable                   : std_logic;
  signal pc_branch_conditional             : std_logic;
  signal jump_select                       : std_logic;
  signal register_file_write_enable        : std_logic;
  signal register_file_write_select        : std_logic;
  signal register_file_rz_select           : std_logic;
  signal instruction_register_write_enable : std_logic;
  signal rz_register_write_enable          : std_logic;
  signal rx_register_write_enable          : std_logic;
  signal alu_register_write_enable         : std_logic;
  signal alu_op1_sel                       : std_logic_vector(1 downto 0);
  signal alu_op2_sel                       : std_logic_vector(1 downto 0);
  signal alu_op_sel                        : std_logic_vector(1 downto 0);
  signal data_memory_data_select           : std_logic_vector(1 downto 0);
  signal data_memory_address_select        : std_logic;
  signal data_memory_write_enable          : std_logic;
  signal mdr_write_enable                  : std_logic;
  signal z_register_write_enable           : std_logic;
  signal lsip                              : std_logic;
  signal addressing_mode                   : std_logic_vector(1 downto 0);
  signal opcode                            : std_logic_vector(5 downto 0);
  signal z_register_reset                  : std_logic;

begin

  data_path_inst: entity work.data_path
    port map (
      clock                             => clock,
      packet                            => packet,
      reset                             => reset,
      pc_input_select                   => pc_input_select,
      pc_write_enable                   => pc_write_enable,
      pc_branch_conditional             => pc_branch_conditional,
      jump_select                       => jump_select,
      register_file_write_enable        => register_file_write_enable,
      register_file_write_select        => register_file_write_select,
      register_file_rz_select           => register_file_rz_select,
      instruction_register_write_enable => instruction_register_write_enable,
      rz_register_write_enable          => rz_register_write_enable,
      rx_register_write_enable          => rx_register_write_enable,
      alu_register_write_enable         => alu_register_write_enable,
      alu_op1_sel                       => alu_op1_sel,
      alu_op2_sel                       => alu_op2_sel,
      alu_op_sel                        => alu_op_sel,
      data_memory_data_select           => data_memory_data_select,
      data_memory_address_select        => data_memory_address_select,
      data_memory_write_enable          => data_memory_write_enable,
      mdr_write_enable                  => mdr_write_enable,
      z_register_write_enable           => z_register_write_enable,
      sip_register_value_in             => sip,
      lsip                              => lsip,
      addressing_mode                   => addressing_mode,
      opcode                            => opcode,
      z_register_reset                  => z_register_reset
    );

  control_unit_inst: entity work.control_unit
    port map (
      clock                => clock,
      reset                => reset,
      adressing_mode       => addressing_mode,
      opcode               => opcode,
      dprr                 => (others => '0'), -- TODO
      aluOp2_select        => alu_op2_sel,
      jump_select          => jump_select,
      DPCRwrite_enable     => (others => '0'), -- TODO
      dmr_enable           => mdr_write_enable,
      rz_write_enable      => rz_register_write_enable,
      rx_write_enable      => rx_register_write_enable,
      alu_reg_write_enable => alu_register_write_enable,
      sop_write_enable     => (others => '0'), -- TODO
      zero_reg_reset       => z_register_reset,
      dm_write_enable      => mdr_write_enable,
      dpcr_select          => (others => '0'), -- TODO
      alu_op               => alu_op_sel,
      dm_addr_select       => data_memory_address_select,
      regfile_write_enable => register_file_write_enable,
      aluOp1_select        => alu_op1_sel,
      reg_write_select     => register_file_write_select,
      zero_write_enable    => z_register_write_enable,
      sip_ld               => lsip,
      pm_read_enable       => (others => '0'), -- TODO
      ir_write_enable      => instruction_register_write_enable,
      pc_write_enable      => pc_write_enable,
      pc_branch_cond       => pc_branch_conditional,
      pc_write_select      => pc_input_select
    );

end architecture;
