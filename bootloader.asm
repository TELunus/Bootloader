BITS 16;use 16 bit mode
ORG 0;set the orgin to the beginning of memory
CLI; disable interrupts
JMP 0x07c0:START;jump to a known location

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
;xxxx:yyyy is the address to load into, should be an even number
DD 1;start reading from this Logical Block Address or LBA
DD 0; use for big LBAs

START:
MOV AX, 0x07c0;Needed for setting DS;
MOV DS, AX;set DS to the begining of our program
MOV AX, 0xb800;text video memory
MOV ES, AX;
XOR AX, AX; clear AX for later use
MOV DI, AX; clear DI for beginning of screen

;MOV AH, 0x0E;function
MOV AH, 0x0F;white on black attribute
;MOV BH, 0x00;ignore
;MOV BL, 0x04;atribute
MOV SI, STRING;loads the string beginging into SI

strloop:
lodsb;load SI into al, increment SI
OR AL,AL;check if AL is 0
JZ LOADSTART;jump on last instruction gave 0
;int 0x10;send the char
stosw;AX to ES:DI, increment DI
jmp strloop

LOADSTART:
MOV SI, DAPS;
MOV AH, 42; AH is used by the BIOS, and needs to be 42 for LBA ATA reading in realmode
MOV DL, 0x80; drive identifier, 0x80 is somewhat standard
INT 0x13; Interrupt 0x13, which calls the BIOS LBA ATA read if we're in realmode
;this will have set the carry flag if the load failed
JC short LOADERROR; do error handling

LOADERROR:
;ERR handling here
JMP END_16;don't bother any more

END_16:
jmp END_16; jump to the end of the program to have a never ending loop

lgdt [GDT_DESC];load the GDT descriptor
MOV EAX, CR0;load Control Register 0 into a more accessible register
OR AL, 1;set the Protection Enable bit
MOV CR0, EAX;store the Control Register back


BITS 32;we are now in 32 bit mode

END_32:
jmp END_32;jump to the end to make an infinate loop


times 436-($-$$) DB 0; fill the remaining memory, up to 436, with 0s
;$ is instruction start, $ is program start, so $-$$ is current size
;we want the boot sector to end at 512, but we have otherthings to do first
;and we should only be using 436 bytes

UID:
DW 0;
DW 0;
DW 5;
DW 0;
DW 0;

;Partition table entries
TBL_ENTRY_ONE:

DB 0x80;active since we want a bootable partition
DB 0xFF;head for invalid CHS for drives bigger than 8GB
DW 0xFFFF;sector and cyl for invalid CHS for big drives
DB 0x7f;System ID which declares HD type to be 0x7f for custom FS
DB 0xFF;head for invalid CHS for drives bigger than 8GB
DW 0xFFFF;sector and cyl for invalid CHS for big drives
DD 1; the first sector is taken up by the MBR
DD 20971439;10GiB partition

TBL_ENTRY_TWO:

DB 0x00;Not Active, boot from the first listed partition
DB 0x00;CHS 0 for unused partititon entry
DW 0x00;CHS 0 for unused partititon entry
DB 0x00;no type needed for unexistant partion
DB 0x00;CHS 0 for unused partititon entry
DW 0x0000;sector and cyl for invalid CHS for big drives
DD 0; the first sector is taken up by the MBR
DD 0;0GiB partition

TBL_ENTRY_THREE:

DB 0x00;Not Active, boot from the first listed partition
DB 0x00;CHS 0 for unused partititon entry
DW 0x00;CHS 0 for unused partititon entry
DB 0x00;no type needed for unexistant partion
DB 0x00;CHS 0 for unused partititon entry
DW 0x0000;sector and cyl for invalid CHS for big drives
DD 0; the first sector is taken up by the MBR
DD 0;0GiB partition

TBL_ENTRY_FOUR:

DB 0x00;Not Active, boot from the first listed partition
DB 0x00;CHS 0 for unused partititon entry
DW 0x00;CHS 0 for unused partititon entry
DB 0x00;no type needed for unexistant partion
DB 0x00;CHS 0 for unused partititon entry
DW 0x0000;sector and cyl for invalid CHS for big drives
DD 0; the first sector is taken up by the MBR
DD 0;0GiB partition

DW 0xAA55

;times 2048-($-$$) DB 0; fill the remaining memory, up to 10GiB with 0s, ;making us more than 8GiB large
;$ is instruction start, $ is program start, so $-$$ is current size