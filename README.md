# CPLD Frequency Meter

A hardware-based digital frequency measurement system designed for CPLD architectures. The repository includes VHDL/Verilog source implementations, hardware pin constraints, Proteus schematic diagrams, and project simulation archives.

## Hardware Schematic & Circuit Design

Below is the complete hardware schematic illustrating the XC9572XL CPLD pin connections, LM016L LCD display wiring, 10 MHz crystal oscillator divider circuit, and FT232RL programmer interface:

![Hardware Schematic](<docs/cpld simu.jpg>)

## File Directory & Explanations

### `src/` — Hardware Logic Source
* **`frequencyDetector.vhdl`**: Core VHDL implementation containing top-level module entity, clock divider, dual-counter gating mechanism, and register latches.
* **`FreqDetector.v`**: Verilog translation of the main frequency detection hardware logic.

### `constraints/` — Hardware & Programming Specifications
* **`lcd_driver.ucf`**: User Constraints File defining physical pin assignments on the CPLD for LCD segment display output.
* **`lcd_driver.svf`**: Serial Vector Format file for directly flashing compiled LCD interface logic onto the CPLD.
* **`led_timer.svf`**: SVF bitstream configured for driving timer and status LED indicators on hardware.

### `docs/` — Schematics & Simulation Data
* **`cpld simu.jpg`**: Proteus circuit schematic export showing hardware components, pin maps, and clock division wiring.
* **`cpld simu.PDF`**: High-resolution vector print of the schematic circuit.
* **`cpld simu.pdsprj.zip`**: Archived Proteus Design Suite project file containing the interactive circuit schematic and simulation environment.

## System Architecture

* **Clock Source & Division**: A 10 MHz crystal oscillator feeds a 4060 binary counter/divider (using pin Q3 to divide by 16) to generate a 625 kHz reference clock for the CPLD logic.
* **CPLD Target**: Built for the Xilinx XC9572XL CPLD (`VQG44` package) to run sampling gating windows and target signal frequency counting.
* **Display Interface**: Direct parallel wiring from CPLD I/O ports to an LM016L character LCD module for live frequency readouts.
* **Programming Interface**: FT232RL USB interface mapping JTAG signals (`TCK`, `TDI`, `TDO`, `TMS`) directly to the CPLD for flashing via `.svf` files.

## Getting Started

### Prerequisites
* Xilinx ISE WebPACK / Intel Quartus Prime
* Labcenter Proteus (for opening `.pdsprj` schematic files)

### Simulation Setup
1. Extract `docs/cpld simu.pdsprj.zip` into your working folder.
2. Open the project in Labcenter Proteus to review the full schematic and run interactive hardware simulation.
