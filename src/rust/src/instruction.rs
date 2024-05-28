pub enum Instruction {
    ANDI,
    ANDR,
    ORI,
    ORR,
    ADDI,
    ADDR,
    SUBI,
    SUBZ,
    LDI,
    LDR,
    LDD,
    STRI,
    STRR,
    STRD,
    J,
    JR,
    PRESENT,
    DATACALLR,
    DATACALLI,
    NBDATACALLR,
    NBDATACALLI,
    SZ,
    CLFZ,
    LSIP,
    SSOP,
    NOOP,
    MAXI,
    STRPC,
}

#[derive(Debug)]
pub enum InstructionFormat {
    RzRxOperand,
    RzRzRx,
    RzOperand,
    RxOperand,
    RzRx,
    Operand,
    Rx,
    Rz,
    Nothing,
}

enum OpCode {
    AND,
    OR,
    ADD,
    SUBR,
    SUBVR,
    LDR,
    STR,
    J,
    PRESENT,
    DATACALLR,
    DATACALLI,
    NBDATACALLR,
    NBDATACALLI,
    SZ,
    CLFZ,
    LSIP,
    SSOP,
    NOOP,
    MAX,
    STRPC,
}

enum InstructionType {
    Immediate,
    Register,
    Direct,
    Inherent,
}

impl OpCode {
    pub fn opcode_bits(&self) -> String {
        match self {
            OpCode::AND => "001000".to_owned(),
            OpCode::OR => "001100".to_owned(),
            OpCode::ADD => "111000".to_owned(),
            OpCode::SUBVR => "000011".to_owned(),
            OpCode::SUBR => "000100".to_owned(),
            OpCode::LDR => "000000".to_owned(),
            OpCode::STR => "000010".to_owned(),
            OpCode::J => "011000".to_owned(),
            OpCode::PRESENT => "011100".to_owned(),
            OpCode::DATACALLR => "101000".to_owned(),
            OpCode::DATACALLI => "101001".to_owned(),
            OpCode::NBDATACALLR => "111111".to_owned(),
            OpCode::NBDATACALLI => "111100".to_owned(),
            OpCode::SZ => "010100".to_owned(),
            OpCode::CLFZ => "010000".to_owned(),
            OpCode::LSIP => "110111".to_owned(),
            OpCode::SSOP => "111010".to_owned(),
            OpCode::NOOP => "110100".to_owned(),
            OpCode::MAX => "011110".to_owned(),
            OpCode::STRPC => "011101".to_owned(),
        }
    }
}

impl InstructionType {
    pub fn am_bits(&self) -> String {
        match self {
            InstructionType::Immediate => "01".to_owned(),
            InstructionType::Register => "11".to_owned(),
            InstructionType::Direct => "10".to_owned(),
            InstructionType::Inherent => "00".to_owned(),
        }
    }
}

impl Instruction {
    pub fn instruction_bits(&self) -> String {
        return self.instruction_addressing_mode() + &self.instruction_opcode();
    }

    fn instruction_addressing_mode(&self) -> String {
        match self {
            Instruction::ANDI => InstructionType::Immediate.am_bits(),
            Instruction::ANDR => InstructionType::Register.am_bits(),
            Instruction::ORI => InstructionType::Immediate.am_bits(),
            Instruction::ORR => InstructionType::Register.am_bits(),
            Instruction::ADDI => InstructionType::Immediate.am_bits(),
            Instruction::ADDR => InstructionType::Register.am_bits(),
            Instruction::SUBI => InstructionType::Immediate.am_bits(),
            Instruction::SUBZ => InstructionType::Immediate.am_bits(),
            Instruction::LDI => InstructionType::Immediate.am_bits(),
            Instruction::LDR => InstructionType::Register.am_bits(),
            Instruction::LDD => InstructionType::Direct.am_bits(),
            Instruction::STRI => InstructionType::Immediate.am_bits(),
            Instruction::STRR => InstructionType::Register.am_bits(),
            Instruction::STRD => InstructionType::Direct.am_bits(),
            Instruction::J => InstructionType::Immediate.am_bits(),
            Instruction::JR => InstructionType::Register.am_bits(),
            Instruction::PRESENT => InstructionType::Immediate.am_bits(),
            Instruction::DATACALLR => InstructionType::Register.am_bits(),
            Instruction::DATACALLI => InstructionType::Immediate.am_bits(),
            Instruction::NBDATACALLR => InstructionType::Register.am_bits(),
            Instruction::NBDATACALLI => InstructionType::Immediate.am_bits(),
            Instruction::SZ => InstructionType::Immediate.am_bits(),
            Instruction::CLFZ => InstructionType::Inherent.am_bits(),
            Instruction::LSIP => InstructionType::Register.am_bits(),
            Instruction::SSOP => InstructionType::Register.am_bits(),
            Instruction::NOOP => InstructionType::Inherent.am_bits(),
            Instruction::MAXI => InstructionType::Immediate.am_bits(),
            Instruction::STRPC => InstructionType::Immediate.am_bits(),
        }
    }

