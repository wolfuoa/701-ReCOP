-- Zoran Salcic
library ieee;
use ieee.std_logic_1164.all;
use work.recop_types.all;

package alu_constants is
	-- * ALU operation select defined as alu_op
	constant alu_add : std_logic_vector(1 downto 0) := "00";
	constant alu_sub : std_logic_vector(1 downto 0) := "01";
	constant alu_and : std_logic_vector(1 downto 0) := "10";
	constant alu_or : std_logic_vector(1 downto 0) := "11";
end alu_constants;