
t0_const		equ 65535 - 921

t0_flag			bit 0
diode_flag		bit 1

csds			equ  0ff30h
csdb			equ  0ff38h

second_counter_l	equ  30h
second_counter_h	equ  31h





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

		clr t0_flag
		clr diode_flag

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
		ljmp loop



service_t0:
		jnz second_counter_l, st1
		mov second_counter_l, # 50

		djnz second_counter_h, st1
		mov second_counter_h, # 20

		setb diode_flag
st1:
		ret



service_diode:
		cpl P1.7
		ret

end
