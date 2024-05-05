library ieee;
  use ieee.std_logic_1164.all;

library altera_mf;
  use altera_mf.all;

entity data_memory is
  port (
    clock          : in  std_logic;
    reset          : in  std_logic;

    -- Writing Data
    input_select   : in  std_logic_vector(1 downto 0);
    immediate      : in  std_logic_vector(15 downto 0);
    alu_out        : in  std_logic_vector(15 downto 0);
    rx             : in  std_logic_vector(15 downto 0);
    write_enable   : in  std_logic;

    -- Reading Data
    address_select : in  std_logic;
    data_out       : out std_logic_vector(15 downto 0)

  );
end entity;

architecture bhv of data_memory is

  signal next_output : std_logic_vector(15 downto 0);
  signal data_in     : std_logic_vector(15 downto 0);
  signal address_in  : std_logic_vector(15 downto 0);

begin

  with input_select select data_in <=
    immediate when "00",
    alu_out   when "01",
    rx        when "10",
    x"0000"   when others;

  with address_select select address_in <=
    immediate when '0',
    rx        when '1',
    x"0000"   when others;

  ram: entity altera_mf.altsyncram
    generic map (
      clock_enable_input_a   => "BYPASS",
      clock_enable_output_a  => "BYPASS",
      intended_device_family => "Cyclone V",
      lpm_hint               => "ENABLE_RUNTIME_MOD=NO",
      lpm_type               => "altsyncram",
      numwords_a             => 4096,
      operation_mode         => "SINGLE_PORT",
      outdata_aclr_a         => "NONE",
      outdata_reg_a          => "UNREGISTERED",
      power_up_uninitialized => "FALSE",
      ram_block_type         => "M4K",
      widthad_a              => 16,
      width_a                => 16,
      width_byteena_a        => 1
    )
    port map (
      address_a => address_in,
      clock0    => clock,
      data_a    => data_in,
      wren_a    => write_enable,
      q_a       => next_output
    );

  data_out <= next_output;

end architecture; -- bhv
