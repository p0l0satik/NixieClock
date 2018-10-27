;Currently working Nixie CLock
;
;Created by Polosatic
;
/*
portC - numbers
PortD - lamps

	0000 - 9
	1000 - 3
	0001 - 4
	0010 - 2
	0011 - 7
	0100 - 1
	1001 - 8
	1010 - 6
	1011 - 5
	1100 - 0
	

*/
											.dseg
RTCAddr:									.byte	1

											;variables for clock
sec_o:										.byte	1
min_o:										.byte	1
hour_o:										.byte	1
//содержит время в формате H1 H2 M1 M2 S1 S2
time_array:									.byte	6
current_seg:								.byte	1




	
											.cseg
											.equ	cl_adr	= 0x02

											//.equ    status_reg = 0x00
											//.equ	alarm_reg = 0x08


.include "Macro.asm"
											.def HOUR1 = R20
											.def HOUR2 = R21
											.def MIN1 = R22
											.def MIN2 = R23
											.def HOUR = R24
											.def SEC1 = R25										
											.def SEC2 = R26
																						
											.def OSRG = R18

nums: .db 0b00001100, 0b00000100, 0b00000010, 0b00001000, 0b00000001, 0b00001011, 0b00001010, 0b00000011, 0b00001001, 0b00000000

											LDI R16, 0b11111111
											out DDRD, R16
											out DDRC, r16 //configure ports to output
											out PORTB, R16

											LDI R16, 0b00000000
											out DDRB, R16

											LDI R16, low(RAMEND) //stack init
											out SPL, r16
											LDI R16, high(RAMEND)
											out SPH, r16
											LDI SEC1, 3
											LDI SEC2, 0

	

start:
											STSI RTCAddr, 0x02
											rcall RTC_READ

											
											// кнопка на порте Б6 инвертирована
											SBIC PINB, 1
											RJMP setm
		
											sbic PINB, 0
											RJMP seth 

											

											;converts registers to memory
convert:
											ldi YL, low(time_array)
											ldi YH, high(time_array)
											st  Y+,  HOUR1
											st  Y+,  HOUR2
											st  Y+,  MIN1
											st  Y+,  MIN2
											st  Y+,  SEC1
											st  Y,   SEC2
											


											
											
											ldi r16, 0

light_seg:										
												mov r17, r16
												push r16
												ldi YL, low(time_array)
												ldi YH, high(time_array)
												add YL, r16
												adic YL, 0
												ld r16, Y
												rcall choose
												out PORTC, r16
												ldi r16, 1
	mv:											cpi r17, 0
													breq fn_mv
													lsl r16
													subi r17, 1
													rjmp mv
	fn_mv:										out PORTD, r16
												rcall tup
												pop r16
												inc r16
												cpi r16, 7
												brlo light_seg 
	
	
											rjmp start

;PRocedures






;задержка					
tup:  
											ldi r17, 100
											ldi r19, 3

											zad:
												subi r17, 1
												cpi r17, 1
												brsh zad
												zad2:
													subi r19, 1
													cpi r19, 1
													brsh zad
												ret
;выбор цифры для индикации
; the number send/received via R16
choose:
											LDI ZL, low(nums * 2)
											LDI ZH, high(nums * 2)
											add ZL, r16
											ADIC ZH, 0

											LPM r16, Z ;was r17
											ret

										.include "IIC_logic.asm"
										.include "Time_func.asm"

