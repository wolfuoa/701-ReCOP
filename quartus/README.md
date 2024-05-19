# Quartus

To compile and flash the program onto a `DE1-SOC` board you should:

1. open the file `Recop.qpf` and hit compile.
2. open the programmer and select `Auto Detect`
3. choose `5CSEMAF31` and change the file to `Recop.sof` which will be under an `output_files` directory

> ![NOTE]
> The default program is the adder. To write your own refer to the documentation in `src\rust\README.md`
