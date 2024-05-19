## USAGE: `py generate_file_paths.py`

import os

def get_absolute_path(filename):
    absolute_path = os.path.abspath(filename)
    return absolute_path

paths = [{
        "relative_path": "src/programs/loop.mif",
        "variable_name": "loop_program"
        },
        {
        "relative_path": "src/programs/fpga_demonstration.mif",
        "variable_name": "max_program"
        }, 
        {
        "relative_path": "src/programs/fpga_calculator_demo.mif",
        "variable_name": "calculator_program"
        }, 
        {
        "relative_path": "src/programs/biglari.mif",
        "variable_name": "biglari_program"
        }, 
        ]

to_write = []
for path in paths:
    print(get_absolute_path(path["relative_path"]))
    to_write.append({"variable_name": path["variable_name"], 
                   "absolute_path": get_absolute_path(path["relative_path"])})
    
f = open("src/vhdl/utils/file_paths.vhd", "w")

f.write("-- This file should be updated using the script called generate_file_paths.py at the root\n")
f.write("package file_paths is\n")

for absolute_path in to_write:
    print('Writing variable {} with its absolute path {}'.format( 
          absolute_path["variable_name"], 
          absolute_path["absolute_path"]))
    f.write('   constant {} : string := "{}";\n'.format(absolute_path["variable_name"], 
                                                        absolute_path["absolute_path"]))

f.write("end package;")

f.close()



    