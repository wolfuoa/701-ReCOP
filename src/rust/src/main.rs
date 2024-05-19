mod instruction;

use crate::instruction::Instruction;
use crate::instruction::InstructionEntry;
use crate::instruction::InstructionFormat;

use std::borrow::Borrow;
use std::env;
use std::fs;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

static FILE_HEADER: &str =
    "DEPTH = 65536;\nWIDTH = 32;\nADDRESS_RADIX = DEC;\nDATA_RADIX = BIN;\nCONTENT\nBEGIN\n";
static FILE_END: &str = "END;";

fn main() {
    let args: Vec<String> = env::args().collect();
    let file_path = &args[1];
    let save_path = Path::new(&args[2]);
    let display = save_path.display();

    let mut file = match File::create(&save_path) {
        Err(why) => panic!("couldn't create {}: {}", display, why),
        Ok(file) => file,
    };

    println!("The file {} was opened", file_path);

    let mut program: String = FILE_HEADER.to_string();
    let mut program_counter: i32 = 0;
    for line in fs::read_to_string(file_path).unwrap().lines() {
        println!("Current line is {}", line);

        if line.trim().is_empty() || line.trim().starts_with("--") {
            continue;
        }

        let comments_removed: &str = line.split("--").collect::<Vec<_>>()[0];

        println!("Current comment removed line is {}", comments_removed);

        let split_line: Vec<&str> = comments_removed.split_whitespace().collect();
        let line_arg_length = split_line.len();

        // Instruction
        let parsed_instruction = Instruction::from_str(Some(split_line[0]).unwrap()).unwrap();

        let mut current_instruction: InstructionEntry = InstructionEntry::new(
            parsed_instruction.instruction_bits(),
            parsed_instruction.instruction_format()
        );

        // println!("The instruction bits are: {}", current_instruction.instruction);

        // Register
        if line_arg_length > 1 {
            current_instruction.arg_one = Some(process_argument(&split_line[1]));
        }

        if line_arg_length > 2 {
            current_instruction.arg_two = Some(process_argument(&split_line[2]));
        }

        if line_arg_length > 3 {
            current_instruction.arg_three = Some(process_argument(&split_line[3]));
        }

        let encoded_instruction = current_instruction.encode_instruction();

        program.push_str(&format!("{} : ", program_counter));
        program.push_str(&format!("{};\n", encoded_instruction));

        program_counter += 1;
        // println!("{}", encoded_instruction);
    }

    program.push_str(FILE_END);

    match file.write_all(program.as_bytes()) {
        Err(why) => panic!("couldn't write to {}: {}", display, why),
        Ok(_) => println!("successfully wrote to {}", display),
    }
}

fn isolate_number(delimiter: &str, value: &str) -> Option<i32> {
    return Some(value.split(delimiter).collect::<Vec<_>>()[1].parse().unwrap());
}

fn process_argument(arg: &str) -> String {
    if arg.contains("$r") {
        let reg_num: i32 = isolate_number("$r", arg).unwrap();
        return format!("{:04b}", reg_num);
    } else {
        let operand_num: i32 = isolate_number("#", arg).unwrap();
        return format!("{:016b}", operand_num);
    }
}
