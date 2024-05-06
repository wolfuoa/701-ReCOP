library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;
  use work.recop_types.all;
  use work.alu_ops;
  use work.opcodes.all;
  use work.mux_select_constants;

entity control_unit is
  port (
    clock                   : in  std_logic := '0';
    enable                  : in  std_logic := '0';
    reset                   : in  std_logic := '0';
    addressing_mode         : in  std_logic_vector(1 downto 0);
    opcode                  : in  std_logic_vector(5 downto 0);
    dprr                    : in  std_logic := '0';
    aluOp2_select           : out std_logic_vector(1 downto 0);
    jump_select             : out std_logic := '0';
    DPCRwrite_enable        : out std_logic := '0';
    dmr_enable              : out std_logic := '0';
    rz_write_enable         : out std_logic := '0';
    rx_write_enable         : out std_logic := '0';
    alu_reg_write_enable    : out std_logic := '0';
    sop_write_enable        : out std_logic := '0';
    zero_reg_reset          : out std_logic := '0';
    dm_write_enable         : out std_logic := '0';
    dpcr_select             : out std_logic := '0';
    alu_op                  : out std_logic_vector(1 downto 0);
    dm_addr_select          : out std_logic := '0';
    regfile_write_enable    : out std_logic := '0';
    register_file_rz_select : out std_logic := '0';
    aluOp1_select           : out std_logic_vector(1 downto 0);
    reg_write_select        : out std_logic_vector(1 downto 0);
    zero_write_enable       : out std_logic := '0';
    sip_ld                  : out std_logic := '0';
    pm_read_enable          : out std_logic := '0';
    ir_write_enable         : out std_logic := '0';
    pc_write_enable         : out std_logic := '0';
    pc_branch_cond          : out std_logic := '0';
    pc_write_select         : out std_logic := '0';

    state_decode_fail       : out std_logic := '0'
  );

end entity;

architecture rtl of control_unit is
  type state_type is (instruction_fetch, reg_access, reg_reg, reg_imm, load_imm, store_reg); -- TODO: Add all other states 
  signal state, next_state : state_type;
  signal decoded_ALUop     : std_logic_vector(1 downto 0);
