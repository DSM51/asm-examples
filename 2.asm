//
//  2.asm
//  asm-examples
//
//  Created by Damian Rzeszot on 06/12/2017.
//  Copyright © 2017 Damian Rzeszot. All rights reserved.
//

t0_const		equ 65535 - 921

t0_flag			bit 0
diode_flag		bit 1
seg_flag		bit 2

csds			equ 0ff30h
csdb			equ 0ff38h

second_counter_l	equ 30h
second_counter_h	equ 31h

segment_counter		equ 32h

segment_index		equ 33h
segment_data 		equ 34h



org  0h
reset:
		ljmp  start

org  0bh
t0_int:
		orl TL0, # low t0_const
		mov TH0, # high t0_const
		setb t0_flag
		reti



org 100h
start:
		mov second_counter_l, # 1
		mov second_counter_h, # 1

		mov segment_data + 0, # 3fh
		mov segment_data + 1, # 06h
		mov segment_data + 2, # 5bh
		mov segment_data + 3, # 4fh
		mov segment_data + 4, # 66h
		mov segment_data + 5, # 6dh

		mov segment_index, # 0

		clr t0_flag
		clr diode_flag
		clr seg_flag

main:
		mov TL0, # low t0_const
		mov TH0, # high t0_const
		mov TMOD, #1
		setb TR0
		setb EA
		setb ET0

loop:
		jnb t0_flag, l1
		clr t0_flag
		lcall service_t0
l1:
		jnb diode_flag, l2
		clr diode_flag
		lcall service_diode
l2:
		jnb	seg_flag, l3
		clr	seg_flag
		lcall	service_segment
l3:
		ljmp loop



service_t0:
		djnz segment_counter, st0
		mov segment_counter, # 2
		setb seg_flag
st0:

		djnz second_counter_l, st1
		mov second_counter_l, # 50

		djnz second_counter_h, st1
		mov second_counter_h, # 20

		setb diode_flag
st1:
		ret



service_diode:
		cpl P1.7
		ret



service_segment:
		inc segment_index
		mov A, segment_index
		cjne A, # 6, ss1
		mov segment_index, # 0
ss1:
		setb P1.6

		mov A, segment_index
		lcall encode_index
		mov DPTR, # csds
		movx @DPTR, A

		mov A, segment_index
		lcall segment_read

		mov DPTR, # csdb
		movx @DPTR, A

		clr P1.6
		ret



segment_read:
		add A, # segment_data
		mov R0, A
		mov A, @R0
		ret



encode_index:
		inc A
		movc A, @A+PC
		ret
codes_index:
		db 00100000b ; 0
		db 00010000b ; 1
		db 00001000b ; 2
		db 00000100b ; 3
		db 00000010b ; 4
		db 00000001b ; 5



encode_number:
		inc A
		movc A, @A+PC
		ret
codes_number:
		db 3fh ; 0
		db 06h ; 1
		db 5bh ; 2
		db 4fh ; 3
		db 66h ; 4
		db 6dh ; 5
		db 7dh ; 6
		db 07h ; 7
		db 7fh ; 8
		db 6fh ; 9

end
