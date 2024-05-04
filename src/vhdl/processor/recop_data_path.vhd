library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.recop_types.all;
use work.opcodes.all;
use work.various_constants.all;

entity recop_data_path is
    port (
        clock : in std_logic;
        packet : in std_logic_vector(31 downto 0);
        reset : in std_logic;

        -- Control unit inputs
        pc_write_enable : in std_logic;
        pc_input_select : in std_logic;
        instruction_register_write_enable : in std_logic;
        rz_register_write_enable: in std_logic;
        rx_register_write_enable: in std_logic;

        -- Outputs for the control unit
        addressing_mode : out std_logic_vector(1 downto 0);
        opcode : out std_logic_vector(5 downto 0)
    );
end recop_data_path;

-- 

architecture bhv of recop_data_path is
    signal jump_address : std_logic_vector(15 downto 0);
    signal alu_out : std_logic_vector(15 downto 0);
    signal pc : std_logic_vector(15 downto 0);

    signal instruction : std_logic_vector(31 downto 0);
    signal rz_index : std_logic_vector(3 downto 0);
    signal rx_index : std_logic_vector(3 downto 0);
    signal immediate : std_logic_vector(15 downto 0);

    signal rz_register_value_in : std_logic_vector(15 downto 0);
    signal rx_register_value_in : std_logic_vector(15 downto 0);

    signal rz_register_value_out : std_logic_vector(15 downto 0);
    signal rx_register_value_out : std_logic_vector(15 downto 0);
begin

    pc_inst : entity work.pc
        generic map(
            START_ADDR => (others => '0')
        )
        port map(
            clock => clock,
            reset => reset,
            write_enable => pc_write_enable,
            pc_input_select => pc_input_select,
            jump_address => jump_address,
            alu_out => alu_out,
            pc => pc
        );

    prog_mem_inst : entity work.prog_mem
        port map(
            address => pc,
            clock => clock,
            q => instruction
        );

    instruction_register_inst : entity work.instruction_register
        port map(
            clock => clock,
            reset => reset,
            write_enable => instruction_register_write_enable,
            instruction => instruction,
            addressing_mode => addressing_mode,
            opcode => opcode,
            rz => rz_index,
            rx => rx_index,
            immediate => immediate
        );
    -- Register file

    -- Operand Regs

    rx: entity work.operand_register
     port map(
        clock => clock,
        reset => reset,
        write_enable => rx_register_write_enable,
        data_in => rx_register_value_in,
        data_out => rx_register_value_out
    );

    rz: entity work.operand_register
     port map(
        clock => clock,
        reset => reset,
        write_enable => rz_register_write_enable,
        data_in => rz_register_value_in,
        data_out => rz_register_value_out
    );

    -- ALU

    -- ALU Reg

    -- Data Memory

    -- MDR
end bhv;