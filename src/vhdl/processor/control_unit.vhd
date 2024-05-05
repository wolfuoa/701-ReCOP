library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

entity control_unit is
   port (
      clock : in std_logic;
      reset : in std_logic;
      adressing_mode : in std_logic_vector(1 downto 0);
      opcode : in std_logic_vector(5 downto 0);
      dprr : in std_logic;
      aluOp2_select : out std_logic_vector(1 downto 0);
      jump_select : out std_logic;
      DPCRwrite_enable : out std_logic;
      dmr_enable : out std_logic;
      rz_write_enable : out std_logic;
      rx_write_enable : out std_logic;
      alu_reg_write_enable : out std_logic;
      sop_write_enable : out std_logic;
      zero_reg_reset : out std_logic;
      dm_write_enable : out std_logic;
      dpcr_select : out std_logic;
      alu_op : out std_logic_vector(2 downto 0);
      dm_addr_select : out std_logic_vector(1 downto 0);
      regfile_write_enable : out std_logic;
      aluOp1_select : out std_logic_vector(1 downto 0);
      reg_write_select : out std_logic_vector(1 downto 0);
      zero_write_enable : out std_logic;
      sip_ld : out std_logic;
      pm_read_enable : out std_logic;
      ir_write_enable : out std_logic;
      pc_write_enable : out std_logic;
      pc_branch_cond : out std_logic;
      pc_write_select : out std_logic
   );

end entity control_unit;

architecture rtl of control_unit is
   type state_type is (instruction_fetch, reg_access, reg_reg, reg_imm, load_imm, store_reg); -- TODO: Add all other states 
   signal state, next_state : state_type;
   signal decoded_ALUop : std_logic_vector(2 downto 0);
begin

   ALU_OP_DECODE : process (opcode, adressing_mode)
   begin

      case adressing_mode is
            --when am_inherent =>

         when am_immediate => -- Uses immediate value
            case opcode is
               when ldr =>
                  alu_op <= alu_add; -- * Doesn't matter as ALU is bypassed into Data Memory
               when str =>
                  alu_op <= alu_add; -- * Doesn't matter as ALU is bypassed into Data Memory
               when andr =>
                  alu_op <= alu_and;
               when orr =>
                  alu_op <= alu_or;
               when addr =>
                  alu_op <= alu_add;
               when subr =>
                  alu_op <= alu_sub;
               when subvr =>
                  alu_op <= alu_sub;
            end case;
         when am_direct => -- Uses registeres Rx and Ry 
            case opcode is
               when ldr =>
                  alu_op <= alu_add; -- * Doesn't matter as ALU is bypassed into Data Memory
               when str =>
                  alu_op <= alu_add; -- * Doesn't matter as ALU is bypassed into Data Memory
               when andr =>
                  alu_op <= alu_and;
               when orr =>
                  alu_op <= alu_or;
               when addr =>
                  alu_op <= alu_add;
               when subr =>
                  alu_op <= alu_sub;
               when subvr =>
                  alu_op <= alu_sub;
            end case;
            --when am_register => -- 

         when others =>
            alu_op <= "UUU";

      end case;

   end process;

   CYCLE_OUTPUT_DECODE : process (state)
   begin
      case(state) is
         when instruction_fetch =>
         ir_write_enable <= '1';
         pm_read_enable <= '1';
         aluOp1_select <= "01";
         aluOp2_select <= "10";
         alu_reg_write_enable <= '1';

         when reg_access =>
         pc_write_enable <= '1';
         pc_write_select <= '1';
         rz_write_enable <= '1';
         rx_write_enable <= '1';

         when reg_reg =>
         alu_reg_write_enable <= '1';
         alu_op <= decoded_ALUop;
         aluOp1_select <= "00";
         aluOp2_select <= "00";
         zero_write_enable <= '1';

         when reg_imm =>
         alu_reg_write_enable <= '1';
         alu_op <= decoded_ALUop;
         aluOp1_select <= "10";
         aluOp2_select <= "00";
         zero_write_enable <= '1';

         when load_imm =>
         pc_write_enable <= '1';
         pc_write_select <= '1';
         reg_write_select <= "00";
         regfile_write_enable <= '1';

         when store_reg =>
         regfile_write_enable <= '1';
         reg_write_select <= "01";
      end case;

   end process;

   NEXT_STATE_DECODE : process (state)
   begin
      case(state) is
         when instruction_fetch =>
         next_state <= reg_access when (opcode = (andr or orr or addr or subvr)) else
            load_imm;

         when load_imm =>
         next_state <= instruction_fetch;

         when reg_access =>
         next_state <= reg_reg when (opcode = (andr or orr or addr or subvr)) else
            reg_imm;

         when reg_reg =>
         next_state <= store_reg;

         when reg_imm =>
         next_state <= store_reg;

         when store_reg =>
         next_state <= instruction_fetch;

      end case;

   end process;

   SYNC : process (clock, reset)
   begin
      if (reset = '1') then
         state <= instruction_fetch;
      else
         if rising_edge(clock) then
            state <= next_state;
         end if;
      end if;
   end process;
end architecture;