LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
USE work.recop_types.ALL;
USE work.opcodes.ALL;
USE work.various_constants.ALL;

ENTITY control_unit IS
   PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      opcode : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      dprr : IN STD_LOGIC;
      aluOp2_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      jump_sel : OUT STD_LOGIC;
      DPCRwrite_en : OUT STD_LOGIC;
      dmr_en : OUT STD_LOGIC;
      rz_write_en : OUT STD_LOGIC;
      rx_write_en : OUT STD_LOGIC;
      alu_reg_write_en : OUT STD_LOGIC;
      sop_write_en : OUT STD_LOGIC;
      zero_reg_reset : OUT STD_LOGIC;
      dm_write_en : OUT STD_LOGIC;
      dpcr_sel : OUT STD_LOGIC;
      alu_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      dm_addr_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      regfile_write_en : OUT STD_LOGIC;
      aluOp1_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      reg_write_select : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      zero_write_en : OUT STD_LOGIC;
      sip_ld : OUT STD_LOGIC;
      pm_read_en : OUT STD_LOGIC;
      ir_write_en : OUT STD_LOGIC;
      pc_write_en : OUT STD_LOGIC;
      pc_branch_cond : OUT STD_LOGIC;
      pc_write_sel : OUT STD_LOGIC
   );

END ENTITY control_unit;

ARCHITECTURE rtl OF control_unit IS
   TYPE state_type IS (instruction_fetch); -- TODO: Add all other states 
   SIGNAL state, next_state : state_type;
BEGIN

   OUTPUT_DECODE : PROCESS (state)
   BEGIN
      CASE(state) IS
         WHEN instruction_fetch =>
         ir_write_en <= '1';
         pm_read_en <= '1';
         aluOp1_sel <= "01";
         aluOp2_sel <= "10";
         alu_reg_write_en <= '1';

      END CASE;

   END PROCESS;

   NEXT_STATE_DECODE : PROCESS (state)
   BEGIN

   END PROCESS;

   SYNC : PROCESS (clk)
   BEGIN
      IF rising_edge(clk) THEN
         IF (reset = '1') THEN
            state <= instruction_fetch;
         ELSE
            state <= next_state;
         END IF;
      END IF;
   END PROCESS;
END ARCHITECTURE;