SYSCTL_RCGCGPIO_R 	   EQU 0x400FE608
GPIO_PORTF_AMSEL_R     EQU 0x40025528; Valores exclusivos para el puerto F. Si lo quisieramos cambiar por el puerto B, deberia ser: GPIO_PORTB_AMSEL_R     EQU 0x40005528 
GPIO_PORTF_PCTL_R      EQU 0x4002552C;
GPIO_PORTF_DIR_R       EQU 0x40025400;
GPIO_PORTF_AFSEL_R     EQU 0x40025420;
GPIO_PORTF_DEN_R       EQU 0x4002551C;
PF1					   EQU 0x40025008;
DELAY 				   EQU 1000000

		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start


Start
	BL ConfigPuertoF
	B  LED1

ConfigPuertoF
	LDR R1, =SYSCTL_RCGCGPIO_R; 
	LDR R0, [R1]
	ORR R0, R0, #0x20 
	STR R0, [R1]
	NOP
	NOP
	
	LDR R1, =GPIO_PORTF_AMSEL_R;
	LDR R0, [R1]
	BIC R0, R0, #0x02
	STR R0, [R1]

	LDR R1, =GPIO_PORTF_PCTL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x0F000000; 
	STR R0, [R1]

	LDR R1, =GPIO_PORTF_DIR_R 
	LDR R0, [R1]
	ORR R0, R0, #0x02
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTF_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x02
	STR R0, [R1]

	LDR R1, =GPIO_PORTF_DEN_R       
    LDR R0, [R1]                    
    ORR	R0,#0x02;	          
    STR R0, [R1]   

	BX LR


LED1
	LDR R1, =PF1
	MOV R0, #0x02;
	STR R0, [R1];
	LDR R1, =DELAY 
	B Delay_1
	
Delay_1
	SUB R1, #1
	CMP R1, #0
	BEQ LED2
	B Delay_1
	
LED2
	LDR R1, =PF1
	MOV R0, #0x00;
	STR R0, [R1];
	LDR R1, =DELAY
	B Delay_2

Delay_2
	SUB R1, #1
	CMP R1, #0
	BEQ LED1
	B Delay_2
		
		
	ALIGN
	END