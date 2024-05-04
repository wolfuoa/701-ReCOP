library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

entity control_unit is
   port (
      clk : in STD_LOGIC;
      reset : in STD_LOGIC;
      opcode : in STD_LOGIC_VECTOR(7 downto 0);
      dprr : in STD_LOGIC;
      aluOp2_sel : out STD_LOGIC_VECTOR(1 downto 0);
      jump_sel : out STD_LOGIC;
      DPCRwrite_en : out STD_LOGIC;
      dmr_en : out STD_LOGIC;
      rz_write_en : out STD_LOGIC;
      rx_write_en : out STD_LOGIC;
      alu_reg_write_en : out STD_LOGIC;
      sop_write_en : out STD_LOGIC;
      zero_reg_reset : out STD_LOGIC;
      dm_write_en : out STD_LOGIC;
      dpcr_sel : out STD_LOGIC;
      alu_op : out STD_LOGIC_VECTOR(2 downto 0);
      dm_addr_sel : out STD_LOGIC_VECTOR(1 downto 0);
      regfile_write_en : out STD_LOGIC;
      aluOp1_sel : out STD_LOGIC_VECTOR(1 downto 0);
      reg_write_select : out STD_LOGIC_VECTOR(1 downto 0);
      zero_write_en : out STD_LOGIC;
      sip_ld : out STD_LOGIC;
      pm_read_en : out STD_LOGIC;
      ir_write_en : out STD_LOGIC;
      pc_write_en : out STD_LOGIC;
      pc_branch_cond : out STD_LOGIC;
      pc_write_sel : out STD_LOGIC
   );

end entity control_unit;

architecture rtl of control_unit is
   type state_type is (instruction_fetch, reg_access, reg_reg_op, store_reg); -- TODO: Add all other states 
   signal state, next_state : state_type;
begin
   CYCLE_OUTPUT_DECODE : process (state)
   begin
      case(state) is
         when instruction_fetch =>
         ir_write_en <= '1';
         pm_read_en <= '1';
         aluOp1_sel <= "01";
         aluOp2_sel <= "10";
         alu_reg_write_en <= '1';

         when reg_access =>
         pc_write_en <= '1';
         pc_write_sel <= '1';
         rz_write_en <= '1';
         rx_write_en <= '1';

         when reg_reg_op =>
         alu_reg_write_en <= '1';
         alu_op <= ; -- TODO: implement ALU opcode
      end case;

   end process;

   NEXT_STATE_DECODE : process (state)
   begin

   end process;

   SYNC : process (clk)
   begin
      if rising_edge(clk) then
         if (reset = '1') then
            state <= instruction_fetch;
         else
            state <= next_state;
         end if;
      end if;
   end process;
end architecture;