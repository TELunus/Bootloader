BITS 32;use 32 bit mode
ORG 0xF000;KEEP IN SYNC WITH WHERE THE LOADER LOADS US

IDT:
HD_I:
;this whole entry may be the wrong way around
DW 0;offset near 0, we live at the top
DB 0xEE;no paging,any one can do it, is a 32 interrupt gate
DB 0;this is always 0 in intel IDTs
DW 0b000?????????????;privilege level 0,GDT, entry X
DW 


ISR:
HD_F:
