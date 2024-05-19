puts {
    biglari alu test
}
set top_level              test_library.testbench_control_unit
set wave_patterns {
DUT/state
t_addressing_mode
t_alu_op
t_alu_op1_sel
t_alu_op2_sel
t_alu_reg_write_enable
t_clock
t_dm_addr_select
t_dm_write_enable
t_dmr_enable
t_dpcr_select
t_dprr
t_enable
t_ir_write_enable
t_jump_select
t_opcode
t_pc_branch_conditional
t_pc_input_select
t_pc_write_enable
t_pm_read_enable
t_reg_write_select
t_register_file_write_enable
t_reset
t_rx_register_write_enable
t_rz_register_write_enable
t_sop_write_enable
t_state_decode_fail
t_zero_reg_reset
t_zero_write_enable

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
run 600ns

# if waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  CLLOWNDS SMALLARI
  *************************
}