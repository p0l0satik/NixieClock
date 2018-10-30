
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
											
											

											;SETING TIME OF THE CLOCK 
setm:										LDM r16, MIN2
											INC r16
											CPI r16, 10
											BREQ setm1
											RJMP set_time

setm1:										LDI MIN2, 0
											INC MIN1
											CPI MIN1,6
											BREQ setm2
											RJMP set_time

setm2:										LDI MIN1, 0
											RJMP set_time
											
											
											
seth:									
											
											INC HOUR2
											CPI HOUR2, 4
											BREQ seth3
ret_h:										CPI HOUR2, 10
											BREQ seth1
											RJMP set_time

seth3:										CPI HOUR1, 2
											BREQ seth2
											RJMP ret_h

seth1:										LDI HOUR2, 0
											INC HOUR1
											RJMP set_time

seth2:										LDI HOUR1, 0
											LDI HOUR2, 0
											LDI HOUR, 0
											RJMP set_time

set_time:								
											sbis PINB, 1
											RJMP set_time1
											RJMP set_time

set_time1:									SBIS PINB, 0
											RJMP quit
											RJMP set_time

quit:										
											STSI RTCAddr, cl_adr 
											RCALL RTC_WRITE
											RJMP end_set


end_set:									IN R16, PINB
											SBRS R16, 6
											RJMP quit

											;IN R16, PINB
											;SBRS R16, 3
											;RJMP quit

											RJMP start
