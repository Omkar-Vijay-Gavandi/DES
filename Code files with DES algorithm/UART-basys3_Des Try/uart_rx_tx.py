import serial           # Import the module
import struct
import time

# Open the COM port
ComPort = serial.Serial('/dev/ttyUSB1') 
ComPort.baudrate = 115200
ComPort.bytesize = 8
ComPort.parity = 'N'
ComPort.stopbits = 1

print("Enter 2 sixteen-bit numbers.\nThe concatenated data will be printed")
print("Press 'q' to exit infinite loop at any time")

while True:
    # Input first 16-bit number
    x = input("Enter number 1 (16-bit integer): ")
    if x == 'q':
        break
    
    # Send first 16-bit number to FPGA
    ComPort.write(struct.pack('h', int(x)))  # 'h' for 16-bit integer

    # Input second 16-bit number
    y = input("Enter number 2 (16-bit integer): ")
    ComPort.write(struct.pack('h', int(y)))  # Send second 16-bit number to FPGA

    # Read 8 bytes (64 bits) from FPGA
    it = ComPort.read(8)

    # Convert received bytes to a 64-bit integer
    result = int.from_bytes(it, byteorder='big')

    print(f"Result = {result}")

# Close the COM port
ComPort.close()

