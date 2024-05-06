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
  signal register_file_write_select        : std_logic_vector(1 downto 0);
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
  signal dmr_write_enable                  : std_logic;
  signal z_register_write_enable           : std_logic;
  signal lsip                              : std_logic;
  signal ssop                              : std_logic;
  signal addressing_mode                   : std_logic_vector(1 downto 0);
  signal opcode                            : std_logic_vector(5 downto 0);
  signal z_register_reset                  : std_logic;

  signal program_memory_address : std_logic_vector(15 downto 0);
  signal program_memory_data    : std_logic_vector(31 downto 0);

  signal data_memory_address  : std_logic_vector(15 downto 0);
  signal data_memory_data_in  : std_logic_vector(15 downto 0);
  signal data_memory_data_out : std_logic_vector(15 downto 0);

begin

  -- Program Memory
  prog_mem_inst: entity work.prog_mem
    port map (
      address => program_memory_address,
      clock   => clock,
      q       => program_memory_data
    );

  -- Data Memory
  data_memory_inst: entity work.data_memory
    port map (
      clock        => clock,
      reset        => reset,
      data_in      => data_memory_data_in,
      write_enable => data_memory_write_enable,
      address      => data_memory_address,
      data_out     => data_memory_data_out
    );

  data_path_inst: entity work.data_path
    port map (
      clock                             => clock,
      reset                             => reset,
      program_memory_address            => program_memory_address,
      program_memory_data               => program_memory_data,
      data_memory_address               => data_memory_address,
      data_memory_data_out              => data_memory_data_out,
      data_memory_data_in               => data_memory_data_in,
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
      dmr_write_enable                  => dmr_write_enable,
      z_register_write_enable           => z_register_write_enable,
      sip_register_value_in             => sip,
      lsip                              => lsip,
      ssop                              => ssop,
      addressing_mode                   => addressing_mode,
      opcode                            => opcode,
      z_register_reset                  => z_register_reset
    );

  control_unit_inst: entity work.control_unit
    port map (
      clock                             => clock,
      reset                             => reset,
      addressing_mode                   => addressing_mode,
      opcode                            => opcode,
      dprr                              => '0',  -- TODO
      alu_op2_sel                       => alu_op2_sel,
      jump_select                       => jump_select,
      DPCRwrite_enable                  => open, -- TODO
      dmr_write_enable                  => dmr_write_enable,
      rz_register_write_enable          => rz_register_write_enable,
      rx_register_write_enable          => rx_register_write_enable,
      alu_register_write_enable         => alu_register_write_enable,
      ssop                              => open, -- TODO
      z_register_reset                  => z_register_reset,
      data_memory_write_enable          => dmr_write_enable,
      dpcr_select                       => open, -- TODO
      alu_op_sel                        => alu_op_sel,
      data_memory_address_select        => data_memory_address_select,
      register_file_write_enable        => register_file_write_enable,
      alu_op1_sel                       => alu_op1_sel,
      register_file_write_select        => register_file_write_select,
      z_register_write_enable           => z_register_write_enable,
      lsip                              => lsip,
      -- TODO SOP_ST
      program_memory_read_enable        => open, -- TODO
      instruction_register_write_enable => instruction_register_write_enable,
      pc_write_enable                   => pc_write_enable,
      pc_branch_conditional             => pc_branch_conditional,
      pc_input_select                   => pc_input_select,
      enable                            => enable
    );

end architecture;
