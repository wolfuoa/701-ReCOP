puts {
    BIGLARI ALU TEST
}
set top_level              test_library.testbench_alu
set wave_patterns {
        t_alu_op1_sel
        t_alu_op2_sel
        t_alu_operation
        t_alu_result
        t_immediate
        t_pc
        t_rx
        t_rz
        t_zero
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
  YOU JUST GOT  ReC0ped
  *************************
}