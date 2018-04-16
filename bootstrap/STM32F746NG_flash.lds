
ENTRY(bootstrapVectors)

MEMORY
{
	FLASH (RX) : ORIGIN = 0x08000000, LENGTH = 1M
	SRAM (RWX) : ORIGIN = 0x20000000, LENGTH = 320K
}

bootstrapStack = 0x20050000;

SECTIONS {

	.text : {
	KEEP(*(.bootstrapvectors .bootstrapvectors.*))
        KEEP(*(.bootstrapC))
	} > FLASH

	.data : {
	KEEP(*(.bss .bss.*))
	bootstrapStack = ORIGIN(SRAM) + LENGTH(SRAM);
	} > SRAM

}

