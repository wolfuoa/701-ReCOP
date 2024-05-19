puts {
    biglari alu test
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

# load the simulation
eval vsim $top_level

# if waves are required
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

# run the simulation
run 500ns

# if waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  you just got  rec0ped
  *************************
}