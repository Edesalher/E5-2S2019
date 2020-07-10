	THUMB
	AREA CLASE1, ALIGN=4
mem SPACE 4		
	AREA |text.|, CODE, READONLY, ALIGN=2
	EXPORT Start
			
Start
	VMOV.F32 S0, #1  ;Se asigna el valor de "n" al registro S0 --> S0 = n
	VMOV.F32 S1, #10  ;Se asigna el valor de "N" al registro S1 --> S1 = N
	
	VMOV.F32 S3, #1
	VADD.F32 S2, S1, S3  ;S2 = S1 + 1 --> S2 = N + 1
	VMOV.F32 S4, #2

Serie
	VMUL.F32  S5, S4, S0  ;S5 = S4 x S0 --> S5 = 2n
	VSQRT.F32 S6, S0      ;S6 = Raíz cuadrada de S0 --> S6 = Raíz de n	
	
	VMUL.F32  S7, S0, S0  ;S7 = S0 x S0
	VMUL.F32  S7, S0      ;S7 = S7 x S0 --> S7 = n^3 --> Se obtiene la potencia de n^3.	
	
	VADD.F32  S8, S5, S6  ;S8 = S5 + S6 --> 2n + Raíz n
	VADD.F32  S9, S7, S6  ;S9 = S7 + S6 --> n^3 + Raíz n
	VDIV.F32  S10, S8, S9 ;S10 = S8/S9 --> (2n + Raíz n)/(n^3 + Raíz n)	
	VADD.F32  S11, S10  ;S11 = S11 + S10 ---> RESULTADO. SE HACE LA SUMATORIA DE LA SERIE.
	
	VADD.F32  S0, S0, S3  ; S0 = S0 + 1 --> n = n + 1 --> n++
	VCMP.F32  S0, S2  ; Se compara S0 con S2 --> Comparar n con (N+1)
	VMRS APSR_nzcv, FPSCR
    BEQ Fin  ;Se verifica sí S0 = S2 --> Verifica si n = (N+1) y salta a FIN
	B Serie  ;Salta y regresa a ejecutar Serie
	
Fin B Fin  ;Finaliza Serie
	

	ALIGN
	END