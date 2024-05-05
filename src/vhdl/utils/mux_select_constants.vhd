library ieee;
use ieee.std_logic_1164.all;
use work.recop_types.all;

package mux_select_constants is
   -- PC
   constant pc_input_select_aluout : std_logic := '0';
   constant pc_input_select_jmp : std_logic := '1';

   -- Instruction register

   -- ALU
   -- OP1
   constant alu_op1_rz : std_logic_vector(1 downto 0) := "00";
   constant alu_op1_pc : std_logic_vector(1 downto 0) := "01";
   constant alu_op1_immediate : std_logic_vector(1 downto 0) := "10";

   -- OP2 
   constant alu_op2_rx : std_logic_vector(1 downto 0) := "00";
   constant alu_op2_zero : std_logic_vector(1 downto 0) := "01";
   constant alu_op2_one : std_logic_vector(1 downto 0) := "10";
   constant alu_op2_rz : std_logic_vector(1 downto 0) := "11";

end mux_select_constants;