    fn instruction_opcode(&self) -> String {
        match self {
            Instruction::ANDI | Instruction::ANDR => OpCode::AND.opcode_bits(),
            Instruction::ORI | Instruction::ORR => OpCode::OR.opcode_bits(),
            Instruction::ADDI | Instruction::ADDR => OpCode::ADD.opcode_bits(),
            Instruction::SUBI => OpCode::SUBVR.opcode_bits(),
            Instruction::SUBZ => OpCode::SUBR.opcode_bits(),
            Instruction::LDI | Instruction::LDR | Instruction::LDD => OpCode::LDR.opcode_bits(),
            Instruction::STRI | Instruction::STRR | Instruction::STRD => OpCode::STR.opcode_bits(),
            Instruction::J | Instruction::JR => OpCode::J.opcode_bits(),
            Instruction::PRESENT => OpCode::PRESENT.opcode_bits(),
            Instruction::DATACALLR => OpCode::DATACALLR.opcode_bits(),
            Instruction::DATACALLI => OpCode::DATACALLI.opcode_bits(),
            Instruction::NBDATACALLR => OpCode::NBDATACALLR.opcode_bits(),
            Instruction::NBDATACALLI => OpCode::NBDATACALLI.opcode_bits(),
            Instruction::SZ => OpCode::SZ.opcode_bits(),
            Instruction::CLFZ => OpCode::CLFZ.opcode_bits(),
            Instruction::LSIP => OpCode::LSIP.opcode_bits(),
            Instruction::SSOP => OpCode::SSOP.opcode_bits(),
            Instruction::NOOP => OpCode::NOOP.opcode_bits(),
            Instruction::MAXI => OpCode::MAX.opcode_bits(),
            Instruction::STRPC => OpCode::STRPC.opcode_bits(),
        }
    }

    pub fn instruction_format(self) -> InstructionFormat {
        match self {
            Instruction::ANDR | Instruction::ADDR | Instruction::ORR => InstructionFormat::RzRzRx,

            Instruction::ADDI | Instruction::ORI | Instruction::ANDI | Instruction::SUBI =>
                InstructionFormat::RzRxOperand,

            Instruction::LDR | Instruction::STRR => InstructionFormat::RzRx,

            | Instruction::JR
            | Instruction::DATACALLI
            | Instruction::NBDATACALLI
            | Instruction::STRD => InstructionFormat::RxOperand,

            | Instruction::MAXI
            | Instruction::STRI
            | Instruction::LDI
            | Instruction::PRESENT
            | Instruction::LDD
            | Instruction::SUBZ => InstructionFormat::RzOperand,

            Instruction::J | Instruction::STRPC | Instruction::SZ => InstructionFormat::Operand,

            Instruction::SSOP | Instruction::DATACALLR | Instruction::NBDATACALLR =>
                InstructionFormat::Rx,

            Instruction::LSIP => InstructionFormat::Rz,

            Instruction::NOOP | Instruction::CLFZ => InstructionFormat::Nothing,
        }
    }

    pub fn from_str(input: &str) -> Option<Self> {
        match input {
            "ANDI" | "andi" => Some(Instruction::ANDI),
            "ANDR" | "andr" => Some(Instruction::ANDR),
            "ORI" | "ori" => Some(Instruction::ORI),
            "ORR" | "orr" => Some(Instruction::ORR),
            "ADDI" | "addi" => Some(Instruction::ADDI),
            "ADDR" | "addr" => Some(Instruction::ADDR),
            "SUBI" | "subi" => Some(Instruction::SUBI),
            "SUBZ" | "subz" => Some(Instruction::SUBZ),
            "LDI" | "ldi" => Some(Instruction::LDI),
            "LDR" | "ldr" => Some(Instruction::LDR),
            "LDD" | "ldd" => Some(Instruction::LDD),
            "STRI" | "stri" => Some(Instruction::STRI),
            "STRR" | "strr" => Some(Instruction::STRR),
            "STRD" | "strd" => Some(Instruction::STRD),
            "J" | "j" => Some(Instruction::J),
            "JR" | "jr" => Some(Instruction::JR),
            "PRESENT" | "present" => Some(Instruction::PRESENT),
            "DATACALLR" | "datacallr" => Some(Instruction::DATACALLR),
            "DATACALLI" | "datacalli" => Some(Instruction::DATACALLI),
            "NBDATACALLR" | "nbdatacallr" => Some(Instruction::NBDATACALLR),
            "NBDATACALLI" | "nbdatacalli" => Some(Instruction::NBDATACALLI),
            "SZ" | "sz" => Some(Instruction::SZ),
            "CLFZ" | "clfz" => Some(Instruction::CLFZ),
            "LSIP" | "lsip" => Some(Instruction::LSIP),
            "SSOP" | "ssop" => Some(Instruction::SSOP),
            "NOOP" | "noop" => Some(Instruction::NOOP),
            "MAXI" | "maxi" => Some(Instruction::MAXI),
            "STRPC" | "strpc" => Some(Instruction::STRPC),
            _ => None,
        }
    }
}

#[derive(Debug)]
pub struct InstructionEntry {
    pub instruction_format: InstructionFormat,
    pub instruction: String,
    pub arg_one: Option<String>,
    pub arg_two: Option<String>,
    pub arg_three: Option<String>,
}

impl InstructionEntry {
    pub fn new(instruction: String, instruction_format: InstructionFormat) -> Self {
        Self {
            instruction_format: instruction_format,
            instruction: instruction,
            arg_one: None,
            arg_two: None,
            arg_three: None,
        }
    }

    pub fn encode_instruction(self) -> String {
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
