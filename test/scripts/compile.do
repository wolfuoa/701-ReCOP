puts {
  *****************************
  BIGLARI-COMPILER FOR MODELSIM
  *****************************
}

set library_file_list {
                           design_library {
                                           ../../src/vhdl/utils/file_paths.vhd
                                           
                                           ../../src/vhdl/utils/recop_types.vhd
                                           ../../src/vhdl/utils/mux_select_constants.vhd
                                           ../../src/vhdl/utils/opcodes.vhd
                                           ../../src/vhdl/utils/alu_ops.vhd

                                           ../../src/vhdl/arith/max.vhd
                                           ../../src/vhdl/arith/alu.vhd

                                           ../../src/vhdl/memory/data_mem.vhd
                                           ../../src/vhdl/memory/prog_mem.vhd

                                           ../../src/vhdl/processor/pc.vhd
                                           ../../src/vhdl/processor/instruction_register.vhd
                                           ../../src/vhdl/processor/register_buffer.vhd
                                           ../../src/vhdl/processor/register_file.vhd
                                           ../../src/vhdl/processor/control_unit.vhd
                                           ../../src/vhdl/processor/data_path.vhd


                                           ../../src/vhdl/processor/top_level.vhd
                           }
                           test_library   {
                                           ../testbench_alu.vhd
                                           ../testbench_control_unit_immediate.vhd
                                           ../testbench_control_unit_register.vhd
                                           ../testbench_pc.vhd
                                           ../testbench_register_file.vhd
                                           ../testbench_data_memory.vhd
                                           ../testbench_register_buffer.vhd
                                           ../testbench_instruction_register.vhd
                                           ../testbench_control_unit.vhd
                                           ../testbench_top_level.vhd
                                           ../testbench_integration.vhd
                           }
}

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

catch {
  vlib work
}

foreach {library file_list} $library_file_list {
  vlib $library
  vmap $library work
  foreach file $file_list {
    if [regexp {.vhdl?$} $file] {
    vcom -93 $file
    } else {
    vlog $file
    }
  }
}

puts {
  *************************************************************************************************
  All files successfully compiled. You may now run the .do scripts that are prefixed with 'run_test' 
  *************************************************************************************************

  Q: wHaT iS rEc0P?????
  A: You asking questions that make NO SENSE

}

  