puts {
    BIGLARI PC TEST
}
set top_level              test_library.testbench_pc
set wave_patterns {
      alu_out
      jump_address
      out_pc
      pc
      t_alu
      t_clock
      t_pc_input_select
      t_reset
      t_write_enable
}

set wave_radices {
                           hexadecimal {
                              jump_address
                           }
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
run 150ns

# If waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  YOU JUST GOT  ReC0ped
  *************************
}