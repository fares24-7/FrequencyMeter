# CPLD Frequency Meter

A digital frequency measurement system built for a CPLD using VHDL and Verilog. It measures incoming signal frequencies via synchronous gating logic and displays results on an LCD screen.

---

## Hardware Schematic

Below is the circuit setup featuring the Xilinx XC9572XL CPLD, 10 MHz reference clock divider, LCD screen, and FT232RL programmer interface:

![Hardware Schematic](<docs/cpld simu.jpg>)

---

## Repository Structure

* **`src/`**
  * `frequencyDetector.vhdl`: Core VHDL code containing clock division, dual counters, and data latches.
  * `FreqDetector.v`:         Equivalent Verilog source implementation.

* **`constraints/`**
  * `lcd_driver.ucf`: Pin mapping file connecting CPLD signals to the LCD screen.
  * `lcd_driver.svf`: Programmed bitstream for the LCD interface.
  * `led_timer.svf`:  Flashing file for status LEDs and timing control.

* **`docs/`**
  * `cpld simu.jpg`:        Schematic capture image.
  * `cpld simu.PDF`:        High-resolution vector schematic print.
  * `cpld simu.pdsprj.zip`: Proteus project archive for interactive circuit simulation.

---

## Technical Summary

1. **Clock Reference**:    A 10 MHz crystal oscillator connects to a 4060 binary divider (pin Q3) to feed a stable 625 kHz clock into the CPLD.
2. **Measurement Logic**:  Dual counters sample incoming signal pulses during a gated timing window, latching the result to registers before resetting.
3. **Display & Flashing**: Output count is sent via parallel I/O to an LM016L LCD. Programming is done through JTAG using the FT232RL USB interface and `.svf` files.

---

## How to Run

1. Extract `docs/cpld simu.pdsprj.zip`.
2. Open `cpld simu.pdsprj` in Labcenter Proteus to simulate the schematic and inspect LCD readouts.
