library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

entity testbench_control_unit is
end entity;

architecture test of testbench_control_unit is
   signal t_clock : std_logic;
   signal t_reset : std_logic;
   signal t_adressing_mode : std_logic_vector(1 downto 0);
   signal t_opcode : std_logic_vector(5 downto 0);
   signal t_dprr : std_logic;
   signal t_aluOp2_select : std_logic_vector(1 downto 0);
   signal t_jump_select : std_logic;
   signal t_DPCRwrite_enable : std_logic;
   signal t_dmr_enable : std_logic;
   signal t_rz_write_enable : std_logic;
   signal t_rx_write_enable : std_logic;
   signal t_alu_reg_write_enable : std_logic;
   signal t_sop_write_enable : std_logic;
   signal t_zero_reg_reset : std_logic;
   signal t_dm_write_enable : std_logic;
   signal t_dpcr_select : std_logic;
   signal t_alu_op : std_logic_vector(2 downto 0);
   signal t_dm_addr_select : std_logic_vector(1 downto 0);
   signal t_regfile_write_enable : std_logic;
   signal t_aluOp1_select : std_logic_vector(1 downto 0);
   signal t_reg_write_select : std_logic_vector(1 downto 0);
   signal t_zero_write_enable : std_logic;
   signal t_sip_ld : std_logic;
   signal t_pm_read_enable : std_logic;
   signal t_ir_write_enable : std_logic;
   signal t_pc_write_enable : std_logic;
   signal t_pc_branch_cond : std_logic;
   signal t_pc_write_select : std_logic;

begin
   DUT : entity work.control_unit
      port map(
         clock => t_clock,
         reset => t_reset,
         adressing_mode => t_adressing_mode,
         opcode => t_opcode,
         dprr => t_dprr,
         aluOp2_select => t_aluOp2_select,
         jump_select => t_jump_select,
         DPCRwrite_enable => t_DPCRwrite_enable,
         dmr_enable => t_dmr_enable,
         rz_write_enable => t_rz_write_enable,
         rx_write_enable => t_rx_write_enable,
         alu_reg_write_enable => t_alu_reg_write_enable,
         sop_write_enable => t_sop_write_enable,
         zero_reg_reset => t_zero_reg_reset,
         dm_write_enable => t_dm_write_enable,
         dpcr_select => t_dpcr_select,
         alu_op => t_alu_op,
         dm_addr_select => t_dm_addr_select,
         regfile_write_enable => t_regfile_write_enable,
         aluOp1_select => t_aluOp1_select,
         reg_write_select => t_reg_write_select,
         zero_write_enable => t_zero_write_enable,
         sip_ld => t_sip_ld,
         pm_read_enable => t_pm_read_enable,
         ir_write_enable => t_ir_write_enable,
         pc_write_enable => t_pc_write_enable,
         pc_branch_cond => t_pc_branch_cond,
         pc_write_select => t_pc_write_select,
      );

   -- * Generating Signals

   -- Clock
   process
   begin
      t_clock <= '1';
      wait for 10 ns;
      t_clock <= '0';
      wait for 10 ns;
   end process;
end;