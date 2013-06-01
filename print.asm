[BITS 16]
[ORG 0];
CLI; disable interrupts
JMP 0x7c00:START;jump to a known location

STRING:
db 'These are charechters or however you spell them',13,10,0;a string for fun

START:
XOR AX,AX;clear AX
MOV DS,AX;clear DS

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