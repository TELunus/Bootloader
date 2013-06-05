;BITS 32;use 32 bit mode
ORG 0xF000;KEEP IN SYNC WITH WHERE THE LOADER LOADS US

STRING:
db 'Yo, kernel here ',0;a string for fun

START:

MOV AX, 0x0000;
MOV SS, AX; stack starts the same place as our data segment for now
MOV SP, 0xFF00;stick the stack pointer far away


MOV AX, 0xF000;Needed for setting DS;
MOV DS, AX;set DS to the begining of our program
MOV SI, STRING;loads the string beginging into SI

XOR AX, AX; clear AX for later use
MOV DI, AX; clear DI for beginning of screen
CALL PRINT_SI;
JMP KERN_END



PRINT_SI:
MOV AX, 0xb800;text video memory
MOV ES, AX;
MOV AH, 0x0F;white on black attribute

strloop:
lodsb;load SI into al, increment SI
OR AL,AL;check if AL is 0
JZ strend;jump on last instruction gave 0
stosw;AX to ES:DI, increment DI
jmp strloop
strend:
ret

;IDT:
;HD_I:
;;this whole entry may be the wrong way around
;DW 0;offset near 0, we live at the top
;DB 0xEE;no paging,any one can do it, is a 32 interrupt gate
;DB 0;this is always 0 in intel IDTs
;DW 0b000?????????????;privilege level 0,GDT, entry X
;DW 
;
;
;ISR:
;HD_F:

KERN_END:
JMP KERN_END;we're a system idle process now
