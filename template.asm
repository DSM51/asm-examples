




pin_beep            equ P1.5
pin_segment         equ P1.6
pin_diode           equ P1.7

pin_keyboard        equ P3.5


;
;
;

org 0x0000
; start programu
reset:
            ljmp start

org 0x0003
; przerwanie od urządzenia zewnętrznego - z wejścia INT0
interrupt_int0:
            reti

org 0x000b
; przerwanie od licznika T0
interrupt_t0:
            reti

org 0x0013
; przerwanie od urządzenia zewnętrznego - z wejścia INT1
interrupt_int1:
            reti

org 0x001b
; przerwanie od licznika T1
interrupt_t1:
            reti

org 0x0023
; przerwanie od portu transmisji szeregowej
interrupt_serial:
            reti





;
;   START PROGRAMU
;

start:



;
;   PĘTLA GŁÓWNA
;

loop:


            ljmp loop





;
;   7-SEGMENT
;

; procedura zemianiająca cyfrę na kod 7-segmentowy
segment_convert_safe:
        anl A, # 0x0f           ; ogranicz do znaków 0..15
segment_convert:
        inc A                   ; pomiń rozkaz ret (zajmuje jeden bajt)
        movc A, @PC+A           ; pobierz kod odpowiadający cyfrze
        ret                     ; koniec

; kody znaków dla wyświetlacza 7-segmentowego
; zobacz: https://dsm51.github.io/calc-7segment/
        db 0b00111111           ; 0
        db 0b00000110           ; 1
        db 0b01011011           ; 2
        db 0b01001111           ; 3
        db 0b01100110           ; 4
        db 0b01101101           ; 5
        db 0b01111101           ; 6
        db 0b00000111           ; 7
        db 0b01111111           ; 8
        db 0b01101111           ; 9
        db 0b01110111           ; A
        db 0b01111100           ; b
        db 0b01011000           ; c
        db 0b01011110           ; d
        db 0b01111001           ; E
        db 0b01110001           ; F





;
;   LCD (FUNKCJE WBUDOWANE)
;

; wypisuje w oknie LCD tekst ascii wskazany przez rejestr DPTR
; tekst musi być zakończony null-em
; zajętość stosu: 2 bajty
; zmieniane rejestry: A, PSW, DPTR
; używane rejestry: R0
; input: DPTR
lcd_write_text      equ 0x8100

; wypisuje w oknie LCD znak
; zajętość stosu: 2 bajty
; zmieniane rejestry: A, PSW
; używane rejestry: R0
; input: A
lcd_write_data      equ 0x8102

; wypisuje w oknie LCD znak, w formacie szesnastkowym z akumulatora, np "AF"
; zajętość stosu: 3 bajty
; zmieniane rejestry: A, PSW
; używane rejestry: R0
; input: A
lcd_write_hex       equ 0x8104

; wysyła do sterownika wyświetlacza LCD bajtowy rozkaz
; zajętość stosu: 2 bajty
; zmieniane rejestry: A, PSW
; używane rejestry: R0
; input: A
lcd_write_instr     equ 0x8106

; inicjuje prawę wyświetlacza LCD, po inicjacji można wyświetlać dane w oknie LCD
; zajętość stosu: 2 bajty
; zmieniane rejestry: A, PSW
; używane rejestry: R0
lcd_on              equ 0x8108

; wyłącza wyświetlacz LCD, ponowne uruchomienie LCD wymaga inicjacji wyświetlacza (`lcd_on`)
; zajętość stosu: 1 bajt
; zmieniane rejestry: A, PSW
; używane rejestry: R0
lcd_off             equ 0x810a

; ksuje zawartość okna LCD i ustawia kursor w lewym górnym rogu
; zajętość stosu: 1 bajt
; zmieniane rejestry: A, PSW
; używane rejestry: R0
lcd_clear           equ 0x810c
