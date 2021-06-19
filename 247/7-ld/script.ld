ENTRY(start)
SECTIONS {
	 . = 0x5500000;
	 .text : {
	   *(.text);
	   PROVIDE (_end = .);
	 }
	 . = 0xb00000;
	 .rodata : {
	   *(.rodata);
	    
	 }
	 . = ALIGN(1 << 12);
	 . = 0x5300000;
	 .data : {
	   *(.data);
	   
	 }
	 . = 0x1f00000;
	 .bss : {
	   *(.bss);
	   
	 }
}
