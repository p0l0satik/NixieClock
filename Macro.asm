;MACRO========================================================================================================================================================
.MACRO STSI
	LDI R16, @1
	STS @0, R16
.ENDM

.MACRO LDMM
	PUSH R16
	LDS R16, @2
	STS @1, R16
	POP R16
.ENDM

.MACRO OUTI
	PUSH r16
	LDI r16, @1
	STS @1, r16
	pop r16
.ENDM
.macro ADIC
	push r16
	LDI r16, @1
	ADC @0, R16
	pop r16
.ENDM

.macro incm
	push r16
	lds r16, @0
	inc r16
	sts @0, r16
	pop r16
.endmacro

.macro decm
	push r16
	lds r16, @0
	dec r16
	sts @0, r16
	pop r16
.endmacro
//=================================================================