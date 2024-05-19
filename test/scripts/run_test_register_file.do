puts {
BIGLARI REGISTER_FILE TEST
}
set top_level test_library.testbench_register_file
set wave_patterns {
                t_alu_out
                t_clock
                t_data_memory
                t_immediate
                t_max
                t_register_write_select
                t_reset
                t_rx
                t_rx_index
                t_rz
                t_rz_index
                t_rz_select
                t_sip
                t_write_enable
}

set wave_radices {
}

# Load the simulation
eval vsim $top_level

# If waves are required
set a [if [llength $wave_patterns] {
  noview wave
  foreach pattern $wave_patterns {
    add wave $pattern
  }
  configure wave -signalnamewidth 1
  foreach {radix signals} $wave_radices {
    foreach signal $signals {
      catch {property wave -radix $radix $signal}
    }
  }
}]; list

# Run the simulation
run 500ns

# If waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  YOU JUST GOT  ReC0ped and BIGLARIED
  *************************
}