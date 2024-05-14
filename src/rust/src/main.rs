mod opcodes;

use std::borrow::Borrow;
use std::env;
use std::fs;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

use opcodes::InstructionFormat;

use crate::opcodes::Instruction;

#[derive(Debug)]
struct InstructionEntry {
    instruction_format: InstructionFormat,
    instruction: String,
    arg_one: Option<String>,
    arg_two: Option<String>,
    arg_three: Option<String>,
}

impl InstructionEntry {
    fn new(instruction: String, instruction_format: InstructionFormat) -> Self {
        Self {
            instruction_format: instruction_format,
            instruction: instruction,
            arg_one: None,
            arg_two: None,
            arg_three: None,
        }
    }

    fn encode_instruction(self) -> String {
        println!("The instruction for the current line is: {:?}", self);
        match self.instruction_format {
            InstructionFormat::RzRxOperand =>
                format!(
                    "{}{}{}{}",
                    self.instruction,
                    self.arg_one.unwrap(),
                    self.arg_two.unwrap(),
                    self.arg_three.unwrap()
                ),

            InstructionFormat::RzRzRx =>
                format!(
                    "{}{}{}{:016b}",
                    self.instruction,
                    self.arg_one.unwrap(),
                    self.arg_three.unwrap(),
                    0
                ),

            InstructionFormat::RzOperand =>
                format!(
                    "{}{}{:04b}{}",
                    self.instruction,
                    self.arg_one.unwrap(),
                    0,
                    self.arg_two.unwrap()
                ),

            InstructionFormat::RxOperand =>
                format!(
                    "{}{:04b}{}{}",
                    self.instruction,
                    0,
                    self.arg_one.unwrap(),
                    self.arg_two.unwrap()
                ),

            InstructionFormat::RzRx =>
                format!(
                    "{}{}{}{:016b}",
                    self.instruction,
                    self.arg_one.unwrap(),
                    self.arg_two.unwrap(),
                    0
                ),

            InstructionFormat::Operand =>
                format!("{}{:04b}{:04b}{}", self.instruction, 0, 0, self.arg_one.unwrap()),

            InstructionFormat::Rx =>
                format!("{}{:04b}{}{:016b}", self.instruction, 0, self.arg_one.unwrap(), 0),

            InstructionFormat::Rz =>
                format!("{}{}{:04b}{:016b}", self.instruction, self.arg_one.unwrap(), 0, 0),

            InstructionFormat::Nothing =>
                format!("{}{:04b}{:04b}{:016b}", self.instruction, 0, 0, 0),
        }
    }
}

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

    let mut program: String = "".to_string();

    for line in fs::read_to_string(file_path).unwrap().lines() {
        println!("Current line is {}", line);

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
        program.push_str(&encoded_instruction);
        // println!("{}", encoded_instruction);
    }

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
