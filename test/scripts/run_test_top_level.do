puts {
    TOP LEVEL TEST
}
set top_level              test_library.testbench_top_level
set wave_patterns {
                            control_unit_inst/clock
                            data_path_inst/register_file/regs(15)
                            data_path_inst/register_file/regs(14)
                            data_path_inst/register_file/regs(13)
                            data_path_inst/register_file/regs(12)
                            data_path_inst/register_file/regs(11)
                            data_path_inst/register_file/regs(10)
                            data_path_inst/register_file/regs(9)
                            data_path_inst/register_file/regs(8)
                            data_path_inst/register_file/regs(7)
                            data_path_inst/register_file/regs(6)
                            data_path_inst/register_file/regs(5)
                            data_path_inst/register_file/regs(4)
                            data_path_inst/register_file/regs(3)
                            data_path_inst/register_file/regs(2)
                            data_path_inst/register_file/regs(1)
                            data_path_inst/register_file/regs(0)
                            control_unit_inst/state
                            data_memory_inst/data_in
                            data_memory_inst/data_out
                            data_path_inst/pc_inst/pc
                            data_path_inst/instruction_register_inst/next_instruction 
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