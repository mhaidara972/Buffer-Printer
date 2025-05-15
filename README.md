# Buffer-Printer
AUTHOR:
Cherif Haidara - Affiliation: UMBC, CMSC 313 (8:30-9:45 am), DOS: 5/15/2025

PURPOSE OF SOFTWARE:
This project implements a program in x86 assembly language that reads a predefined buffer of bytes and outputs their hexadecimal representation.

FILES:
dataPrinter.asm: The x86 assembly language source code for the data printing program.
dataPrinter.o: Object file
dataPrinter: Executable

BUILD INSTRUCTIONS:
In your terminal:
Assemble using:  nasm -f elf dataPrinter.asm -o dataPrinter.o 
Link using: ld -m elf_i386 dataPrinter.o -o dataPrinter
Run the executable using: ./dataPrinter
