library ieee;
  use ieee.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity register_file is
  port (
    clock                 : in  std_logic;
    reset                 : in  std_logic;

    -- control signal to allow data to write into Rz
    write_enable          : in  std_logic;

    -- Rz and Rx select signals, i.e to select r12
    rz_index              : in  integer range 0 to 15;
    rx_index              : in  integer range 0 to 15;

    -- register data outputs
    rx                    : out std_logic_vector(15 downto 0);
    rz                    : out std_logic_vector(15 downto 0);

    -- select rz from IR or r7
    rz_select             : in  std_logic;

    -- select signal for input data to be written into Rz
    register_write_select : in  std_logic_vector(1 downto 0);

    -- input data
    immediate             : in  std_logic_vector(15 downto 0);
    data_memory           : in  std_logic_vector(15 downto 0);
    alu_out               : in  std_logic_vector(15 downto 0);
    sip                   : in  std_logic_vector(15 downto 0)
  );
end entity;

architecture beh of register_file is
  type reg_array is array (15 downto 0) of std_logic_vector(15 downto 0);
  signal regs          : reg_array;
  signal temp_rz_index : integer range 0 to 15;
  signal data_input_z  : std_logic_vector(15 downto 0);
begin

  -- mux selecting address for Rz
  register_z_select_mux: process (rz_select, rz_index, temp_rz_index)
  begin
    case rz_select is
      when '0' =>
        temp_rz_index <= rz_index; -- From IR
      when '1' =>
        temp_rz_index <= 7; -- If we need value of R7 for DATACALL
      when others =>
        temp_rz_index <= rz_index;
    end case;
  end process;

  -- mux selecting input data to be written to Rz

  input_select_mux: process (register_write_select, immediate, data_memory, alu_out, sip)
  begin
    case register_write_select is
      when "00" =>
        data_input_z <= immediate;
      when "01" =>
        data_input_z <= alu_out;
      when "10" =>
        data_input_z <= data_memory;
      when "11" =>
        data_input_z <= sip;
      when others =>
        data_input_z <= X"0000";
    end case;
  end process;

  process (clock, reset)
  begin
    if reset = '1' then
      regs <= ((others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'),(others => '0'));
    elsif rising_edge(clock) then
      -- write data into Rz if ld signal is asserted
      if write_enable = '1' then
        if (rz_select = '1') then
          regs(temp_rz_index) <= data_input_z;
        end if;
      end if;
    end if;
  end process;

  rx <= regs(rx_index);
  rz <= regs(temp_rz_index);

end architecture;
