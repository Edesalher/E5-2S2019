;PROGRAMA QUE PERMITE CONVERTIR LÍNEAS DE AZIMUT Y DISTANCIA EN COORDENADAS
	
	THUMB
	AREA CLASE1, ALIGN=4
mem SPACE 4		
	AREA |text.|, CODE, READONLY, ALIGN=2
	EXPORT Start
		
Start
	;ÁNGULO AZIMUT EN GRADOS (°):
	VLDR.F32 S0, =45
	;DISTANCIA EN METROS(m):
	VLDR.F32 S1, =25
	
	;Valor final (N) de n para sumatoria del Seno y Coseno:
	VLDR.F32 S2, =10
	;Valor inicial de n para sumatoria del Seno y Coseno:
	VLDR.F32 S13, =0 ;S13 = 0 --> n = 0

Convertir_Grados_A_Radianes
	VLDR.F32 S3, =3.141592654 ;S3 = Pi
	VLDR.F32 S4, =180 ;S4 = 180
	VMUL.F32 S0, S3 ;S0 = S0*S3 = Ángulo*Pi
	VDIV.F32 S0, S4 ; S0 = S0/180 --> S0 = Ángulo Azimut en radianes
	B Serie_Seno
	
Potencia 
	VCMP.F32 S4, #0 ;Compara S4 con 0
	VMRS APSR_nzcv, FPSCR
	BEQ FinPot
	
	VMOV.F32 S6, #1 ;S6 = 1
	VMUL.F32 S5, S5, S3 ;S5 = S5*S3 (S5 = RESULTADO DE LA POTENCIA)
	VSUB.F32 S4, S4, S6 ;S4 = S4 - 1 = n--
	VCMP.F32 S4, #0 ;Compara S4 con 0
	VMRS APSR_nzcv, FPSCR
	BEQ FinPot
	B Potencia
FinPot BX LR	
		
Factorial
	;Multiplicar el valor actual de n y el resultado acumulado.
	;S4 = RESULTADO DEL FACTORIAL
	VMUL.F32 S4,S3
	;Sustraer 1 al valor actual de n.
	VSUB.F32 S3,S5
	;Verificar si Resultado es igual a 0 (ya no quedan números por multiplicar).
	VCMP.F32 S4,#0
	VMRS APSR_nzcv, FPSCR ;Trasladar banderas de FPSCR a APSR.
	VMOVEQ.F32 S4, #1 ;El Resultado del factorial es 1.
	BEQ FinFactor ;Si Resultado es igual a 0, termina.
	;Verificar si n a llegado a 0 (ya no quedan números por multiplicar).
	VCMP.F32 S3,#0
	VMRS APSR_nzcv, FPSCR ;Trasladar banderas de FPSCR a APSR.
	BEQ FinFactor ;Si n es igual a 0, termina.
	;Verificar si se ha llegado a 1 (ya no quedan números por multiplicar).
	VCMP.F32 S3,S5
	VMRS APSR_nzcv, FPSCR ;Trasladar banderas de FPSCR a APSR.
	BNE Factorial ;Si n no es igual a 1, seguir operando
FinFactor BX LR

Serie_Seno
	VMOV.F32 S3, #-1 ;S3 = -1
	VMOV.F32 S4, S13 ;S4 = n
	VMOV.F32 S5, #1 ;S5 = 1
	BL Potencia
	VMOV.F32 S7, S5 ;S7 = S5 = (-1)^n
	
	VMOV.F32 S3, S0 ;S3 = x = Ángulo Azimut en radianes
	VMOV.F32 S8, #2 ;S8 = 2
	VMOV.F32 S9, S13 ;S9 = n
	VMOV.F32 S10, #1 ;S10 = 1
	VMLA.F32 S10, S8, S9 ;S10 = 2*n + 1
	VMOV.F32 S4, S10 ;S4 = 2*n + 1
	VMOV.F32 S5, #1 ;S5 = 1
	BL Potencia
	VMOV.F32 S8, S5 ;S8 = S5 = x^(2*n + 1)
	
	VMUL.F32 S7, S7, S8 ;S7 = S7*S8 = [(-1)^n]*[x^(2*n + 1)] NÚMERADOR
	
	VMOV.F32 S3, S10 ;S3 = 2*n + 1
	VMOV.F32 S4, #1 ;S4 = 1
	VMOV.F32 S5, #1 ;S5 = 1
	BL Factorial
	VMOV.F32 S8, S4 ;S8 = S4 = (2*n + 1)! DENOMINADOR
	
	VDIV.F32 S8, S7, S8 ;S8 = S7/S8 = [(-1)^n]*[x^(2*n + 1)]/(2*n + 1)! 
	VADD.F32 S11, S11, S8 ;S11 = S11 + S8 --> RESULTADO DEL Sen X
	
	VMOV.F32 S3, #1 ;S3 = 1
	VADD.F32 S13, S13, S3 ;S13 = S13 + 1 = n++
	VADD.F32 S4, S2, S3 ;S4 = S2 + 1 = (N+1)
	VCMP.F32 S13, S4 ;Compara n con (N+1)
	VMRS APSR_nzcv, FPSCR
	;BEQ Fin  ;Se verifica sí S13 = S4 --> Verifica si n = (N+1) y salta a FIN
	BNE Serie_Seno  ;Salta y regresa a ejecutar Serie del Seno
	;B Serie_Seno  ;Salta y regresa a ejecutar Serie del Seno
	
	
	VLDR.F32 S13, =0 ;S13 = 0 --> Se vuelve a inicializar n = 0
