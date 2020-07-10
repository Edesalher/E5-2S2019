SYSCTL_RCGCGPIO_R 	   EQU 0x400FE608 ;Se habilita el reloj para la TIVA C
	
GPIO_PORTB_AMSEL_R     EQU 0x40005528 ;Direcciones base para el puerto A.
GPIO_PORTB_PCTL_R      EQU 0x4000552C
GPIO_PORTB_DIR_R       EQU 0x40005400
GPIO_PORTB_AFSEL_R     EQU 0x40005420
GPIO_PORTB_DEN_R       EQU 0x4000551C

PB0		  EQU 0x40005004
PB1       EQU 0x40005008
PB2       EQU 0x40005010
BITS	  EQU 0x4000501C
DELAY 	  EQU 1200000 ;Delay aprox. de 1 seg.
	
	
		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB 
        EXPORT  Start


Start
	BL ConfigPuertoB
	B Inicio
	
ConfigPuertoB
	LDR R1, =SYSCTL_RCGCGPIO_R ;Se activa reloj para puerto B. 
	LDR R0, [R1]
	ORR R0, R0, #0x02 
	STR R0, [R1]
	NOP
	NOP
	
	LDR R1, =GPIO_PORTB_AMSEL_R ;Se eliminan las funciones analógicas del puerto A.
	LDR R0, [R1]
	BIC R0, R0, #(0x01+0x02+0x04)
	STR R0, [R1]

	LDR R1, =GPIO_PORTB_PCTL_R ;Se habilita el puerto A como GPIO.
	LDR R0, [R1]
	BIC R0, R0, #0x0F000000; 
	STR R0, [R1]

	LDR R1, =GPIO_PORTB_DIR_R ;Se establece como entrada o salida el puerto A.
	LDR R0, [R1]
	ORR R0, R0, #(0x01+0x02+0x04)
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTB_AFSEL_R ;Se deshabilita otras funciones de puerto A.
	LDR R0, [R1]
	BIC R0, R0, #(0x01+0x02+0x04)
	STR R0, [R1]

	LDR R1, =GPIO_PORTB_DEN_R ;Se habilita la función digital del puerto A.       
    LDR R0, [R1]                    
    ORR	R0, #(0x01+0x02+0x04)     
    STR R0, [R1]
	
	BX LR
	
Inicio
	MOV R2, #0x07
	B LEDS
	
Inicio2
	MOV R2, #0x00
	B LEDS
	
LEDS
	LDR R1, =BITS
	MOV R0, R2
	STR R0, [R1]
	LDR R1, =DELAY 
	B Delay
	
Delay
	SUB R1, #1
	CMP R1, #0
	MOVEQ R0, #0x01
	BEQ Contador
	BEQ LEDS
	B Delay
	
Contador	
	SUB R2, R2, R0 ;R1 = R1 + R0 = R1 + 1
    MOV R3, #0x00
	CMP R2, R3
	BEQ Inicio2
	B LEDS
	
	ALIGN
    END