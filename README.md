# Moving Average Filter (Practice writing a testbench)
## Overview
This repository contains the RTL implementation and verification environment for a Moving Average Filter (MAF). A moving average filter is commonly used in digital signal processing to smooth a series of input data by calculating the average of a fixed number of previous inputs. This filter is useful in noise reduction and trend identification in various applications, such as data smoothing in communication systems.

## Key Features:
- Simoole parameterizable window size for calculating the moving average.
- RTL design using SystemVerilog.
  
## Verification Focus
The primary focus of this project is on developing and validating verification methodologies for digital designs. The testbench and verification environment are designed to provide thorough testing coverage of the moving average filter. 
This repository presents testbenches increasing in difficulty.

### Tools and Methodologies
- RTL Design: Verilog/SystemVerilog.
- Testbench: Built using SystemVerilog 

## Different tests
### 1. Simple testbench
The most primitive code for testbecnh. This testbench performs basic functionality checks for the moving average filter. It includes:

- A clock generation process.
- Initialization and reset logic.
- Multiple test cases with constant and changing input values.
- Verification of the output using $display and $error to check if the average is calculated correctly.

### 2. Testbench with Events
This testbench introduces more structured testing:

- It includes arrays for input and expected data.
- Utilizes an event-driven approach for checking results.
- The test checks a series of inputs and compares the output with precomputed expected values in real-time.

### 3. Testbench with Monitoring and Randomization
This is a more advanced testbench:

- It features random input data generation using `$urandom_range`.
- Uses a `mailbox` to pass data between the monitor and checker.
- Implements a monitor to capture the input/output and a checking process to validate the results.
- It also calculates the expected output dynamically based on the input data window, ensuring a thorough verification.

These testbenches progressively add complexity, from simple checks to more sophisticated verification techniques with events, randomization, and monitoring.
 
