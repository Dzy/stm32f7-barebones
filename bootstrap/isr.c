#include <stdint.h>

#define __default_handler __attribute__ ((weak, alias ("Default_Handler")))

void __attribute__ ((unused)) Default_Handler(void) { while(1); }

extern void bootstrapC(void);

void __default_handler  NMI_Handler(void);
void __default_handler  HardFault_Handler(void);
void __default_handler  MemManage_Handler(void);
void __default_handler  BusFault_Handler(void);
void __default_handler  UsageFault_Handler(void);
void __default_handler  SVC_Handler(void);
void __default_handler  DebugMon_Handler(void);
void __default_handler  PendSV_Handler(void);
void __default_handler  SysTick_Handler(void);
  
extern uint32_t bootstrapStack;

__attribute__ ((used, section(".bootstrapvectors")))
void (* const bootstrapVectors[]) (void) = {
	(void *)&bootstrapStack,
	bootstrapC,

	NMI_Handler,
	HardFault_Handler,
	MemManage_Handler,
	BusFault_Handler,
	UsageFault_Handler,
	0,
	0,
	0,
	0,
	SVC_Handler,
	DebugMon_Handler,
	0,
	PendSV_Handler,
	SysTick_Handler,
};

