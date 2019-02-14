
		unpack:								push r16
															
											LDS r16, sec_o	
											ANDI r16, 0b11110000 
											SWAP r16
											STS SEC1, r16
											LDS r16, sec_o
											ANDI r16, 0b00001111 
											STS SEC2, r16

											
											LDS r16, min_o	
											ANDI r16, 0b11110000 
											SWAP r16
											STS MIN1, r16
											LDS r16, min_o	
											ANDI r16, 0b00001111
											STS MIN2, r16
											

											LDS r16, hour_o	
											ANDI r16, 0b11110000 
											SWAP r16
											STS HOUR1, r16
											LDS r16, hour_o	
											ANDI r16, 0b00001111
											STS HOUR2, r16
											pop r16
											RET
;========================

		pack:								push r16
											LDI R16,0
											STS sec_o, R16 


											LDS R16, MIN1 
											SWAP R16	
											LDS r17, MIN2
											ADD R16, r17	
											STS min_o, R16
											
											
											LDS R16, HOUR1 
											SWAP R16	
											LDS r17, HOUR2
											ADD R16, r17	
											STS hour_o, R16

											pop r16
											RET
;==========================
											
set_hour1:
											rcall tup
											rcall tup
											rcall tup
											push r16
											push r17

											LDS r16, HOUR1
cycle1:											;mov r17, r16
												push r16
												rcall choose
												out PORTC, r16
												ldi r16, 0b00000001
												out PORTD, r16
												pop r16

												

												
												SBIC PINB, 1
												rcall inc_t

												sbic PINB, 0
												rcall dec_t
											
												cpi  r16, 10
												BRLO not_bigger1
													STSI HOUR1, 0
												STS HOUR1, R16

not_bigger1:									in r17, PINB
												rcall tup
												rcall tup
												SBRC r17, 6
													rjmp cycle1 // продолжаем цикл
												pop r16 //идем к следующему сегменту
												pop r17
												rcall end_btn
												ret

;===========================
end_btn:										rcall tup
												rcall tup
												in r17, PINB
												SBRS r17, 6
													rjmp end_btn
												ret



;============================
inc_t:
											inc r16
dreb1:										rcall tup
											rcall tup
											IN R17, PINB
											SBRS R17, 1
											ret
											rjmp dreb1
;=============================											
dec_t:
											dec r16
dreb2:										rcall tup
											rcall tup
											IN R17, PINB
											SBRS R17, 0
											ret
											rjmp dreb2



















											;SETING TIME OF THE CLOCK 
setm:										;LDS r16, MIN2
											;INC r16
											;CPI r16, 10
											;BREQ setm1
											;RJMP set_time

setm1:										;LDI MIN2, 0
											;INC MIN1
											;CPI MIN1,6
											;BREQ setm2
											;RJMP set_time

setm2:										;LDI MIN1, 0
											;RJMP set_time
											
											
											
seth:									
											
											;INC HOUR2
											;CPI HOUR2, 4
											;BREQ seth3
ret_h:										;CPI HOUR2, 10
											;BREQ seth1
											;RJMP set_time

seth3:										;CPI HOUR1, 2
											;BREQ seth2
											;RJMP ret_h

seth1:										;LDI HOUR2, 0
											;INC HOUR1
											;RJMP set_time

seth2:										;LDI HOUR1, 0
											;LDI HOUR2, 0
											;LDI HOUR, 0
											;RJMP set_time

set_time:								
											;sbis PINB, 1
											;RJMP set_time1
											;RJMP set_time

set_time1:									;SBIS PINB, 0
											;RJMP quit
											;RJMP set_time

quit:										
											;STSI RTCAddr, cl_adr 
											;RCALL RTC_WRITE
											;RJMP end_set


end_set:									;IN R16, PINB
											;SBRS R16, 6
											;RJMP quit

											;IN R16, PINB
											;SBRS R16, 3
											;RJMP quit

											;RJMP start
