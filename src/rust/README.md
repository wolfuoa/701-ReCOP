## Assember instructions

| Instruction Name | Usage                                               | Instruction Type |
| ---------------- | --------------------------------------------------- | ---------------- |
| ANDI             | ANDI Rz Rx #Operand : Rz <- Rx AND #Operand         | Immediate        |
| ANDR             | ANDR Rz Rz Rx : Rz <- Rz AND Rx                     | Register         |
| ORI              | ORI Rz Rx #Operand : Rz <- Rx OR #Operand           | Immediate        |
| ORR              | ORR Rz Rz Rx : Rz <- Rz OR Rx                       | Register         |
| ADDI             | ADDI Rz Rx #Operand : Rz <- Rx + #Operand           | Immediate        |
| ADDR             | ADDR Rz Rz Rx : Rz <- Rz + Rx                       | Register         |
| SUBI             | SUBI Rz Rx #Operand : Rz <- Rx - #Operand           | Immediiate       |
| SUBZ (SUB ZORAN) | SUBZ Rz #Operand : ZORAN[0] <- Rz - #Operand        | **Zoran**        |
| LDI              | LDI Rz #Operand : Rz <- #Operand                    | Immediate        |
| LDR              | LDR Rz Rx : Rz <- M[Rx]                             | Register         |
| LDD              | LDD Rz $Operand : Rz <- M[$Operand]                 | Direct           |
| STRI             | STRI Rz #Operand : M[Rz] <- Operand                 | Immediate        |
| STRR             | STRR Rz Rx : M[Rz] <- Rx                            | Register         |
| STRD             | STRD Rx $Operand : M[$Operand] <- Rx                | Direct           |
| J                | J #Operand : PC <- #Operand                         | Immediate        |
| JR               | J Rx : PC <- Rx                                     | Register         |
| PRESENT          | PRESENT Rz #Operand : PC <- #Operand if Rz = 0x0000 | Immediate        |
| DATACALLR        | DATACALLR Rx : DPCR <- Rx & $r7                     | Register         |
| DATACALLI        | DATACALLI Rx #Operand <- DPCR <- Rx & #Operand      | Immediate        |
| SZ               | SZ #Operand : PC <- Operand if Z = 0x0001           | Immediate        |
| CLFZ             | CLFZ : Z <- 0x0000                                  | Inherent         |
| LSIP             | LSIP Rz : Rz <- SIP                                 | Register         |
| SSOP             | SSOP Rx : SOP <- Rx                                 | Register         |
| NOOP             | NOOP : :clown_face:                                 | Inherent         |
| MAXI             | MAXI Rz #Operand : Rz <- MAX{Rz, #Operand}          | Immediate        |
| STRPC            | STRPC $Operand : M[$Operand] <- PC                  | Direct           |

## Instruction Formats

| Instructions | Format        |
| ------------ | ------------- |
|              | Rz Rx Operand |
|              | Rz Rz Rx      |
|              | Rz Operand    |
|              | Rx Operand    |
|              | Rz Rx         |
|              | Operand       |
|              | Rx            |
|              | Rz            |
|              | Nothing       |

MAX $r5, #1000
(AM+OPCODE)(0101)(1000)(format)
let new instruciton ; str
if format is rx operand
new_instruction AMOPCODE + 0000 + 0101 + 1000
