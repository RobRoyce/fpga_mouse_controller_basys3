# basys3_usb_mouse
A simple interface for controlling the Basys3 FPGA via mouse using Verilog (created and tested in Vivado)

## How it works
- Step 1) Take in the PS2 clock and data signals.
- Step 2) Use a double-buffered FIFO to de-serialize messages from the mouse.
- Step 3) Extract the 44-bit message into 4 11-bit words (assumes the "IntelliMouse" protocol is in use).
- Step 4) Validate each word using start, stop, and parity bits (combinational).
- Step 5) Map the output signals to bit patterns in the messages.
- Step 6) Output a `valid` signal when data is `ready` and `valid`.
----

## How to use it
You should be able to import the four files into your project and instantiate a
`ps2_mouse` module. 

Simply feed the `ps2_mouse` module the following signals:

- 100MHz clock (`i_clk`)
- Reset (`i_reset`)
- PS2 Clock (`i_PS2Clk`)
- PS2 Data (`i_PS2Data`)

You will get the following signals in return:

- x movement (`o_x`)
- y movement (`o_y`)
- x direction (`o_x_sign`)
- y direction (`o_y_sign`)
- left click (`o_l_click`)
- right click (`o_r_click`)
- valid signal (`o_valid`)
----

## Notes
The top level `o_valid` signal is a logical AND between the `valid` signal
coming from the `ps2_validator` and the `ready` signal coming from the
`ps2_signal`. This means you will only ever see a new /valid/ signal when new
data arrives and it is properly validated.
