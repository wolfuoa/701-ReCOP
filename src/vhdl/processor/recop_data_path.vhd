

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

USE work.recop_types.ALL;
USE work.opcodes.ALL;
USE work.various_constants.ALL;

ENTITY recop_data_path IS
    PORT (
        clk    : IN  bit_1;
        packet : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        reset  : IN  bit_1

        -- External Signal I/O
        SOP    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIP    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    );
END recop_data_path;

-- 

ARCHITECTURE bhv OF recop_data_path IS

    SIGNAL PC :

    COMPONENT prog_mem IS
        PORT (
            address : IN  STD_LOGIC_VECTOR (14 DOWNTO 0);
            clock   : IN  STD_LOGIC := '1';
            q       : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT data_mem IS
        PORT (
            address : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
            clock   : IN  STD_LOGIC := '1';
            data    : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
            wren    : IN  STD_LOGIC;
            q       : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT register_file IS
        PORT (
            clk          : IN  bit_1;
            init         : IN  bit_1;
            -- control signal to allow data to write into Rz
            ld_r         : IN  bit_1;
            -- Rz and Rx select signals
            sel_z        : IN  INTEGER RANGE 0 TO 15;
            sel_x        : IN  INTEGER RANGE 0 TO 15;
            -- register data outputs
            rx           : OUT bit_16;
            rz           : OUT bit_16;
            -- select signal for input data to be written into Rz
            rf_input_sel : IN  bit_3;
            -- input data
            ir_operand   : IN  bit_16;
            dm_out       : IN  bit_16;
            aluout       : IN  bit_16;
            rz_max       : IN  bit_16;
            sip_hold     : IN  bit_16;
            er_temp      : IN  bit_1;
            -- R7 for writing to lower byte of dpcr
            r7           : OUT bit_16;
            dprr_res     : IN  bit_1;
            dprr_res_reg : IN  bit_1;
            dprr_wren    : IN  bit_1

        );
    END COMPONENT;

    COMPONENT alu IS
        PORT (
            clk           : IN  bit_1;
            z_flag        : OUT bit_1;
            -- ALU operation selection
            alu_operation : IN  bit_3;
            -- operand selection
            alu_op1_sel   : IN  bit_2;
            alu_op2_sel   : IN  bit_1;
            alu_carry     : IN  bit_1; --WARNING: carry in currently is not used
            alu_result    : OUT bit_16 := X"0000";
            -- operands
            rx            : IN  bit_16;
            rz            : IN  bit_16;
            ir_operand    : IN  bit_16;
            -- flag control signal
            clr_z_flag    : IN  bit_1;
            reset         : IN  bit_1);
    END COMPONENT;

    COMPONENT registers IS
        PORT (
            clk          : IN  bit_1;
            reset        : IN  bit_1;
            dpcr         : OUT bit_32;
            r7           : IN  bit_16;
            rx           : IN  bit_16;
            ir_operand   : IN  bit_16;
            dpcr_lsb_sel : IN  bit_1;
            dpcr_wr      : IN  bit_1;
            -- environment ready and set and clear signals
            er           : OUT bit_1;
            er_wr        : IN  bit_1;
            er_clr       : IN  bit_1;
            -- end of thread and set and clear signals
            eot          : OUT bit_1;
            eot_wr       : IN  bit_1;
            eot_clr      : IN  bit_1;
            -- svop and write enable signal
            svop         : OUT bit_16;
            svop_wr      : IN  bit_1;
            -- sip souce and registered outputs
            sip_r        : OUT bit_16;
            sip          : IN  bit_16;
            -- sop and write enable signal
            sop          : OUT bit_16;
            sop_wr       : IN  bit_1;
            -- dprr, irq (dprr(1)) set and clear signals and result source and write enable signal
            dprr         : OUT bit_2;
            irq_wr       : IN  bit_1;
            irq_clr      : IN  bit_1;
            result_wen   : IN  bit_1;
            result       : IN  bit_1);
    END COMPONENT;

END bhv;