mod opcodes;

use std::env;
use std::fs;
// use std::fs::File;
// use std::io::prelude::*;
// use std::path::Path;

use crate::opcodes::Instruction;

struct InstructionEntry {
    instruction: String,
    rz: String,
    rx: String,
    operand: String,
}

impl InstructionEntry {
    fn new() -> Self {
        Self {
            instruction: "".to_string(),
            rz: "".to_string(),
            rx: "".to_string(),
            operand: "".to_string(),
        }
    }
    /* 
    fn to_output_line(&self) -> String {
        return self.instruction.push_str(&self.rz) + &self.rz + &self.rx + &self.operand;
    }
*/
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let file_path = &args[1];
    // let save_path = Path::new(&args[2]);
    // let display = save_path.display();

    // let mut file = match File::create(&save_path) {
    //     Err(why) => panic!("couldn't create {}: {}", display, why),
    //     Ok(file) => file,
    // };

    println!("The file {} was opened", file_path);

    // let mut instuction_list: &str;

    for line in fs::read_to_string(file_path).unwrap().lines() {
        let mut current_instruction: InstructionEntry = InstructionEntry::new();
        println!("Current line is {}", line);

        let split_line: Vec<&str> = line.split_whitespace().collect();
        let line_arg_length = split_line.len();
        // Instruction
        current_instruction.instruction = Instruction::from_str(Some(split_line[0]).unwrap())
            .unwrap()
            .instruction_bits();

        println!("The instruction bits are: {}", current_instruction.instruction);

        // Register
        if line_arg_length > 1 {
            if split_line[1].contains("$r") {
                let reg_num: i32 = isolate_number("$r", split_line[1]);
                current_instruction.rz = format!("{:04b}", reg_num);
                println!("Num : {}", split_line[1]);
            } else {
                let operand_num: i32 = isolate_number("#", split_line[1]);
                current_instruction.operand = format!("{}", operand_num);
            }
        }

        println!("The Register bits are: {}", current_instruction.rz);

        // if line_arg_length > 2 {
        //     if split_line[1].contains("$r") {
        //         let reg_num: i32 = isolate_number("$r", split_line[1]);
        //         current_instruction.rx = format!("{:b}", reg_num);
        //     } else {
        //         let operand_num: i32 = isolate_number("#", split_line[1]);
        //         current_instruction.operand = format!("{}", operand_num);
        //     }
        // }

        // if line_arg_length > 3 {
        //     if split_line[1].contains("$r") {
        //         let reg_num: i32 = isolate_number("$r", split_line[1]);
        //         current_instruction.rz = format!("{:b}", reg_num);
        //     } else {
        //         let operand_num: i32 = isolate_number("#", split_line[1]);
        //         current_instruction.operand = format!("{}", operand_num);
        //     }
        // }

        // // Immediate / Register
        // if cursor.next().is_some() {
        //     println!("Has next");
        // }
    }
    /* 
    match file.write_all(instruction_list.as_bytes()) {
        Err(why) => panic!("couldn't write to {}: {}", display, why),
        Ok(_) => println!("successfully wrote to {}", display),
    }
*/
}

fn isolate_number(delimiter: &str, value: &str) -> i32 {
    return value.split(delimiter).collect::<Vec<_>>()[1].parse().unwrap_or(0);
}
