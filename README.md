# 701-ReCOP

Thank you for viewing 701-ReCOP: A repository to document the development process of a multicycle reactive coprocessor.

A Reactive Coprocessor (ReCOP) is a RISC architecture novel processor designed to enable time-predictable dynamic processing capabilities within a heterogeneous multiprocessor system on chip. The intended application for ReCOPs is within mixed-critical and real-time embedded systems, in which they provide a general purpose, time predictable, and safe processing capability. This ability is crucial for multi-core systems that inherently require a time-predictable communication and processing network. In addition to common RISC ISA instructions, ReCOP has the capability to efficiently execute instructions required for the context of a Network on Chip (NOC).

This project was developed in COMPSYS 701 Advanced Digital Systems Design offered by the University of Auckland, and was written by Part IV Computer Systems Engineers Nicholas Wolf and Benson Cho. The project entails the process to diagram, program, test, and verify the functionality of a time-predictable ReCOP. The processor is required to handle its original instruction set as well as additional instructions required for its intended application. Going further, the design and implementation of a ReCOP enables a practical demonstration of its functionality within a NOC. In this case, the intention is that ReCOP is employed as a controlling body for the configuration of application specific processors embedded in a NOC. This way, the ReCOP is able to offload computationally expensive signal processing work to application specific processors which function as hardware accelerators for specific signal processing functions.

## Getting Started

> [!WARNING] > **All commands** listed in this readme **must** be run from the a terminal thats the same directory as this `README.md`

> [!IMPORTANT]
> Before you start anything run `py generate_file_paths.py` from a terminal in the _same_ directory as this `README` in order to get the correct paths to run synthesis and simulations

Take a look at the `/src` folder. The `/src` folder contains the majority of the work regarding programming. The `/src/vhdl` directory contains all VHDL files representative of the final ReCOP implementation. Within `/src/vhdl` are subfolders describing the domain that the `.vhd` files belong to. The `/processor` subfolder contains the most important parts of the processor, and typically contains centralized hardware components such as the datapath and the top level. `top_level.vhd` is the main processor entity which is used to integrate the ReCOP with other hardware projects. The subfolder `/rust` contains a custom Rust assembler for ReCOP assembly. More information on usage is nested within `/rust/README.md`.

The `/test` folder contains all of the modelsim testbenches used to evaluate our processor. please refer to `/src/README.md` for further instructions on usage.

The `/docs` folder contains all research material, project resources, writing, and conceptual design work.

The `/quartus` folder contains all required resources for compiling and synthesizing the ReCOP onto an FPGA.

## Description of the System

Our ReCOP is a reactive, time-predictable processor designed for use within a NoC. It features common RISC instructions as well as special purpose ReCOP reactive instructions. The processor employs a multicycle architecture, meaning that each instruction takes a variable amount of clock cycles to complete. The processor is Big-Endian and the instruction fetch is 32-bits wide. The registers are 16 bits wide. There is currently no floating point support as the instruction set is purposefully limited.

## Testing with Modelsim

### Compiling all files

1. Run the command `py .\test\scripts\open_modelsim.py` in your _system_ terminal. This will open modelsim and compile all files
2. Select a script based on the test bench you want to run. You should type these commands into the _modelsim_ terminal. Usage: `do <script name>`

### Available testbench scripts

- `run_test_alu.do` testbenches ALU
- `run_test_loop.do` testbenches complete recop with a loop program (can be found in `src\assembly\loop_demonstration.mips`)
- `run_test_program_counter.do` testbenches the PC
- `run_test_top_level.do` testbenches the suite of _ALL_ recop instructions

> [!NOTE]
> All scripts have the intended configuration automated, feel free to tinker with the waves and runtime

## Editing the programs/code

Please Refer to the nested README.md files for comprehensive instructions on testing existing programs and writing your own assembly programs.
