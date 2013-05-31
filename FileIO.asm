JMP LOADSTART; incase we fall into this code
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

LOADSTART:
MOV DS, 0; may not need this, but it might be how to zero the Data Segment register
MOV SI, DAPS;
MOV AH, 42; AH is used by the BIOS, and needs to be 42 for LBA ATA reading in realmode
MOV DL, 0x80; drive identifier, 0x80 is somewhat standard
INT 0x13; Interrupt 0x13, which calls the BIOS LBA ATA read if we're in realmode
;this will have set the carry flag if the load failed
JC short LOADERROR; do error handling
JMP END;

LOADERROR:
;ERR handling here

END:
JMP END;don't exit

