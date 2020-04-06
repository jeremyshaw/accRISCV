# accRISCV

- Work in progress. Trying to see if an accumulator setup is capable of handling this ISA. If not, I'll adjust.
   - Allright, RISC-V by definition has 32 general registers and one more (program counter). So not an accumulator. I may have to rename this, or see if I can cut down RV32I to just use one register.
- This is an exploration to see how simple I can make a RISC-V 32 bit CPU.

## Topology
- top
   - clkDiv
   - accRISCV

## Needs
- split out registers & ALU from the main accRISCV module
- visually and textually document the datapath for this simple accumulator.