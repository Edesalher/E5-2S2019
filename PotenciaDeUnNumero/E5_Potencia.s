;POTENCIA n de cualquier número
	
	THUMB
	AREA CLASE1, ALIGN=4
mem SPACE 4		
	AREA |text.|, CODE, READONLY, ALIGN=2
	EXPORT Start

Start
	;NÚMERO A ELEVAR:
	VLDR.F32 S0, =3
	;EXPONENTE n DE LA POTENCIA:
	VLDR.F32 S1, =5
	
	VMOV.F32 S2, #1 ;S2 = 1 (S2 = RESULTADO DE LA POTENCIA)
		
Potencia 
	VCMP.F32 S1, #0 ;Compara S1 con 0
	VMRS APSR_nzcv, FPSCR
	BEQ Fin
	
	VMOV.F32 S3, #1 ;S3 = 1
	VMUL.F32 S2, S2, S0 ;S2 = S2*S0
	VSUB.F32 S1, S1, S3 ;S1 = S1 - 1 = n--
	VCMP.F32 S1, #0 ;Compara S1 con 0
	VMRS APSR_nzcv, FPSCR
	BEQ Fin
	B Potencia
	
Fin B Fin	

	ALIGN
	END