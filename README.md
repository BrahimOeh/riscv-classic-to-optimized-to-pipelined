# 🧠 From a Classic Multicycle , Resource Optimized to Custom Pipelined RISC-V Cores
![license](https://img.shields.io/badge/license-MIT-purple)
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-181717?style=flat&logo=github&logoColor=white)](https://github.com/BrahimOeh?tab=repositories)        [![Intel](https://img.shields.io/badge/Altera_DE2_FPGA-Intel-blue?style=flat&logo=intel&logoColor=white&logoSize=auto)](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=53&No=30&PartNo=1#contents)
[![LinkedIn](https://custom-icon-badges.demolab.com/badge/LinkedIn-0A66C2?logo=linkedin-white&logoColor=fff)](https://www.linkedin.com/in/brahimoeh) [![RISC-V](https://img.shields.io/badge/RISC--V-Open%20ISA-blueviolet?style=flat)](https://riscv.org)
![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/RISC-V-logo.svg/1920px-RISC-V-logo.svg.png)

This repository contains a complete RISC-V processor design and tooling suite, built incrementally from a classic multicycle implementation to an optimized pipelined architecture, including a lightweight assembler and memory integration tools. The project is targeted for FPGA deployment (tested on Altera DE2 board) and supports basic system-on-chip (SoC) capabilities.


---
## 📚 Table of Contents
- [Overview](#-overview)
- [Features](#-features)
- [Processor Versions](#%EF%B8%8F-processor-versions)
- [Assembler Toolchain](#%EF%B8%8F-assembler-toolchain)
- [Project Structure](#-project-structure)
- [Usage](#-usage)
- [Future Work](#-future-work)
- [Contributors](#-contributors)
- [License](#-license)

---

## 🧩 Overview

This project explores RISC-V processor architecture and microarchitecture through a progressive hardware implementation:

1. **Classic Multicycle Design**: Educational baseline implementation following Harris & Harris textbook.
2. **BraRV32**: A clean, FPGA-friendly multicycle core with modular components.
3. **Pipelined RISC-V Core**: Optimized with hazard detection, forwarding, and efficient FSM control.

Accompanied by:
- A lightweight **Python-based assembler**
- A **memory merging utility** for `.txt`, `.tv`, `.mif` generation
- Minimal I/O interface for integration with external memory and peripherals

---

## ✨ Features

- ✅ RV32I Instruction Set (Base Integer Instructions)
- ✅ Modular ALU, Register File, FSM Control Unit
- ✅ Pipeline Registers: IF/ID, ID/EX, EX/MEM, MEM/WB
- ✅ Hazard Detection and Forwarding Units
- ✅ Assembly-to-Binary Conversion Tool (Python)
- ✅ Memory Initialization File (.mif/.tv) Generator
- ✅ Top-Level Integration with 7-Segment Display and Debug Support

---

## 🏗️ Processor Versions

| Version         | Description                                  | Implementation        |
|----------------|----------------------------------------------|------------------------|
| `classic_multicycle (Risc_V)` | Textbook-style 5-stage FSM CPU             | Pure Verilog RTL       |
| `BraV32`       | Clean multicycle core for FPGA/SoC integration | Modular Verilog        |
| `pipeline_riscv (CPU_RISCV_pipeline)`| Optimized pipelined core with hazard handling | Advanced RTL + FSM     |

---

## ⚙️ Assembler Toolchain

A minimal assembler written in Python supporting:
- Label resolution and PC-relative addressing
- Binary encoding for all base RV32I instructions: 
`add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`, `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`, `lb`, `lh`, `lw`, `lbu`, `lhu`, `sb`, `sh`, `sw`, `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`, `jal`, `jalr`, `lui`, `auipc`

- Output formats: `.txt`, `.tv` (binary per line)

### Example Usage

```bash
#Go to the appropriate working directory
#make sure to have all your RISC-V assembly codes and labels in the same folder (more on this on chapter 7 of the documentation)
cd C:\<depending_on_your_path>\Assembler
# Assemble a RISC-V program
python wrapper.py
```
You'll be prompted to:

- Enter source folder containing .s or .txt files

- Enter label addresses or path to label file

- Output a unified memory file for synthesis (.tv, .mif)

## 📁 Project Structure
```pgsql
├── rtl_cores/
│   ├── Risc_V  /             # Classic_multicycle
│   ├── BraRV32_DE2/          # Clean modular multicycle core
│   └── CPU_RISCV_pipeline/   # Pipelined CPU with hazard unit
├── Assembler/
│   ├── RISC_V_Assembler.py   # Instruction encoder
│   ├── label_inputs.py       # Label offset handler
│   ├── Wrapper.py            # User interface wrapper
│   ├── mif_merger.py # for Unified mem program (when it comes to synthesis 
│   │ # cause file manipulation functions are only supported at simulation)
│   ├── main.txt    #The RISC-V assembly programs
│   ├── fib.txt
│   ├── labels.txt  #and the parsed labels file
├── memory/
│   ├── combine_to_mif.py         # Memory merger for multiple binaries
│   └── output/                      	 # Generated .tv/.mif files
├── Programming_FLASH_files_FPGA_DE2/    # Sample assembly programs
├── docs/                         # Diagrams, design notes, and report
├── Documentation (Final Report)  #Complete and rigorous documentation
└── README.md
```
## 🚀 Usage
### → Requirements
- Python 3.7+
- Quartus II (13.0sp1 for DE2 FPGA compatibility)
- ModelSim (optional for simulation)

### → Simulation or Synthesis
Load the Verilog design in Quartus, use SignalTap or the 7SEG debug outputs to monitor execution.

## 🔭 Future Work
- ✅ Instruction Testbench & Formal Verification

- ⏳ Cache and MMU Implementation

- ⏳ AMBA/AXI SoC Bus Integration

- ⏳ Support for More RISC-V Extensions (e.g., M, C)

- ⏳ Debugger/Disassembler Interface


## 👥 Contributors
**[OUELD EL HAIRECH Brahim]**
• [AGHADJOUR Zakaria ] 
• [ ELMADI  Choaib ] 
• [ ETTOUGUI  Hoda ]
• [ EL HAZMIRI  Ayoub ]
• [ENNACHAT  Firdaous]

► Special thanks to Mr. Hamzaoui  **(ENSA Marrakech)** for his expert mentorship and guidance.

## 📜 License
This project is open-source under the MIT License. See the LICENSE file for details.

# “Simplicity is the ultimate sophistication.” — Leonardo da Vinci

