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


START:
XOR AX,AX;clear AX
MOV DS,AX;clear DS
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