BITS 32;use 32 bit mode
ORG 0x0200;the bootloader will load us behind it's end

IDT:
HD_I:
DB 0;offset near 0, we live at the top
DB 0xEE;
