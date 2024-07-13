# MIPS 32-bit Processor Project

This project implements a 32-bit MIPS processor using VHDL and is simulated using Xilinx Vivado. The project consists of several modules, each representing a different part of the processor. The main modules are:

- `control_unit.vhd` : Defines the control unit of the MIPS processor.
- `data_path.vhd` : Defines the data path of the MIPS processor.
- `memory.vhd` : Defines the memory module for instruction and data storage.
- `miTo.vhd` (Top file) : Top-level file that integrates the control unit, data path, and memory.


## Project Structure

1. **Control Unit** (control_unit.vhd)
The control unit is responsible for generating control signals based on the current instruction. It decodes the opcode and function fields of the instruction to generate the necessary control signals for the data path.

2. **Data Path** (data_path.vhd)
The data path contains the arithmetic logic unit (ALU), registers, and other components necessary to execute instructions. It performs the actual computation and data movement operations as directed by the control unit.

3. **Memory** (memory.vhd)
The memory module simulates the instruction and data memory of the processor. It allows the processor to fetch instructions and read/write data during execution.

4. **Top File** (miTo.vhd)
The top file, miTo.vhd, integrates the control unit, data path, and memory modules. It serves as the highest-level module of the project, connecting all the components together to form a complete MIPS processor.


## Simulation and Testing

To simulate and test the `MIPS 32-bit Processor`, we use Xilinx Vivado. Below are the specific details for the data_path and memory components and the steps to run the simulation.

The `data_path` module includes a register bank (banco_reg) that initializes various registers upon reset (rst_n). Here's the initialization process:

``` vhdl
banco_reg : process(clk)
begin
    if (clk'event and clk ='1') then
        if (rst_n = '1') then -- Reset the registers
            reg1    <= x"0000"; -- Result of ADD
            reg2    <= x"000A";
            reg3    <= x"0003";
            reg4    <= x"0000"; -- Result of SUB
            reg5    <= x"0001"; -- Operator OR 000000000000001
            reg6    <= x"0004"; -- Operator OR 000000000000100
            reg7    <= x"0000"; -- Result of OR
            reg8    <= x"0009"; -- Operator AND 000000000001001
            reg9    <= x"0000"; -- Result of AND
            reg10   <= x"0001"; -- Operand BEQ
            reg11   <= x"000E"; -- Operand BEQ
            reg12   <= x"0000";
            reg13   <= x"0008"; -- Used in store
            reg14   <= x"0001"; -- lw_add operand b
            reg15   <= x"0000"; -- lw_add destination
            reg16   <= x"0000";
        end if;
    end if;
end process;
```

The `memory` module consists of 511 positions of 32 bits. Each memory slot is initialized with specific instructions during reset (rst_n). Here is the initialization sequence:

``` vhdl
begin    
    if (rst_n = '1') then
        -- Reset memory when rst_n = 1 
        mem(0)     <= "10010011110000111000000011100110"; -- add r1 r2 r3
        mem(1)     <= "00000101000010001100000000000000"; -- sub r4 r2 r3
        mem(2)     <= "00001001110101011000000000000000"; -- or r7 r5 r6
        mem(3)     <= "00001110011000010100000000000000"; -- and r9 r8 r5
        mem(4)     <= "10000010101011000000000000011011"; -- BEQ r10 r11 pos 27 
        mem(5)     <= "00001001110101011000000000000000"; -- or r7 r5 r6
        mem(6)     <= "00001110011000010100000000000000"; -- and r9 r8 r5
        mem(7)     <= "10000100000000000000000000011110"; -- jump to line 30
        mem(8)     <= "10000010101011000000000000011011"; -- BEQ r10 r11 pos 27 
        mem(9)     <= "00000000010010001100000000000000"; -- add r1 r2 r3
        mem(10)    <= "10010011110000111000000011100110"; -- lw_add r15 r14 pos 230
        mem(11)    <= "00010000010010001100000000000000"; -- add_sw r2 r2 pos mem 20
        . . .
```

You can configure the simulation settings according to your project requirements.




