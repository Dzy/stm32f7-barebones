
PROJECT = STM32F7_TNC_355

OBJECTS = \
	bootstrap/bootstrapC.o \
	bootstrap/isr.o

LINKER_SCRIPT = bootstrap/STM32F746NG_flash.lds

INCLUDE_PATHS += -I../includes

AS      = arm-none-eabi-as
CC      = arm-none-eabi-gcc
CPP     = arm-none-eabi-g++
LD      = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
SIZE    = arm-none-eabi-size 

LD_FLAGS = --script=$(LINKER_SCRIPT)

CPU = -mcpu=cortex-m7 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard

CC_FLAGS = $(CPU) -Wall -Os -nostdlib -nostartfiles -ffreestanding

all: $(call MAKEDIR,$(OBJDIR)) $(PROJECT).bin $(PROJECT).hex size disasm lst

clean:
	rm -f $(PROJECT).bin $(PROJECT).elf $(PROJECT).hex $(PROJECT).map $(PROJECT).lst $(PROJECT).asm $(OBJECTS) $(DEPS)

disasm:
	$(OBJDUMP) -j .rodata -j .text -d -Mforce-thumb $(PROJECT).elf > $(PROJECT).asm

.s.o:
	$(AS) $(CPU) -c -o $@ $<

.c.o:
	$(CC) $(CC_FLAGS) $(INCLUDE_PATHS) -c $< -o $@

$(PROJECT).elf: $(OBJECTS) 
	$(LD) $(LD_FLAGS) -o $@ $^

$(PROJECT).bin: $(PROJECT).elf
	$(OBJCOPY) -O binary $< $@

$(PROJECT).hex: $(PROJECT).elf
	@$(OBJCOPY) -O ihex $< $@

$(PROJECT).lst: $(PROJECT).elf
	@$(OBJDUMP) -Sdh $< > $@

lst: $(PROJECT).lst

size: $(PROJECT).elf
	$(SIZE) $(PROJECT).elf

flash: $(PROJECT).bin
	#st-flash write $(PROJECT).bin 0x8000000
	STM32_Programmer_CLI -c port=SWD -w $< 0x08000000 -rst

DEPS = $(OBJECTS:.o=.d)
-include $(DEPS)

