# 32-bit Single-Cycle RISC-V Processor 🚀

An educational, fully functional 32-bit single-cycle RISC-V processor written entirely in Verilog from scratch.

This project was built to gain a deep understanding of computer architecture, the RISC-V ISA (Instruction Set Architecture), and datapath integration. It fetches, decodes, and executes 32-bit machine code instructions directly from a memory file.

🧠 Architecture Overview

This processor implements a subset of the **RV32I Base Integer Instruction Set**. It utilizes a single-cycle datapath, meaning every instruction completes its entire journey (Fetch, Decode, Execute, Memory, Write-Back) in exactly one clock cycle.
 Key Components Built:

* Program Counter (PC): Tracks the current execution address.

* Instruction Memory (ROM):Byte-addressable memory that outputs the 32-bit machine code.

* Register File: 32 general-purpose 32-bit registers (`x0` to `x31`).

* ALU (Arithmetic Logic Unit):Performs arithmetic (ADD, SUB) and bitwise logic (AND, OR).

* Control Unit:The "brain" that reads the 7-bit Opcode and orchestrates the multiplexers across the datapath.

* Immediate Generator: Extracts and sign-extends squished 12-bit numbers from I, S, and B-type instructions.

* Data Memory (RAM):Handles loading and storing variables dynamically.

🛠️ Supported Instructions

The processor's Control Unit and Datapath currently support the following core instructions:

* R-Type: `ADD`, `SUB`, `AND`, `OR`

* I-Type: `ADDI`, `LW` (Load Word)

* S-Type: `SW` (Store Word)

* B-Type:`BEQ` (Branch if Equal)
 💻 Simulation & Testing

This processor was designed and simulated using **Xilinx Vivado**.

How to Run:

1. Clone this repository and open the project in Vivado (or your preferred Verilog simulator).

2. Open `program.mem` and write your RISC-V machine code (in hexadecimal format).
   Example: `00500093` translates to `addi x1, x0, 5`)*

3. Ensure `program.mem` is added to your Simulation Sources.

4. Run the behavioral simulation using the `datapath_tb.v` testbench.

5. Monitor the `alu_result_out` and the Register File arrays in the waveform viewer to watch the CPU crunch numbers!

 🔮 Future Improvements

* Add support for `JAL` and `JALR` (Jump instructions).

* Expand the ALU to handle `XOR`, shifts (`SLL`, `SRL`), and comparisons (`SLT`).

* Upgrade the architecture from Single-Cycle to a **5-Stage Pipelined** architecture.

Built with passion and lots of multiplexers!!!:)
