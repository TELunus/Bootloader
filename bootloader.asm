[BITS 16]
[ORG 0];
CLI; disable interrupts
JMP 0x7c00:START;jump to a known location

GDT_DATA:
INCBIN "GDT_DATA.bin";include the GDT
GDT_END:
GDT_DESC:
   db GDT_END - GDT_DATA;set the gdt size
   dw GDT_DATA;set the GDT ofset

STRING:
db 'These are charechters or however you spell them',13,10,0;a string for fun

DAPS:
;Disk Address Packet Structure
DB 16;packets are 16 bytes
DB 0;
DW 16; how many sectors do you want to transfer?
DW 0x7C00;     :yyyy
DW 0x0000; xxxx:
;xxxx:yyyy is the address to load into, shouold be an even number
DD 1;start reading from this Logical Block Address or LBA
DD 0; use for big LBAs

START:
XOR AX,AX;clear AX
MOV DS,AX;clear DS

LOADSTART:
MOV SI, DAPS;
MOV AH, 42; AH is used by the BIOS, and needs to be 42 for LBA ATA reading in realmode
MOV DL, 0x80; drive identifier, 0x80 is somewhat standard
INT 0x13; Interrupt 0x13, which calls the BIOS LBA ATA read if we're in realmode
;this will have set the carry flag if the load failed
JC short LOADERROR; do error handling

LOADERROR:
;ERR handling here
JMP END;don't bother any more

lgdt [GDT_DESC];load the GDT descriptor
MOV EAX, CR0;load Control Register 0 into a more accessible register
OR AL, 1;set the Protection Enable bit
MOV CR0, EAX;store the Control Register back

MOV AH, 0x0E;function
MOV BH, 0x00;ignore
MOV BL, 0x04;atribute
MOV SI, STRING;loads the string beginging into SI?

strloop:
lodsb;load SI int al, increment SI
OR AL,AL;check if AL is 0
JZ END;jump on last instruction gave 0
int 0x10;send the char
jmp strloop

END:
jmp END; jump to the end of the program to have a never ending loop


times 510-($-$$) DB 0; fill the remaining memory, up to 510, with 0s
;$ is instruction start, $ is program start, so $-$$ is current size
DW 0xAA55;boot sectors need this at the end