Serie_Coseno
	VMOV.F32 S3, #-1 ;S3 = -1
	VMOV.F32 S4, S13 ;S4 = n
	VMOV.F32 S5, #1 ;S5 = 1
	BL Potencia
	VMOV.F32 S7, S5 ;S7 = S5 = (-1)^n
	
	VMOV.F32 S3, S0 ;S3 = x = Ángulo Azimut en radianes
	VMOV.F32 S8, #2 ;S8 = 2
	VMOV.F32 S9, S13 ;S9 = n
	;VMOV.F32 S10, #1 ;S10 = 1
	;VMLA.F32 S10, S8, S9 ;S10 = 2*n + 1
	VMUL.F32 S10, S8, S9 ;S10 = 2*n
	;VMOV.F32 S4, S10 ;S4 = 2*n + 1
	VMOV.F32 S4, S10 ;S4 = 2*n
	VMOV.F32 S5, #1 ;S5 = 1
	BL Potencia
	;VMOV.F32 S8, S5 ;S8 = S5 = x^(2*n + 1)
	VMOV.F32 S8, S5 ;S8 = S5 = x^(2*n)
	
	;VMUL.F32 S7, S7, S8 ;S7 = S7*S8 = [(-1)^n]*[x^(2*n + 1)] NÚMERADOR
	VMUL.F32 S7, S7, S8 ;S7 = S7*S8 = [(-1)^n]*[x^(2*n)] NÚMERADOR
	
	;VMOV.F32 S3, S10 ;S3 = 2*n + 1
	VMOV.F32 S3, S10 ;S3 = 2*n
	VMOV.F32 S4, #1 ;S4 = 1
	VMOV.F32 S5, #1 ;S5 = 1
	BL Factorial
	;VMOV.F32 S8, S4 ;S8 = S4 = (2*n + 1)! DENOMINADOR
	VMOV.F32 S8, S4 ;S8 = S4 = (2*n)! DENOMINADOR
	
	;VDIV.F32 S8, S7, S8 ;S8 = S7/S8 = [(-1)^n]*[x^(2*n + 1)]/(2*n + 1)! 
	VDIV.F32 S8, S7, S8 ;S8 = S7/S8 = [(-1)^n]*[x^(2*n)]/(2*n)! 
	VADD.F32 S12, S12, S8 ;S12 = S12 + S8 --> RESULTADO DEL Cos X
	
	VMOV.F32 S3, #1 ;S3 = 1
	VADD.F32 S13, S13, S3 ;S13 = S13 + 1 = n++
	VADD.F32 S4, S2, S3 ;S4 = S2 + 1 = (N+1)
	VCMP.F32 S13, S4 ;Compara n con (N+1)
	VMRS APSR_nzcv, FPSCR
	;BEQ Fin  ;Se verifica sí S13 = S4 --> Verifica si n = (N+1) y salta a FIN
	BNE Serie_Coseno  ;Salta y regresa a ejecutar Serie del Coseno
	;B Serie_Coseno  ;Salta y regresa a ejecutar Serie del Coseno
	
CALCULAR_COORDENADAS
	;CALCULO DE LA COORDENADA EN X:
	VMUL.F32 S11, S1 ;S11 = (Sen X)*Distancia
	;CALCULO DE LA COORDENADA EN Y:
	VMUL.F32 S12, S1 ;S12 = (Cos X)*Distancia

Fin B Fin	

	ALIGN
	END	
	
	