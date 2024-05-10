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
        clock                              : in  std_logic := '0';
        enable                             : in  std_logic := '0';
        reset                              : in  std_logic := '0';

        addressing_mode                    : in  std_logic_vector(1 downto 0);
        opcode                             : in  std_logic_vector(5 downto 0);

        dprr                               : in  std_logic                    := '0';

        DPCRwrite_enable                   : out std_logic                    := '0';
        dpcr_select                        : out std_logic                    := '0';

        program_memory_read_enable         : out std_logic                    := '0';

        instruction_register_write_enable  : out std_logic                    := '0';
        instruction_register_buffer_enable : out std_logic                    := '0';

        data_memory_write_enable           : out std_logic                    := '0';
        data_memory_address_select         : out std_logic_vector(1 downto 0) := "00";
        data_memory_data_select            : out std_logic_vector(1 downto 0) := "00";

        data_memory_register_write_enable  : out std_logic                    := '0';

        lsip                               : out std_logic                    := '0';
        ssop                               : out std_logic                    := '0';

        register_file_write_select         : out std_logic_vector(1 downto 0);
        register_file_write_enable         : out std_logic := '0';
        register_file_rz_select            : out std_logic := '0';

        z_register_reset                   : out std_logic := '0';
        z_register_write_enable            : out std_logic := '0';

        alu_op_sel                         : out std_logic_vector(1 downto 0);
        alu_op1_sel                        : out std_logic_vector(1 downto 0);
        alu_op2_sel                        : out std_logic_vector(1 downto 0);
        alu_register_write_enable          : out std_logic;

        rz_register_write_enable           : out std_logic                    := '0';
        rx_register_write_enable           : out std_logic                    := '0';

        jump_select                        : out std_logic                    := '0';

        pc_write_enable                    : out std_logic                    := '0';
        pc_branch_conditional              : out std_logic                    := '0';
        pc_input_select                    : out std_logic_vector(1 downto 0) := "00";

        state_decode_fail                  : out std_logic                    := '0'
    );

end entity;

architecture rtl of control_unit is
    type state_type is (instruction_fetch, reg_access, reg_reg,
        reg_imm, load_imm, store_reg, no_op,
        mem_load_reg, mem_load_direct,
        mem_store_imm_at_reg, mem_store_reg_at_reg,
        mem_store_reg_at_imm, sub_no_store,
        mem_write_back, jump_imm, jump_reg, present_state, branch_conditional); -- TODO: Add all other states 
    signal state         : state_type := no_op;
    signal next_state    : state_type;
    signal decoded_ALUop : std_logic_vector(1 downto 0);