begin

  -- Defaults for outputs (for copying)
  -- jump_select <= '0';
  -- DPCRwrite_enable <= '0';
  -- dmr_enable <= '0';
  -- rz_write_enable <= '0';
  -- rx_write_enable <= '0';
  -- alu_reg_write_enable <= '0'; 
  -- sop_write_enable <= '0';
  -- zero_reg_reset <= '0';
  -- dm_write_enable <= '0';
  -- dpcr_select <= '0';
  -- alu_op <= "00"; 
  -- dm_addr_select <= '0';
  -- regfile_write_enable <= '0';
  -- aluOp1_select <= "00";
  -- aluOp2_select <= "00";
  -- reg_write_select <= "00";
  -- zero_write_enable <= '0';
  -- sip_ld <= '0';
  -- pm_read_enable <= '0';
  -- ir_write_enable <= '0';
  -- pc_write_enable <= '0';
  -- pc_branch_cond <= '0';
  -- pc_write_select <= '0';
  -- register_file_rz_select <= '0';
  with opcode select
    decoded_ALUop <= alu_ops.alu_and when andr,
                     alu_ops.alu_add when orr,
                     alu_ops.alu_add when addr,
                     alu_ops.alu_sub when subr,
                     alu_ops.alu_sub when subvr,
                     alu_ops.alu_add when others;

  ALU_OP_DECODE: process (opcode)
  begin
    case opcode is
      when andr =>
        decoded_ALUop <= alu_ops.alu_and;
      when orr =>
        decoded_ALUop <= alu_ops.alu_or;
      when addr =>
        decoded_ALUop <= alu_ops.alu_add;
      when subr =>
        decoded_ALUop <= alu_ops.alu_sub;
      when subvr =>
        decoded_ALUop <= alu_ops.alu_sub;
      when others =>
        decoded_ALUop <= "00";
    end case;

  end process;

  CYCLE_OUTPUT_DECODE: process (state)
  begin
    case (state) is
      when instruction_fetch =>
        jump_select <= '0';
        DPCRwrite_enable <= '0';
        dmr_enable <= '0';
        rz_write_enable <= '0';
        rx_write_enable <= '0';
        alu_reg_write_enable <= '1'; -- changed
        sop_write_enable <= '0';
        register_file_rz_select <= '0';
        zero_reg_reset <= '0';
        dm_write_enable <= '0';
        dpcr_select <= '0';
        alu_op <= alu_ops.alu_add; -- changed
        dm_addr_select <= '0';
        regfile_write_enable <= '0';
        aluOp1_select <= mux_select_constants.alu_op1_pc; -- changed
        aluOp2_select <= mux_select_constants.alu_op2_one; -- changed
        reg_write_select <= "00";
        zero_write_enable <= '0';
        sip_ld <= '0';
        pm_read_enable <= '1'; -- changed
        ir_write_enable <= '1'; -- changed
        pc_write_enable <= '0';
        pc_branch_cond <= '0';
        pc_write_select <= '0';

      when reg_access =>
        jump_select <= '0';
        DPCRwrite_enable <= '0';
        dmr_enable <= '0';
        rz_write_enable <= '1'; -- changed
        rx_write_enable <= '1'; -- changed
        alu_reg_write_enable <= '0';
        sop_write_enable <= '0';
        zero_reg_reset <= '0';
        dm_write_enable <= '0';
        dpcr_select <= '0';
        alu_op <= "00";
        dm_addr_select <= '0';
        register_file_rz_select <= mux_select_constants.regfile_rz_normal;
        regfile_write_enable <= '0';
        aluOp1_select <= "00";
        aluOp2_select <= "00";
        reg_write_select <= "00";
        zero_write_enable <= '0';
        sip_ld <= '0';
        pm_read_enable <= '0';
        ir_write_enable <= '0';
        pc_write_enable <= '1'; -- changed
        pc_branch_cond <= '0';
        pc_write_select <= '0'; -- changed

      when reg_reg =>
        jump_select <= '0';
        DPCRwrite_enable <= '0';
        dmr_enable <= '0';
        rz_write_enable <= '0';
        rx_write_enable <= '0';
        alu_reg_write_enable <= '1'; -- changed 
        sop_write_enable <= '0';
        zero_reg_reset <= '0';
        dm_write_enable <= '0';
        dpcr_select <= '0';
        alu_op <= decoded_ALUop; -- changed
        dm_addr_select <= '0';
        regfile_write_enable <= '0';
        aluOp1_select <= mux_select_constants.alu_op1_rz; -- changed
        aluOp2_select <= mux_select_constants.alu_op2_rx; -- changed
        reg_write_select <= "00";
        zero_write_enable <= '1'; -- changed
        register_file_rz_select <= mux_select_constants.regfile_rz_normal;
        sip_ld <= '0';
        pm_read_enable <= '0';
        ir_write_enable <= '0';
        pc_write_enable <= '0';
        pc_branch_cond <= '0';
        pc_write_select <= '0';

      when reg_imm =>
        jump_select <= '0';
        DPCRwrite_enable <= '0';
        dmr_enable <= '0';
        rz_write_enable <= '0';
        rx_write_enable <= '0';
        alu_reg_write_enable <= '1'; -- changed 
        sop_write_enable <= '0';
        zero_reg_reset <= '0';
        dm_write_enable <= '0';
        dpcr_select <= '0';
        alu_op <= decoded_ALUop; -- changed
        dm_addr_select <= '0';
        regfile_write_enable <= '0';
        aluOp1_select <= mux_select_constants.alu_op1_immediate; -- changed
        aluOp2_select <= mux_select_constants.alu_op2_rx; -- changed
        register_file_rz_select <= '0';
        reg_write_select <= "00";
        zero_write_enable <= '1'; -- changed
        sip_ld <= '0';
        pm_read_enable <= '0';
        ir_write_enable <= '0';
        pc_write_enable <= '0';
        pc_branch_cond <= '0';
        pc_write_select <= '0';

      when load_imm =>
        jump_select <= '0';
        DPCRwrite_enable <= '0';
        dmr_enable <= '0';
        rz_write_enable <= '0';
        rx_write_enable <= '0';
        alu_reg_write_enable <= '0';
        sop_write_enable <= '0';
        zero_reg_reset <= '0';
        dm_write_enable <= '0';
        dpcr_select <= '0';
        alu_op <= "00";
        dm_addr_select <= '0';
        regfile_write_enable <= '1'; -- changed
        aluOp1_select <= "00";
        aluOp2_select <= "00";
        reg_write_select <= mux_select_constants.regfile_write_immediate; -- changed
        register_file_rz_select <= mux_select_constants.regfile_rz_normal;
        zero_write_enable <= '0';
        sip_ld <= '0';
        pm_read_enable <= '0';
        ir_write_enable <= '0';
        pc_write_enable <= '1'; -- changed
        pc_branch_cond <= '0';
        pc_write_select <= '0'; -- changed

      when store_reg =>
        jump_select <= '0';
        DPCRwrite_enable <= '0';
        dmr_enable <= '0';
        rz_write_enable <= '0';
        rx_write_enable <= '0';
        alu_reg_write_enable <= '0';
        sop_write_enable <= '0';
        zero_reg_reset <= '0';
        dm_write_enable <= '0';
        dpcr_select <= '0';
        alu_op <= "00";
        dm_addr_select <= '0';
        regfile_write_enable <= '1'; -- changed
        aluOp1_select <= "00";
        aluOp2_select <= "00";
        register_file_rz_select <= mux_select_constants.regfile_rz_normal;
        reg_write_select <= mux_select_constants.regfile_write_aluout; -- changed
        zero_write_enable <= '0';
        sip_ld <= '0';
        pm_read_enable <= '0';
        ir_write_enable <= '0';
        pc_write_enable <= '0';
        pc_branch_cond <= '0';
        pc_write_select <= '0';
    end case;

  end process;

  NEXT_STATE_DECODE: process (state, opcode, addressing_mode)
  begin
    case state is
      when instruction_fetch =>
        if (opcode = andr) or
           (opcode = orr) or
           (opcode = addr) or
           (opcode = subvr) then
          state_decode_fail <= '0';
          next_state <= reg_access;
        elsif (opcode = ldr) and (addressing_mode = am_immediate) then
          state_decode_fail <= '0';
          next_state <= load_imm;
        else
          state_decode_fail <= '1';
          next_state <= instruction_fetch;
        end if;

      when load_imm =>
        state_decode_fail <= '0';
        next_state <= instruction_fetch;

      when reg_access =>
        if addressing_mode = am_direct then
          state_decode_fail <= '0';
          next_state <= reg_reg;
        elsif addressing_mode = am_immediate then
          state_decode_fail <= '0';
          next_state <= reg_imm;
        else
          state_decode_fail <= '1';
          next_state <= instruction_fetch;
        end if;

      when reg_reg =>
        state_decode_fail <= '0';
        next_state <= store_reg;

      when reg_imm =>
        state_decode_fail <= '0';
        next_state <= store_reg;

      when store_reg =>
        state_decode_fail <= '0';
        next_state <= instruction_fetch;
    end case;

  end process;

  SYNC: process (clock, reset)
  begin
    if (reset = '1') then
      state <= instruction_fetch;
    elsif rising_edge(clock) then
      if enable = '1' then
        state <= next_state;
      end if;
    end if;
  end process;
end architecture;
