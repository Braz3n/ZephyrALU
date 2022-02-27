# Zephyr ALU

A basic ALU 8-bit ALU for the Zephyr CPU project, a simple 8-bit CPU architecture.

## Registers
There are two registers general purpose registers in the ALU:
 - `A` - Accumulator
 - `T` - Temporary

Either can be read or written to on demand.

There is also an 8-bit flag register, which is updated depending on the result of an operation.

### Flag Register
Of the four bits, currently only 4 have defined uses.

- Bit 0 - Zero Flag (`Z`)
- Bit 1 - Carry Flag (`C`)
- Bit 2 - Overflow Flag (`V`)
- Bit 3 - Negative Flag (`N`)
- Bit 4 - Reserved
- Bit 5 - Reserved
- Bit 6 - Reserved
- Bit 7 - Reserved

The Carry, Overflow, and Negative flags can additionally be set or cleared manually using the respective SETx or CLRx operation.

### Modifying Operations

NOP modifies none of the flags.

Flag operations (SET, and CLR) set or clear the specified flag. Other flags remain unchanged.

Register operations (LD, and RD) update the flags as follows:
 - `Z` is set if the new value of `A` is zero. Clear otherwise.
 - `C` remains unchanged.
 - `V` remains unchanged.
 - `N` remains unchanged.

Arithmetic operations (ADD, ADC, SUB, SBB, INC, and DEC) update the flags as follows:
 - `Z` is set if the result is equal to zero. Clear otherwise.
 - `C` is set if a carry or borrow (addition or subtraction, respectively) occurred.
 - `V` is set if a signed overflow or underflow occurred.
 - `N` is set if the most significant bit of the result is set.

Arithmetic operations (ADD, ADC, SUB, SBB, INC, and DEC) update the flags as follows:
 - `Z` is set if the result is equal to zero. Clear otherwise.
 - `C` is set if a carry or borrow (addition or subtraction, respectively) occurred.
 - `V` is set if a signed overflow or underflow occurred.
 - `N` is set if the most significant bit of the result is set.

Bitwise operations (AND, NOT, XOR, and OR) update the flags as follows:
 - `Z` is set if the result is equal to zero. Clear otherwise.
 - `C` remains unchanged.
 - `V` is cleared.
 - `N` is set if the most significant bit of the result is set.

Shift/Rotation operations (LSL, LSR, ASR, RLC, and RRC) update the flags as follows:
 - `Z` is set if the result is equal to zero. Clear otherwise.
 - `C` is set if the shifted out bit was one. Clear otherwise.
 - `V` is set to the exclusive or of the resulting C and N flags.
 - `N` is set if the most significant bit of the result is set.

## Opcodes
The ALU is controled using a series of opcodes 5-bit, similar to a larger CPU.

| Opcode  | Binary Code | Description                                 |
|---------|-------------|---------------------------------------------|
| aluNOP  |   `00000`   | No operation                                |
| aluLDA  |   `01110`   | Load `A` register                           |
| aluLDT  |   `00010`   | Load `T` register                           |
| aluRDA  |   `01111`   | Read `A` register                           |
| aluRDT  |   `00011`   | Read `T` register                           |
| aluSETC |   `11000`   | Set carry flag                              |
| aluCLRC |   `11001`   | Clear carry flag                            |
| aluSETV |   `11010`   | Set overflow flag                           |
| aluCLRV |   `11011`   | Clear overflow flag                         |
| aluSETN |   `11100`   | Set negative flag                           |
| aluCLRN |   `11101`   | Clear negative flag                         |
| aluADD  |   `00110`   | Add `A` and `T` registers                   |
| aluADC  |   `00111`   | Add `A` and `T` registers with carry        |
| aluSUB  |   `01000`   | Subtract `A` and `T` registers              |
| aluSBB  |   `01001`   | Subtract `A` and `T` registers with borrow  |
| aluINC  |   `10110`   | Increment `A` register by one               |
| aluDEC  |   `10111`   | Decrement `A` register by one               |
| aluAND  |   `01010`   | Bitwise AND `A` and `T` registers           |
| aluNOT  |   `00101`   | Bitwise NOT `A` register                    |
| aluXOR  |   `01101`   | Bitwise XOR `A` and `T` registers           |
| aluOR   |   `01011`   | Bitwise OR `A` and `T` registers            |
| aluLSL  |   `10000`   | Logical shift left `A` register             |
| aluLSR  |   `10001`   | Logical shift right `A` register            |
| aluASR  |   `10010`   | Arithmetic shift left `A` register          |
| aluRLC  |   `10011`   | Rotate `A` register left through carry      |
| aluRRC  |   `10100`   | Rotate `A` register right through carry     |
 
 



