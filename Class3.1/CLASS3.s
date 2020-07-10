GPIO_PORTF_DIR_R   EQU 0x40025400 ; I/O
GPIO_PORTF_AFSEL_R EQU 0x40025420 ;	Elimina las demas funciones
GPIO_PORTF_PUR_R   EQU 0x40025510 ; Deshabilita la resistencia pull up.
GPIO_PORTF_DEN_R   EQU 0x4002551C ; Habilita la función digital
GPIO_PORTF_LOCK_R  EQU 0x40025520 ; Desbloquea el puerto 
GPIO_PORTF_CR_R    EQU 0x40025524 ; Permite modificar los registros
GPIO_PORTF_AMSEL_R EQU 0x40025528 ; Deshabilita las funciones analógicas
GPIO_PORTF_PCTL_R  EQU 0x4002552C ; Habilita los puertos como GPIO 
SYSCTL_RCGCGPIO_R  EQU 0x400FE608 ; Configuración del reloj.
GPIO_LOCK_KEY      EQU 0x4C4F434B ; Permite la modificación de los registros CR.
	
PF0		  EQU 0x40025004
PF1       EQU 0x40025008
PF2       EQU 0x40025010
PF3       EQU 0x40025020
PF4       EQU 0x40025040
LEDS      EQU 0x40025038 ; Suma de todos los puertos
SWITCHES  EQU 0x40025044 ; Suma de todos los botones.
SW1       EQU 0x10  	 ; Valor para activar el switch 1  (PF4) Valores "encender" presentación 2    
SW2       EQU 0x01       ; Valor para activar el switch 2   (PF0) 	
	
		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
Start

	LDR R1, =SYSCTL_RCGCGPIO_R      
    LDR R0, [R1]                   
    ORR R0, R0, #0x20
    STR R0, [R1]                    
    NOP
    NOP                            
    
    LDR R1, =GPIO_PORTF_LOCK_R      
    LDR R0, =GPIO_LOCK_KEY          
    STR R0, [R1]                    
   
    LDR R1, =GPIO_PORTF_CR_R        
    MOV R0, #0xFF                  
    STR R0, [R1]   
	
    LDR R1, =GPIO_PORTF_DIR_R       
    LDR R0, [R1]                    
    BIC R0, R0, #(SW1+SW2)          
    STR R0, [R1]                    
    
    LDR R1, =GPIO_PORTF_AFSEL_R     
    LDR R0, [R1]                   
    BIC R0, R0, #(SW1+SW2)          
    STR R0, [R1]                    
    
    LDR R1, =GPIO_PORTF_PUR_R       
    LDR R0, [R1]                    
    ORR R0, R0, #(SW1+SW2)          
    STR R0, [R1]           
	
    LDR R1, =GPIO_PORTF_DEN_R       
    LDR R0, [R1]                    
    ORR R0, R0, #(SW1+SW2)          
    STR R0, [R1]                    
    
    LDR R1, =GPIO_PORTF_PCTL_R      
    LDR R0, [R1]                    
    BIC R0, R0, #0x000F000F         
    ADD R0, R0, #0x00000000         
    STR R0, [R1]                    
	
    LDR R1, =GPIO_PORTF_AMSEL_R     
    MOV R0, #0                     
    STR R0, [R1]                    
    
	LDR R1, =GPIO_PORTF_DIR_R       
    LDR R0, [R1]                   
    ORR R0, R0, #(0x0E)   
    STR R0, [R1]                    
    
    LDR R1, =GPIO_PORTF_AFSEL_R     
    LDR R0, [R1]                    
    BIC R0, R0, #0x0E  
    STR R0, [R1]                    
	
    LDR R1, =GPIO_PORTF_DEN_R      
    LDR R0, [R1]                    
    ORR R0, R0, #0x0E
    STR R0, [R1]                    
	
    LDR R1, =GPIO_PORTF_PCTL_R      
    LDR R0, [R1]                    
    BIC R0, R0, #0x0000FF00         
    BIC R0, R0, #0x000000F0         
    STR R0, [R1]                    
	
    LDR R1, =GPIO_PORTF_AMSEL_R     
    MOV R0, #0                      
    STR R0, [R1]                    
    LDR R4, =LEDS                 
    MOV R5, #0x02                   
    MOV R6, #0x04                  
    MOV R7, #0x08                 
    MOV R8, #0                     
    MOV R9, #0x0E       
	
	
Leer
    LDR R1, =SWITCHES              
    LDR R0, [R1]                    
 
 
loop
    
    CMP R0, #0x01                
    BEQ B1                
    CMP R0, #0x10                   
    BEQ B2                 
    CMP R0, #0x00                  
    BEQ B1yB2                 
    CMP R0, #0x11                 
    BEQ Nada                
                                    
    STR R9, [R4]                   
    B   loop
B1
    STR R6, [R4]                    
    B Leer
B2
    STR R5, [R4]                    
    B   Leer
B1yB2
    STR R7, [R4]                   
    B   Leer
Nada
    STR R8, [R4]                   
    B   Leer

    ALIGN                           
    END