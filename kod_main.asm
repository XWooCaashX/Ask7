; WYBÓR SYSTEMU LICZBOWEGO
; Wybór użytkownika: '1' dla systemu dziesiętnego, inaczej binarny
CLO             ; Czyścimy pamięć
IN 00           ; Pobranie wyboru
CMP AL, 31
JZ system_dziesietny
MOV AL, 2
MOV [BC], AL
JMP wprowadz_liczby

; SYSTEM DZIESIĘTNY
system_dziesietny:
MOV AL, 10
MOV [BC], AL
JMP wprowadz_liczby

; WPISYWANIE LICZB
; Pobieramy cyfry do maksymalnej długości
wprowadz_liczby:
MOV CL, C1
MOV DL, CB

petla_wprowadzania:
IN 00
CMP AL, 0D      ; ENTER kończy wprowadzanie
JZ krok
CMP CL, DL
JZ blad_przekroczenia
MOV [CL], AL
INC CL
JMP petla_wprowadzania

; PRZEJŚCIE DO OBLICZEŃ
krok:
CMP CL, CF
JNS oblicz_wynik
MOV CL, D1
MOV DL, DB
JMP petla_wprowadzania

; OBLICZENIA (ODEJMOWANIE)
oblicz_wynik:
MOV DL, [BC]
DEC CL

petla_obliczen:
CMP CL, CF
JZ koniec_programu
MOV AL, [CL]
CMP AL, 20
JZ koniec_programu
SUB CL, 10
MOV BL, [CL]
ADD CL, 20
SUB BL, AL
PUSH BL
POP AL
CMP AL, 0
JS pozyczka
JMP wypisz_wynik

; OBSŁUGA POŻYCZKI
pozyczka:
ADD AL, DL
DEC CL
MOV BL, [CL]
DEC BL
MOV [CL], BL
ADD CL, 10

; SYGNALIZACJA BŁĘDU (PRZEKROCZENIE LIMITU CYFR)
blad_przekroczenia:
MOV AL, 90
OUT 01
JMP koniec_programu

; WYŚWIETLENIE WYNIKU
wypisz_wynik:
ADD AL, 30
MOV [CL], AL
SUB CL, 11
JMP petla_obliczen

; KONIEC PROGRAMU
koniec_programu:
END
