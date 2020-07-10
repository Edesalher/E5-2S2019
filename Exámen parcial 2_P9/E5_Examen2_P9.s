;PROGRAMA QUE PERMITE CALCULAR EL COSTO DE UNA LLAMADA
	
	THUMB
	AREA CLASE1, ALIGN=4
mem SPACE 4		
	AREA |text.|, CODE, READONLY, ALIGN=2
	EXPORT Start
		
Start
	;DURACIÓN DE LLAMADA EN MINUTOS (min):
	VLDR.F32 S0, =2
	;MINUTOS DE REFERENCIA (min):
	VMOV.F32 S1, #3
	B Verificar_Minutos
	
Verificar_Minutos
	VSUB.F32 S2, S1, S0 ;S2 = 3 - Minutos
	VCMP.F32 S2, #0 ;Se verifica si S2 es igual a 0 
	VMRS APSR_nzcv, FPSCR
	BEQ CostoPorMinuto_0_5 ;S2 = 0 por tanto, duración = 3 min.
	VMUL.F32 S3, S2, S2 ;S3 = S2*S2
	VSQRT.F32 S3, S3 ;Raíz cuadrada de S3
	VSUB.F32 S3, S2 ;S3 = S3 - S2
	VCMP.F32 S3, #0 ;Se verifica si S3 es igual a 0 
	VMRS APSR_nzcv, FPSCR
	BEQ CostoPorMinuto_0_5 ;S3 = 0 por tanto, duración < 3 min.
	B CostoPorMinuto_0_6 ;S3 =! 0 por tanto, duración > 3 min.
	
CostoPorMinuto_0_5
	VLDR.F32 S2, =0.5 ;S2 = 0.5
	VMUL.F32 S3, S0, S2 ;S3 = COSTO POR LA LLAMADA >= a 3 min.
	B Fin

CostoPorMinuto_0_6
	VLDR.F32 S2, =0.6 ;S2 = 0.6
	VMUL.F32 S3, S0, S2 ;S3 = COSTO POR LA LLAMADA > a 3 min.
	
Fin B Fin

	ALIGN
	END