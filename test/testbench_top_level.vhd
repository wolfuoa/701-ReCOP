library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.recop_types.all;
use work.opcodes;
use work.mux_select_constants.all;

entity testbench_top_level is
    port (
        t_aluOp2_select        : out   std_logic_vector(1 downto 0);
        t_jump_select          : out   std_logic;
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
        t_pc_write_enable      : out   std_logic;
        t_pc_branch_cond       : out   std_logic;
        t_pc_write_select      : out   std_logic;
        t_state_decode_fail    : out   std_logic
    );
end entity;

architecture test of testbench_top_level is
    signal t_clock           : std_logic := '0';
    signal t_enable          : std_logic := '1';
    signal t_reset           : std_logic;
    signal t_addressing_mode : std_logic_vector(1 downto 0);
    signal t_opcode          : std_logic_vector(5 downto 0);
    signal t_dprr            : std_logic;
    signal t_sop             : std_logic_vector(15 downto 0);
    signal t_sip             : std_logic_vector(15 downto 0);

begin

    top_level_inst : entity work.top_level
        port map(
            clock  => t_clock,
            reset  => t_reset,
            enable => t_enable,
            sop    => t_sop,
            sip    => t_sip
        );
    -- * Generating Signals

    -- Clock
    process
    begin
        wait for 10 ns;
        t_clock <= '0';
        wait for 10 ns;
        t_clock <= '1';
    end process;

    -- Opcode 
    process
    begin
        t_opcode          <= opcodes.andr;
        t_addressing_mode <= opcodes.am_direct;
        wait for 10 ns;
        wait until rising_edge(t_pm_read_enable);

        t_opcode          <= opcodes.subvr;
        t_addressing_mode <= opcodes.am_immediate;
        wait for 10 ns;
        wait until rising_edge(t_pm_read_enable);

        t_opcode          <= opcodes.ldr;
        t_addressing_mode <= opcodes.am_immediate;
        wait for 10 ns;
        wait until rising_edge(t_pm_read_enable);

        t_enable <= '0';
        wait;
    end process;
end architecture;