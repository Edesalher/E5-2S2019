	THUMB
	AREA CLASE1, ALIGN=4
mem SPACE 4		
	AREA |text.|, CODE, READONLY, ALIGN=2
	EXPORT Start
Start
	VLDR.F32 S0,=5 ;Número a operar (n!).
	VMOV.F32 S1,#1 ;Registro para guardar resultado.
	VMOV.F32 S2,#1 ;Constante 1.
Factorial
	;Multiplicar el valor actual de n y el resultado acumulado.
	VMUL.F32 S1,S0
	;Sustraer 1 al valor actual de n.
	VSUB.F32 S0,S2
	;Verificar si Resultado es igual a 0 (ya no quedan números por multiplicar).
	VCMP.F32 S1,#0
	VMRS APSR_nzcv, FPSCR ;Trasladar banderas de FPSCR a APSR.
	VMOVEQ.F32 S1, #1 ;El Resultado del factorial es 1.
	BEQ Fin ;Si Resultado es igual a 0, termina.
	;Verificar si n a llegado a 0 (ya no quedan números por multiplicar).
	VCMP.F32 S0,#0
	VMRS APSR_nzcv, FPSCR ;Trasladar banderas de FPSCR a APSR.
	BEQ Fin ;Si n es igual a 0, termina.
	;Verificar si se ha llegado a 1 (ya no quedan números por multiplicar).
	VCMP.F32 S0,S2
	VMRS APSR_nzcv, FPSCR ;Trasladar banderas de FPSCR a APSR.
	BNE Factorial ;Si n no es igual a 1, seguir operando
Fin B Fin

	ALIGN
	END