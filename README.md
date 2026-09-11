# CPLD Frequency Meter

A hardware-based digital frequency measurement system designed for CPLD architectures. The repository includes VHDL/Verilog source implementations, hardware pin constraints, and Proteus simulation archives.

## Hardware Simulation

Below is the verified waveform output showing signal timing, gating windows, and pulse count latching:

![Simulation Waveform](docs/cpld%20simu.jpg)

## File Directory & Explanations

### `src/` — Hardware Logic Source
* **`frequencyDetector.vhdl`**: Core VHDL implementation containing top-level module entity, clock divider, dual-counter gating mechanism, and register latches.
* **`FreqDetector.v`**: Verilog translation of the main frequency detection hardware logic.

### `constraints/` — Hardware & Programming Specifications
* **`lcd_driver.ucf`**: User Constraints File defining physical pin assignments on the CPLD for LCD segment display output.
* **`lcd_driver.svf`**: Serial Vector Format file for directly flashing compiled LCD interface logic onto the CPLD.
* **`led_timer.svf`**: SVF bitstream configured for driving timer and status LED indicators on hardware.

### `docs/` — Schematics & Simulation Data
* **`cpld simu.jpg`**: Captured waveform screenshot displaying real-time frequency measurement signals.
* **`cpld simu.PDF`**: Architectural document and detailed schematic prints.
* **`cpld simu.pdsprj.zip`**: Archived Proteus Design Suite workspace containing the interactive circuit testbench.

## Architecture & How It Works

1. **Gate Window Generation**: An internal clock divider scales down system frequency to create an accurate measurement sampling period.
2. **Dual-Counter Pulse Accumulation**: Dual counters track rising edge pulses of incoming high-frequency signals while gate controls remain active.
3. **Latch & Register Output**: Active counts latch to internal output registers at the end of every gate interval before counter reset cycles trigger.

## Getting Started

### Prerequisites
* Xilinx ISE WebPACK / Intel Quartus Prime
* Labcenter Proteus (for `.pdsprj` simulation)

### Simulation Setup
1. Extract `docs/cpld simu.pdsprj.zip` into your working folder.
2. Load `src/frequencyDetector.vhdl` inside your EDA platform or Proteus VSM simulator.
3. Run simulation to review register counts matching `docs/cpld simu.jpg`.
