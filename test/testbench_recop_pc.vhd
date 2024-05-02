LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY testbench_recop_pc IS
END testbench_recop_pc;

ARCHITECTURE arch OF testbench_recop_pc IS
    SIGNAL t_clk      : STD_LOGIC;
    SIGNAL t_wren     : STD_LOGIC;
    SIGNAL t_reset    : STD_LOGIC;

    SIGNAL t_addr_new : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL t_out_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);

    COMPONENT pc IS
        PORT (
            clock    : IN  STD_LOGIC;
            reset    : IN  STD_LOGIC;

            -- Control Signals
            wren     : IN  STD_LOGIC;

            -- Data Signals
            addr_new : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    DUT : pc PORT MAP(
        clock    => t_clk,
        reset    => t_reset,
        wren     => t_wren,
        addr_new => t_addr_new,
        out_addr => t_out_addr
    );

    PROCESS
    BEGIN

        WAIT FOR 100 ns;
        t_addr_new <= x"0F0F";
        WAIT FOR 100 ns;
        t_addr_new <= x"7EA5";
        WAIT FOR 100 ns;
        t_addr_new <= x"6432";
        WAIT FOR 100 ns;
        t_addr_new <= x"DEAD";
        WAIT FOR 100 ns;
        t_addr_new <= x"BEEF";
        WAIT FOR 100 ns;
        t_addr_new <= x"BADD";
        WAIT FOR 100 ns;
        t_addr_new <= x"BEAD";
        WAIT FOR 100 ns;
        t_addr_new <= x"9A2B";

    END PROCESS;

    PROCESS
    BEGIN
        t_reset <= '1';
        WAIT FOR 10 ns;
        t_reset <= '0';
        WAIT;
    END PROCESS;

    PROCESS
    BEGIN
        t_wren <= '0';
        WAIT FOR 10 ns;
        t_wren <= '1';
        WAIT;
    END PROCESS;

    PROCESS
    BEGIN
        t_clk <= '1';
        WAIT FOR 10 ns;
        t_clk <= '0';
        WAIT FOR 10 ns;
    END PROCESS;
END arch; -- testbench_recop_pc