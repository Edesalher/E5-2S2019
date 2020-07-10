SYSCTL_RCGCGPIO_R 	   EQU 0x400FE608 ;Se habilita el reloj para la TIVA C
	
GPIO_PORTA_AMSEL_R     EQU 0x40004528 ;Direcciones base para el puerto A.
GPIO_PORTA_PCTL_R      EQU 0x4000452C
GPIO_PORTA_DIR_R       EQU 0x40004400
GPIO_PORTA_AFSEL_R     EQU 0x40004420
GPIO_PORTA_DEN_R       EQU 0x4000451C
	
GPIO_PORTF_AMSEL_R     EQU 0x40025528 ;Direcciones base para el puerto F.
GPIO_PORTF_PCTL_R      EQU 0x4002552C
GPIO_PORTF_DIR_R       EQU 0x40025400
GPIO_PORTF_AFSEL_R     EQU 0x40025420
GPIO_PORTF_DEN_R       EQU 0x4002551C
	
PA3					   EQU 0x40004020 ;Dirección para el Bit 3 del puerto A, PA3.
PF3					   EQU 0x40025020 ;Dirección para el Bit 3 del puerto F, PF3.
DELAY 				   EQU 61500000 ;Delay aprox. de 19 seg.

	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB 
	EXPORT  Start

Start
	BL ConfigPuertoA
	BL ConfigPuertoF
	MOV R2, #0 ;x = 0
    MOV R3, #1 ;y = 1
	B  CONDICION

ConfigPuertoA
	LDR R1, =SYSCTL_RCGCGPIO_R ;Se activa reloj para puerto A. 
	LDR R0, [R1]
	ORR R0, R0, #0x01
	STR R0, [R1]
	NOP
	NOP
	
	LDR R1, =GPIO_PORTA_AMSEL_R ;Se eliminan las funciones analógicas del puerto A.
	LDR R0, [R1]
	BIC R0, R0, #0x08
	STR R0, [R1]

	LDR R1, =GPIO_PORTA_PCTL_R ;Se configura el puerto A como GPIO.
	LDR R0, [R1]
	BIC R0, R0, #0x0F000000; 
	STR R0, [R1]

	LDR R1, =GPIO_PORTA_DIR_R ;Se especifíca la dirección para PA3.
	LDR R0, [R1]
	ORR R0, R0, #0x08
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTA_AFSEL_R ;Se deshabilita otras funciones de puerto A.
	LDR R0, [R1]
	BIC R0, R0, #0x08
	STR R0, [R1]

	LDR R1, =GPIO_PORTA_DEN_R ;Se habilita la función digital del puerto A.       
    LDR R0, [R1]                    
    ORR	R0,#0x08	          
    STR R0, [R1]   

	BX LR

ConfigPuertoF
	LDR R1, =SYSCTL_RCGCGPIO_R ;Se activa reloj para puerto F. 
	LDR R0, [R1]
	ORR R0, R0, #0x20 
	STR R0, [R1]
	NOP
	NOP
	
	LDR R1, =GPIO_PORTF_AMSEL_R ;Se eliminan las funciones analógicas del puerto F.
	LDR R0, [R1]
	BIC R0, R0, #0x08
	STR R0, [R1]

	LDR R1, =GPIO_PORTF_PCTL_R ;Se configura el puerto F como GPIO.
	LDR R0, [R1]
	BIC R0, R0, #0x0F000000; 
	STR R0, [R1]

	LDR R1, =GPIO_PORTF_DIR_R ;Se especifÍca la dirección para PF3.
	LDR R0, [R1]
	ORR R0, R0, #0x08
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTF_AFSEL_R ;Se deshabilita otras funciones de puerto F.
	LDR R0, [R1]
	BIC R0, R0, #0x08
	STR R0, [R1]

	LDR R1, =GPIO_PORTF_DEN_R ;Se habilita la función digital del puerto F.       
    LDR R0, [R1]                    
    ORR	R0,#0x08	          
    STR R0, [R1]   

	BX LR

CONDICION
    ;if(x = 0 & y = 1)
	CMP R2, #0 ;if(x = 0)
	CMPEQ R3, #1 ;if(y = 1)

	MOVEQ R2, #1 ;x = 1 
	MOVEQ R3, #0 ;y = 0
	LDREQ R1, =PA3 ;Carga en R1 la dirección de PA3
	BEQ LED_ON
	
    ;else
	MOVNE R2, #0 ;x = 0
	MOVNE R3, #1 ;Y = 1
	LDRNE R1, =PF3 ;Carga en R1 la dirección de PF3
	BNE LED_ON

LED_ON
    MOV R0, #0x08
	STR R0, [R1]
	LDR R4, =DELAY
	B Delay

Delay
	SUB R4, #1
	CMP R4, #0
	BEQ LED_OFF
	B Delay

LED_OFF
	MOV R0, #0x00
	STR R0, [R1]
	B CONDICION

	
	ALIGN
	END