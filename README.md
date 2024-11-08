# **DES Encryption and Transmission Over UART Channel**

---

### **Objective**
Send data through UART, encrypt (Minimum DES encryption) data in the FPGA using any encryption algorithm, and send encrypted data back to the PC.

---

### **Authors**

- **Omkar Vijay Gavandi** (IIIT Bangalore, M.Tech in VLSI)
- **Gourab Kundu** (IIIT Bangalore, M.Tech in VLSI)
- **Bibin B Jacob** (IIIT Bangalore, M.Tech in VLSI)

---

### **Overview**

The project task has been divided into three subcategories, based on discussions with our mentor:

1. **Understanding UART and the DES Algorithm**: Implement 8-bit UART reception and transmission.
2. **Modifying UART Block**: Extend UART from 8-bit to 64-bit data transmission and reception.
3. **Integrating DES Module**: Embed the DES module within the 64-bit UART Top-controller to combine both codes.

---

## **Overview of DES Algorithm**

The Data Encryption Standard (DES) is a symmetric-key algorithm for digital data encryption. Though its 56-bit key length is insufficient for security in modern applications, it has played a crucial role in cryptography.

- **Inputs**: 64-bit data message and a 64-bit key
- **Rounds**: 16 rounds, each with unique 48-bit round keys derived from the initial 64-bit key

The DES encryption process involves permutations and substitutions across rounds, with final encryption produced after 16 iterations.

![image](https://github.com/user-attachments/assets/7b28f0c0-3929-4599-8fff-c78ee21af83f)


---

### **DES Encryption Steps**

1. **Initial Permutation**: Permute the 64-bit data.
2. **Feistel Cipher Rounds** (16 total):
   - **Expansion**: Right half (32 bits) expanded to 48 bits.
   - **Key Mixing**: XOR with 48-bit round key.
   - **Substitution**: 48-bit result divided into eight 6-bit segments, reduced to 4 bits via S-box substitution.
   - **Permutation**: 32-bit output is permuted.
3. **Final Permutation**: A reverse of the initial permutation, applied to generate the final 64-bit ciphertext.

---

### **Key Scheduling**

A 64-bit key (user-generated or predefined) is transformed into multiple 48-bit subkeys for each round. Bits are discarded and remaining bits are shifted and permuted as per the DES round requirements.

![Key Transformation](https://github.com/user-attachments/assets/9df979ca-d306-4bae-93bc-3c65dbc42b5b)

---

## **Overview of UART**

UART (Universal Asynchronous Receiver Transmitter) enables serial communication between two devices via only two wires. It's configured to ensure both devices share the same data format and transmission speed (baud rate).

### **UART Data Format**

1. **Start Bit**: Signals the beginning of data transfer.
2. **Data Bits**: Typically 8 bits for each byte of data.
3. **Optional Parity Bit**: Error detection by ensuring an even or odd count of 1s.
4. **Stop Bit**: Signals the end of data transfer.

![UART Data Format](https://github.com/user-attachments/assets/d6551f04-cafa-4091-a9a4-06efeded2552)

---

### **Proposed Solution**

Our solution takes two 16-bit numbers from the user, combines them into a 32-bit number, and adds 32 zero-padded bits to create a 64-bit data packet. This data is then encrypted on the FPGA and sent back to the PC, where the encrypted data can be viewed on the terminal.

---

### **Coding Challenges and Solutions**

**Error Example**: The following error occurred during coding and was resolved by implementing an additional `always` block.

```verilog
always @(posedge uart_rx_data_valid or posedge uart_tx_ready) begin 
    if (uart_rx_data_valid) begin 
        i_uart_tx_data <= uart_rx_data + 20; 
        i_data_valid <= 1; 
    end 
    else if (uart_tx_ready) begin 
        i_data_valid <= 0; 
    end 
end
```


### Timing Summary:-

![image](https://github.com/user-attachments/assets/37c3a1a5-b2e7-4e8e-a768-39ef23db74ab)

### Max clock frequency:-

![image](https://github.com/user-attachments/assets/8e660086-f01a-4e6f-a70e-be2463a5a205)

Maximum Clock Frequency= 1/Total Delay (Critical Path)  =    1 / 2.326ns = 429 MHz 

### Resource Utilization 

![image](https://github.com/user-attachments/assets/be31d04e-c09e-4bad-8ea5-95462c42e094)

![image](https://github.com/user-attachments/assets/82a38a37-c983-4d40-bd3d-05d579267d11)

### Implemented layout diagram 

![image](https://github.com/user-attachments/assets/68527ec9-1b83-439b-b8f4-a5688b6edd28)

![image](https://github.com/user-attachments/assets/9667d7aa-7d4d-410e-ba2a-8b384f633f07)

### Latency

![image](https://github.com/user-attachments/assets/a63a5373-049f-43b1-9195-85a6f39d9898)

Latency (in cycles)=Data Path Delay/Clock Period = 7.413ns / 10ns = 0.7413 

### Throughput 

Throughput= Output Data Size / (Latency×Clock Period) 
= 64 /0.7413 * 10 * 10ns 
= 8.6 Ghz. 

### References:-

- https://github.com/Ajeet-Meena/Xilinx-Data-Encryption-Standard-on-FPGA
- https://www.geeksforgeeks.org/universal-asynchronous-receiver-transmitter-uart-protocol/
- https://www.youtube.com/watch?v=j53iXhTSi_s

### Mentors:-
- Professor Nanditha Rao ( Faculty at IIIT Bangalore )
- Himanshu Kumar Rai ( MS by Research student at IIIT Bangalore )




