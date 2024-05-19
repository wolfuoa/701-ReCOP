puts {
    TOP LEVEL TEST
}
set top_level              test_library.testbench_integration
set wave_patterns {
                            t_clock
                            top_level_inst/data_path_inst/register_file/regs(15)
                            top_level_inst/data_path_inst/register_file/regs(14)
                            top_level_inst/data_path_inst/register_file/regs(13)
                            top_level_inst/data_path_inst/register_file/regs(12)
                            top_level_inst/data_path_inst/register_file/regs(11)
                            top_level_inst/data_path_inst/register_file/regs(10)
                            top_level_inst/data_path_inst/register_file/regs(9)
                            top_level_inst/data_path_inst/register_file/regs(8)
                            top_level_inst/data_path_inst/register_file/regs(7)
                            top_level_inst/data_path_inst/register_file/regs(6)
                            top_level_inst/data_path_inst/register_file/regs(5)
                            top_level_inst/data_path_inst/register_file/regs(4)
                            top_level_inst/data_path_inst/register_file/regs(3)
                            top_level_inst/data_path_inst/register_file/regs(2)
                            top_level_inst/data_path_inst/register_file/regs(1)
                            top_level_inst/data_path_inst/register_file/regs(0)
                            top_level_inst/control_uniinst/state
                            top_level_inst/data_memory_inst/data_in
                            top_level_inst/data_memory_inst/data_out
                            top_level_inst/data_path_inst/pc_inst/pc
                            top_level_inst/data_path_inst/instruction_register_inst/next_instruction 
}
set wave_radices {
                           hexadecimal {
                                regs(15)
                                regs regs(14)
                                regs regs(13)
                                regs regs(12)
                                regs regs(11)
                                regs regs(10)
                                regs regs(9)
                                regs regs(8)
                                regs regs(7)
                                regs regs(6)
                                regs regs(5)
                                regs regs(4)
                                regs regs(3)
                                regs regs(2)
                                regs regs(1)
                                regs regs(0)
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
run 5000ns

# If waves are required
if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  *************************
  YOU JUST GOT STACK FRAMED
  *************************
}