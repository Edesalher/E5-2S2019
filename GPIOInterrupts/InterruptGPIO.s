SYSCTL_RCGCGPIO_R  	   EQU 0x400FE608 ;Se habilita el reloj para la TIVA C

GPIO_PORTB_AMSEL_R     EQU 0x40005528 ;Direcciones base para el puerto B.
GPIO_PORTB_PCTL_R      EQU 0x4000552C
GPIO_PORTB_DIR_R       EQU 0x40005400
GPIO_PORTB_AFSEL_R     EQU 0x40005420
GPIO_PORTB_DEN_R       EQU 0x4000551C
GPIO_PORTB_PUR_R   EQU 0x40005510
GPIO_PORTB_LOCK_R  EQU 0x40005520
GPIO_PORTB_CR_R    EQU 0x40005524

GPIO_PORTF_AMSEL_R     EQU 0x40025528 ;Direcciones base para el puerto F.
GPIO_PORTF_PCTL_R      EQU 0x4002552C
GPIO_PORTF_DIR_R       EQU 0x40025400
GPIO_PORTF_AFSEL_R     EQU 0x40025420
GPIO_PORTF_DEN_R       EQU 0x4002551C
	
;SYSCTL_RCGC2_GPIOF EQU 0x00000020 

PF1       EQU 0x40025008
PF2       EQU 0x40025010
PF3       EQU 0x40025020
LEDS      EQU 0x40025038

PB0       EQU 0x40005004
PB1       EQU 0x40005008
BUTTONS   EQU 0x4000500C
	
DELAY     EQU 1500000
	
	AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
Start


Configurations
;Configuración PUERTO B
    LDR R1, =SYSCTL_RCGCGPIO_R         
    LDR R0, [R1]                 
    ORR R0, R0, #0x02               
    STR R0, [R1]                  
    NOP
    NOP                                        
    LDR R1, =GPIO_PORTB_AMSEL_R     
    LDR R0, [R1]                    
    BIC R0, #(0x02+0x01)                   
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_PCTL_R      
    LDR R0, [R1]                    
    BIC R0, #0x0F000000	
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                    
    BIC R0, #(0x02+0x01)                   
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_AFSEL_R     
    LDR R0, [R1]                    
    BIC R0, #(0x02+0x01)                    
    STR R0, [R1]                                 
    LDR R1, =GPIO_PORTB_DEN_R       
    LDR R0, [R1]                    
    ORR R0, #(0x02+0x01)                   
    STR R0, [R1]                   
     
;Configuración PUERTO F	 
	LDR R1, =SYSCTL_RCGCGPIO_R         
    LDR R0, [R1]                 
    ORR R0, R0, #0x20               
    STR R0, [R1]                  
    NOP
    NOP 
    ; configure as GPIO
    LDR R1, =GPIO_PORTF_PCTL_R      
    LDR R0, [R1]                             
	BIC R0, R0, #0x0F000000
    STR R0, [R1]    
    ;Se especifÍca direcciones
	LDR R1, =GPIO_PORTF_DIR_R       
    LDR R0, [R1]                   
    ORR R0, R0, #(0x02+0x04+0x08)   
    STR R0, [R1]                    
    ; regular port function
    LDR R1, =GPIO_PORTF_AFSEL_R     
    LDR R0, [R1]                    
    BIC R0, R0, #(0x02+0x04+0x08)   
    STR R0, [R1]                    
    ; enable digital port
    LDR R1, =GPIO_PORTF_DEN_R       
    LDR R0, [R1]                    
    ORR R0, R0, #(0x02+0x04+0x08)   
    STR R0, [R1]                                    
    ; disable analog functionality
    LDR R1, =GPIO_PORTF_AMSEL_R     
    MOV R0, #0                     
    STR R0, [R1]                   
    LDR R4, =LEDS                  
    MOV R5, #0x02                    
    MOV R6, #0x04                   
    MOV R7, #0x08                 
    MOV R8, #0                      
    MOV R9, #(0x02+0x08+0x04)       
	
	
Lectura
    LDR R1, =BUTTONS
    LDR R0, [R1]
	
loop
    CMP R0, #0x02                  
    BEQ Activo 

	CMP R0, #0x01                   
    BEQ Activo2
    
    CMP R0, #0x00                   
    BEQ Apagado                 
    
                                   
    STR R9, [R4]                    
    B   Lectura
	
Activo
    STR R6, [R4] 
	LDR R2, =DELAY	
    B   Delay
	
Delay
	SUB R2, #1
	CMP R2, #0
	BEQ Apagado2
	B Delay
	
Delay2
	SUB R2, #1
	CMP R2, #0
	BEQ Activo
	B Delay2	
	
Apagado2
	STR R8, [R4]
	LDR R2, =DELAY	
    B   Delay2
		
Activo2
    STR R5, [R4]                    
    B   Lectura
	
Apagado
    STR R8, [R4]                    
    B   Lectura


    ALIGN                           
    END