begin

    -- Defaults for outputs (for copying)
    -- jump_select <= '0';
    -- DPCRwrite_enable <= '0';
    -- data_memory_register_write_enable <= '0';
    -- rz_register_write_enable <= '0';
    -- rx_register_write_enable <= '0';
    -- alu_register_write_enable <= '0'; 
    -- ssop <= '0';
    -- z_register_reset <= '0';
    -- data_memory_write_enable <= '0';
    -- dpcr_select <= '0';
    -- alu_op_sel <= "00"; 
    -- data_memory_address_select <= "00";
    -- register_file_write_enable <= '0';
    -- alu_op1_sel <= "00";
    -- alu_op2_sel <= "00";
    -- register_file_write_select <= "00";
    -- z_register_write_enable <= '0';
    -- lsip <= '0';
    -- instruction_register_buffer_enable <= '0';
    -- program_memory_read_enable <= '0';
    -- instruction_register_write_enable <= '0';
    -- pc_write_enable <= '0';
    -- data_memory_data_select <= "00";
    -- pc_branch_conditional <= '0';
    -- pc_input_select <= "00";
    -- register_file_rz_select <= '0';
    with opcode select
        decoded_ALUop <= alu_ops.alu_and when andr,
        alu_ops.alu_or when orr,
        alu_ops.alu_add when addr,
        alu_ops.alu_sub when subr,
        alu_ops.alu_sub when subvr,
        alu_ops.alu_add when others;

    ALU_OP_DECODE : process (opcode)
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

    CYCLE_OUTPUT_DECODE : process (state)
    begin
        case (state) is
            when instruction_fetch =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '1'; -- changed
                ssop                               <= '0';
                register_file_rz_select            <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                data_memory_data_select            <= "00";
                dpcr_select                        <= '0';
                alu_op_sel                         <= alu_ops.alu_add; -- changed
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= mux_select_constants.alu_op1_pc;  -- changed
                alu_op2_sel                        <= mux_select_constants.alu_op2_one; -- changed
                register_file_write_select         <= "00";
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '1'; -- changed
                instruction_register_buffer_enable <= '1';
                instruction_register_write_enable  <= '1'; -- changed
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;

            when reg_access =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '1'; -- changed
                rx_register_write_enable           <= '1'; -- changed
                alu_register_write_enable          <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_data_select            <= "00";
                data_memory_write_enable           <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                instruction_register_buffer_enable <= '0';
                data_memory_address_select         <= "00";
                register_file_rz_select            <= mux_select_constants.regfile_rz_normal;
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= mux_select_constants.alu_op1_pc;  -- changed
                alu_op2_sel                        <= mux_select_constants.alu_op2_one; -- changed
                register_file_write_select         <= "00";
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1';
                pc_write_enable                    <= '1'; -- changed
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;

            when reg_reg =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '1'; -- changed 
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                instruction_register_buffer_enable <= '0';
                data_memory_data_select            <= "00";
                dpcr_select                        <= '0';
                alu_op_sel                         <= decoded_ALUop; -- changed
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= mux_select_constants.alu_op1_rz; -- changed
                alu_op2_sel                        <= mux_select_constants.alu_op2_rx; -- changed
                register_file_write_select         <= mux_select_constants.regfile_write_aluout;
                z_register_write_enable            <= '1'; -- changed
                register_file_rz_select            <= mux_select_constants.regfile_rz_normal;
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '0';
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;

            when reg_imm =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '1'; -- changed 
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                instruction_register_buffer_enable <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= decoded_ALUop; -- changed
                data_memory_data_select            <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= mux_select_constants.alu_op1_immediate; -- changed
                alu_op2_sel                        <= mux_select_constants.alu_op2_rx;        -- changed
                register_file_rz_select            <= '0';
                register_file_write_select         <= mux_select_constants.regfile_write_aluout;
                z_register_write_enable            <= '1'; -- changed
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '0';
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;

            when load_imm =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                ssop                               <= '0';
                instruction_register_buffer_enable <= '0';
                z_register_reset                   <= '0';
                data_memory_data_select            <= "00";
                data_memory_write_enable           <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '1';                                          -- changed
                alu_op1_sel                        <= mux_select_constants.alu_op1_pc;              -- changed
                alu_op2_sel                        <= mux_select_constants.alu_op2_one;             -- changed
                register_file_write_select         <= mux_select_constants.regfile_write_immediate; -- changed
                register_file_rz_select            <= mux_select_constants.regfile_rz_normal;
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1'; -- changed
                pc_write_enable                    <= '1'; -- changed
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;

            when store_reg =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                instruction_register_buffer_enable <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_data_select            <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '1'; -- changed
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_rz_select            <= mux_select_constants.regfile_rz_normal;
                register_file_write_select         <= mux_select_constants.regfile_write_aluout; -- changed
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1';
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;

            when no_op =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                data_memory_data_select            <= "00";
                alu_register_write_enable          <= '0';
                instruction_register_buffer_enable <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_write_select         <= "00";
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1'; -- Changed
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;
                register_file_rz_select            <= '0';

            when mem_load_reg =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '1';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                instruction_register_buffer_enable <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_data_select            <= "00";
                data_memory_write_enable           <= '0'; -- changed
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_address_select         <= mux_select_constants.data_memory_address_rx;
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_write_select         <= "00";
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1';
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;
                register_file_rz_select            <= '0';

            when mem_write_back =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                instruction_register_buffer_enable <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_data_select            <= "00";
                data_memory_write_enable           <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_address_select         <= mux_select_constants.data_memory_address_rx;
                register_file_write_enable         <= '1'; -- changed
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_write_select         <= mux_select_constants.regfile_write_data_memory_register; -- changed
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1'; -- changed
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;
                register_file_rz_select            <= '0';

            when mem_store_imm_at_reg =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '1'; -- changed
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                instruction_register_buffer_enable <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '1'; -- changed
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_data_select            <= mux_select_constants.data_memory_data_immediate;
                data_memory_address_select         <= mux_select_constants.data_memory_address_rz;
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_write_select         <= "00";
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1'; -- changed
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_aluout;
                register_file_rz_select            <= '0';
            when mem_store_reg_at_reg =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '1'; -- changed
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                instruction_register_buffer_enable <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '1'; -- changed
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_data_select            <= mux_select_constants.data_memory_data_rx;
                data_memory_address_select         <= mux_select_constants.data_memory_address_rz;
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_write_select         <= "00";
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1'; -- changed
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_aluout;
                register_file_rz_select            <= '0';
            when mem_store_reg_at_imm =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '1'; -- changed
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                instruction_register_buffer_enable <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '1'; -- changed
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_data_select            <= mux_select_constants.data_memory_data_rx;
                data_memory_address_select         <= mux_select_constants.data_memory_address_immediate;
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= mux_select_constants.alu_op1_pc;  -- changed
                alu_op2_sel                        <= mux_select_constants.alu_op2_one; -- changed
                register_file_write_select         <= "00";
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1'; -- changed
                pc_write_enable                    <= '1'; -- changed 
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_aluout;
                register_file_rz_select            <= '0';

            when mem_load_direct =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '1'; -- changed
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                instruction_register_buffer_enable <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_data_select            <= "00";
                data_memory_write_enable           <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= "00";
                data_memory_address_select         <= mux_select_constants.data_memory_address_immediate;
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= mux_select_constants.alu_op1_pc;  -- changed
                alu_op2_sel                        <= mux_select_constants.alu_op2_one; -- changed
                register_file_write_select         <= "00";
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '0';
                pc_write_enable                    <= '1';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;
                register_file_rz_select            <= '0';
            when sub_no_store =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                instruction_register_buffer_enable <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= decoded_ALUop; -- changed
                data_memory_data_select            <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= mux_select_constants.alu_op1_immediate; -- changed
                alu_op2_sel                        <= mux_select_constants.alu_op2_rz;        -- changed
                register_file_rz_select            <= '0';
                register_file_write_select         <= mux_select_constants.regfile_write_aluout;
                z_register_write_enable            <= '1'; -- changed
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1'; -- changed
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_alu;
            when jump_imm =>
                jump_select                        <= mux_select_constants.jump_immediate;
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                instruction_register_buffer_enable <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= decoded_ALUop; -- changed
                data_memory_data_select            <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_rz_select            <= '0';
                register_file_write_select         <= mux_select_constants.regfile_write_aluout;
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '0'; -- changed
                pc_write_enable                    <= '1'; -- changed
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_jmp;

            when jump_reg =>
                jump_select                        <= mux_select_constants.jump_rx;
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '1';
                alu_register_write_enable          <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                instruction_register_buffer_enable <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= decoded_ALUop; -- changed
                data_memory_data_select            <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_rz_select            <= '0';
                register_file_write_select         <= mux_select_constants.regfile_write_aluout;
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '1'; -- changed
                pc_write_enable                    <= '1';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_jmp;
            when present_state =>
                jump_select                        <= '0';
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                instruction_register_buffer_enable <= '1';
                dpcr_select                        <= '0';
                alu_op_sel                         <= alu_ops.alu_add; -- changed
                data_memory_data_select            <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= mux_select_constants.alu_op1_rz;
                alu_op2_sel                        <= mux_select_constants.alu_op2_zero;
                register_file_rz_select            <= '0';
                register_file_write_select         <= "00";
                z_register_write_enable            <= '1'; -- changed
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '0';
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '0';
                pc_input_select                    <= mux_select_constants.pc_input_select_jmp;

            when branch_conditional =>
                jump_select                        <= mux_select_constants.jump_immediate;
                DPCRwrite_enable                   <= '0';
                data_memory_register_write_enable  <= '0';
                rz_register_write_enable           <= '0';
                rx_register_write_enable           <= '0';
                alu_register_write_enable          <= '0';
                ssop                               <= '0';
                z_register_reset                   <= '0';
                data_memory_write_enable           <= '0';
                instruction_register_buffer_enable <= '0';
                dpcr_select                        <= '0';
                alu_op_sel                         <= decoded_ALUop; -- changed
                data_memory_data_select            <= "00";
                data_memory_address_select         <= "00";
                register_file_write_enable         <= '0';
                alu_op1_sel                        <= "00";
                alu_op2_sel                        <= "00";
                register_file_rz_select            <= '0';
                register_file_write_select         <= mux_select_constants.regfile_write_aluout;
                z_register_write_enable            <= '0';
                lsip                               <= '0';
                program_memory_read_enable         <= '0';
                instruction_register_write_enable  <= '0'; -- changed
                pc_write_enable                    <= '0';
                pc_branch_conditional              <= '1';
                pc_input_select                    <= mux_select_constants.pc_input_select_jmp;

            when others =>
        end case;

    end process;

    NEXT_STATE_DECODE : process (state, opcode, addressing_mode)
    begin
        case state is
            when instruction_fetch =>
                if (opcode = andr) or
                    (opcode = orr) or
                    (opcode = addr) or
                    (opcode = subvr) or
                    (opcode = subr) or
                    (opcode = str) or
                    (opcode = present) or
                    ((opcode = jmp) and (addressing_mode = am_register)) or
                    ((opcode = ldr) and (addressing_mode = am_register)) then
                    state_decode_fail <= '0';
                    next_state        <= reg_access;

                elsif (opcode = ldr) and (addressing_mode = am_immediate) then
                    state_decode_fail <= '0';
                    next_state        <= load_imm;

                elsif (opcode = ldr) and (addressing_mode = am_direct) then
                    state_decode_fail <= '0';
                    next_state        <= mem_load_direct;

                elsif (opcode = jmp) and (addressing_mode = am_immediate) then
                    state_decode_fail <= '0';
                    next_state        <= jump_imm;

                else
                    state_decode_fail <= '1';
                    next_state        <= instruction_fetch;
                end if;

            when load_imm =>
                state_decode_fail <= '0';
                next_state        <= instruction_fetch;

            when no_op =>
                state_decode_fail <= '0';
                next_state        <= instruction_fetch;

            when reg_access =>

                if (addressing_mode = am_register) and (opcode = ldr) then
                    state_decode_fail <= '0';
                    next_state        <= mem_load_reg;
                elsif (opcode = present) then
                    state_decode_fail <= '0';
                    next_state        <= present_state;
                elsif (opcode = subr) then
                    state_decode_fail <= '0';
                    next_state        <= sub_no_store;
                elsif (opcode = str) and (addressing_mode = am_register) then
                    state_decode_fail <= '0';
                    next_state        <= mem_store_reg_at_reg;
                elsif (opcode = str) and (addressing_mode = am_immediate) then
                    state_decode_fail <= '0';
                    next_state        <= mem_store_imm_at_reg;
                elsif (opcode = str) and (addressing_mode = am_direct) then
                    state_decode_fail <= '0';
                    next_state        <= mem_store_reg_at_imm;
                elsif (opcode = jmp) then
                    state_decode_fail <= '0';
                    next_state        <= jump_reg;
                elsif addressing_mode = am_register then
                    state_decode_fail <= '0';
                    next_state        <= reg_reg;
                elsif addressing_mode = am_immediate then
                    state_decode_fail <= '0';
                    next_state        <= reg_imm;
                else
                    state_decode_fail <= '1';
                    next_state        <= instruction_fetch;
                end if;

            when reg_reg => state_decode_fail              <= '0';
                next_state                                     <= store_reg;

            when sub_no_store => state_decode_fail         <= '0';
                next_state                                     <= instruction_fetch;

            when reg_imm => state_decode_fail              <= '0';
                next_state                                     <= store_reg;

            when store_reg => state_decode_fail            <= '0';
                next_state                                     <= instruction_fetch;

            when mem_store_imm_at_reg => state_decode_fail <= '0';
                next_state                                     <= instruction_fetch;

            when mem_load_reg => state_decode_fail         <= '0';
                next_state                                     <= mem_write_back;

            when mem_load_direct => state_decode_fail      <= '0';
                next_state                                     <= mem_write_back;

            when mem_store_reg_at_reg => state_decode_fail <= '0';
                next_state                                     <= instruction_fetch;

            when mem_store_reg_at_imm => state_decode_fail <= '0';
                next_state                                     <= instruction_fetch;

            when mem_write_back => state_decode_fail       <= '0';
                next_state                                     <= instruction_fetch;

            when jump_imm => state_decode_fail             <= '0';
                next_state                                     <= instruction_fetch;

            when jump_reg => state_decode_fail             <= '0';
                next_state                                     <= instruction_fetch;

            when present_state => state_decode_fail        <= '0';
                next_state                                     <= branch_conditional;

            when branch_conditional => state_decode_fail   <= '0';
                next_state                                     <= instruction_fetch;

            when others =>
        end case;

    end process;

    SYNC : process (clock, reset)
    begin
        if (reset = '1') then
            state <= no_op;
        elsif rising_edge(clock) then
            if enable = '1' then
                state <= next_state;
            end if;
        end if;
    end process;
end architecture;