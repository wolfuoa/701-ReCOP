library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

  use work.recop_types;
  use work.opcodes;
  use work.mux_select_constants;

entity data_path is
  port (
    clock                             : in  std_logic;
    packet                            : in  std_logic_vector(31 downto 0);
    reset                             : in  std_logic;

    -- Control unit inputs
    pc_input_select                   : in  std_logic;
    pc_write_enable                   : in  std_logic;
    pc_branch_conditional             : in  std_logic;

    jump_select                       : in  std_logic;

    register_file_write_enable        : in  std_logic;
    register_file_write_select        : in  std_logic_vector(1 downto 0);
    register_file_rz_select           : in  std_logic;

    instruction_register_write_enable : in  std_logic;
    rz_register_write_enable          : in  std_logic;
    rx_register_write_enable          : in  std_logic;

    -- ALU
    alu_register_write_enable         : in  std_logic;
    alu_op1_sel                       : in  std_logic_vector(1 downto 0);
    alu_op2_sel                       : in  std_logic_vector(1 downto 0);
    alu_op_sel                        : in  std_logic_vector(1 downto 0);

    -- Data Memory
    data_memory_data_select           : in  std_logic_vector(1 downto 0);
    data_memory_address_select        : in  std_logic;
    data_memory_write_enable          : in  std_logic;

    mdr_write_enable                  : in  std_logic;

    z_register_write_enable           : in  std_logic;
    z_register_reset                  : in  std_logic;

    --END Control unit inputs
    -- SIP and SOP Control Signals``
    lsip                              : in  std_logic;
    ssop                              : in  std_logic;

    -- External I/O
    sip_register_value_in             : in  std_logic_vector(15 downto 0);
    sop_register_value_out            : out std_logic_vector(15 downto 0);

    -- Outputs for the control unit
    addressing_mode                   : out std_logic_vector(1 downto 0);
    opcode                            : out std_logic_vector(5 downto 0)
  );
end entity;

-- 

architecture bhv of data_path is
  signal jump_address : std_logic_vector(15 downto 0);

  signal pc       : std_logic_vector(15 downto 0);
  signal pc_write : std_logic;

  signal instruction : std_logic_vector(31 downto 0);
  signal rz_index    : std_logic_vector(3 downto 0);
  signal rx_index    : std_logic_vector(3 downto 0);
  signal immediate   : std_logic_vector(15 downto 0);

  signal rz_register_value_in : std_logic_vector(15 downto 0);
  signal rx_register_value_in : std_logic_vector(15 downto 0);

  signal rz_register_value_out : std_logic_vector(15 downto 0);
  signal rx_register_value_out : std_logic_vector(15 downto 0);

  signal alu_register_value_in  : std_logic_vector(15 downto 0);
  signal alu_register_value_out : std_logic_vector(15 downto 0);

  signal sip_register_value_out : std_logic_vector(15 downto 0);
  signal sop_register_value_in  : std_logic_vector(15 downto 0);

  signal mdr_value_in  : std_logic_vector(15 downto 0);
  signal mdr_value_out : std_logic_vector(15 downto 0);

  signal z_register_value_in  : std_logic_vector(0 downto 0);
  signal z_register_value_out : std_logic_vector(0 downto 0);

begin

  -- Calculate jump address
  with jump_select select jump_address <=
    rx_register_value_out when '1',
    immediate             when others;

  pc_write <= (z_register_value_out(0) and pc_branch_conditional) or pc_write_enable;

  pc_inst: entity work.pc
    generic map (
      START_ADDR => (others => '0')
    )
    port map (
      clock           => clock,
      reset           => reset,
      write_enable    => pc_write, -- Needs to be different from the input port one
      pc_input_select => pc_input_select,
      jump_address    => jump_address,
      alu_out         => alu_register_value_out,
      pc              => pc
    );

  prog_mem_inst: entity work.prog_mem
    port map (
      address => pc,
      clock   => clock,
      q       => instruction
    );

  -- Register file
  register_file: entity work.register_file
    port map (
      clock                 => clock,
      reset                 => reset,
      write_enable          => register_file_write_enable,
      rz_index              => rz_index,
      rx_index              => rx_index,
      rz_select             => register_file_rz_select,
      register_write_select => register_file_write_select,
      immediate             => immediate,
      data_memory           => mdr_value_out,
      alu_out               => alu_register_value_out,
      sip                   => sip_register_value_out,
      rx                    => rx_register_value_in,
      rz                    => rz_register_value_in
    );
  -- Operand Registers
  rx_register: entity work.register_buffer
    generic map (
      width => 16
    )
    port map (
      clock        => clock,
      reset        => reset,
      write_enable => rx_register_write_enable,
      data_in      => rx_register_value_in,
      data_out     => rx_register_value_out
    );

  rz_register: entity work.register_buffer
    generic map (
      width => 16
    )
    port map (
      clock        => clock,
      reset        => reset,
      write_enable => rz_register_write_enable,
      data_in      => rz_register_value_in,
      data_out     => rz_register_value_out
    );

  -- ALU
  alu: entity work.alu
    port map (
      alu_operation => alu_op_sel,

      -- mux selects
      alu_op1_sel   => alu_op1_sel,
      alu_op2_sel   => alu_op2_sel,

      -- mux inputs
      immediate     => immediate,
      pc            => pc,
      rz            => rz_register_value_out,
      rx            => rx_register_value_out,

      -- outputs
      zero          => z_register_value_in(0),
      alu_result    => alu_register_value_in
    );

  -- ALU Reg
  alu_register: entity work.register_buffer
    generic map (
      width => 16
    )
    port map (
      clock        => clock,
      reset        => reset,
      write_enable => alu_register_write_enable,
      data_in      => alu_register_value_in,
      data_out     => alu_register_value_out
    );

  -- Data Memory
  data_memory_inst: entity work.data_memory
    port map (
      clock          => clock,
      reset          => reset,
      input_select   => data_memory_data_select,
      immediate      => immediate,
      alu_out        => alu_register_value_out,
      rx             => rx_register_value_out,
      write_enable   => data_memory_write_enable,
      address_select => data_memory_address_select,
      data_out       => mdr_value_in
    );

  -- MDR
  mdr: entity work.register_buffer
    generic map (
      width => 16
    )
    port map (
      clock        => clock,
      reset        => reset,
      write_enable => mdr_write_enable,
      data_in      => mdr_value_in,
      data_out     => mdr_value_out
    );

  -- Zero register
  z_register: entity work.register_buffer
    generic map (
      width => 1
    )
    port map (
      clock        => clock,
      reset        => z_register_reset,
      write_enable => z_register_write_enable,
      data_in      => z_register_value_in,
      data_out     => z_register_value_out
    );

  -- SIP
  sip_register: entity work.register_buffer
    generic map (
      width => 16
    )
    port map (
      clock        => clock,
      reset        => reset,
      write_enable => lsip,
      data_in      => sip_register_value_in,
      data_out     => sip_register_value_out
    );

  register_buffer_inst: entity work.register_buffer
    generic map (
      width => 16
    )
    port map (
      clock        => clock,
      reset        => reset,
      write_enable => ssop,
      data_in      => sop_register_value_in,
      data_out     => sop_register_value_out
    );
end architecture;
