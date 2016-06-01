# vga-terminal
VGA terminal using the Digilent Nexys 4 DDR.

How it works: Characters are sent over the USB-UART bridge and stored in RAM. These characters are used as addresses into a character ROM, which holds the appearance of each character. Based on the pixel the monitor is currently drawing, data from the ROM is sent to the screen, to display either a black or white pixel.

Usage: Connect the Nexys 4 to a VGA monitor. With the FTDI drivers, installed, connect the Nexys 4 to the computer's USB port. Using a terminal program (e.g. TeraTerm), letters typed will show up on the monitor. The lines wrap automatically at the end of each line and after the last line.