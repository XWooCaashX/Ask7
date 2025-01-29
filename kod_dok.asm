; ==================================================
; WYBÓR SYSTEMU LICZBOWEGO
; ==================================================

CLO             ; Czyścimy pamięć programu
IN 00           ; Oczekiwanie na wybór użytkownika: '1' - system dziesiętny, reszta - binarny
CMP AL, 31      ; Sprawdzamy, czy wciśnięto '1' (ASCII 31)
JZ system_dziesietny  ; Jeśli tak, przechodzimy do systemu dziesiętnego
MOV AL, 2       ; W przeciwnym razie ustawiamy system binarny
MOV [BC], AL    ; Zapisujemy wybór użytkownika w pamięci
JMP wprowadz_liczby  ; Przechodzimy do etapu wprowadzania liczb

; ==================================================
; SYSTEM DZIESIĘTNY
; ==================================================

system_dziesietny:
MOV AL, 10      ; Ustawiamy system dziesiętny
MOV [BC], AL    ; Zapisujemy wybór w pamięci
JMP wprowadz_liczby  ; Przechodzimy do wprowadzania liczb

; ==================================================
; WPISYWANIE LICZB
; ==================================================

wprowadz_liczby:
MOV CL, C1      ; Ustawiamy miejsce wyświetlania liczb
MOV DL, CB      ; Ustawiamy maksymalną liczbę cyfr na 10

petla_wprowadzania:
IN 00           ; Pobieramy cyfrę z klawiatury
CMP AL, 0D      ; Sprawdzamy, czy wciśnięto ENTER (ASCII 0D)
JZ krok         ; Jeśli tak, przechodzimy do obliczeń
CMP CL, DL      ; Sprawdzamy, czy liczba nie przekroczyła 10 cyfr
JZ blad_przekroczenia  ; Jeśli tak, zgłaszamy błąd
MOV [CL], AL    ; Zapisujemy cyfrę w pamięci
INC CL          ; Przechodzimy do następnej cyfry
JMP petla_wprowadzania  ; Powtarzamy pętlę dla kolejnej cyfry

; ==================================================
; PRZEJŚCIE DO OBLICZEŃ
; ==================================================

krok:
CMP CL, CF      ; Sprawdzamy, czy wpisano drugą liczbę
JNS oblicz_wynik  ; Jeśli tak, przechodzimy do obliczeń
MOV CL, D1      ; Zmieniamy miejsce wpisywania na drugą linię
MOV DL, DB      ; Ograniczamy liczbę cyfr do 10
JMP petla_wprowadzania  ; Wracamy do wpisywania drugiej liczby

; ==================================================
; OBLICZENIA (ODEJMOWANIE)
; ==================================================

oblicz_wynik:
MOV DL, [BC]    ; Pobieramy system liczbowy (2 lub 10)
DEC CL          ; Cofamy się do ostatniej cyfry

petla_obliczen:
CMP CL, CF      ; Sprawdzamy, czy zakończono obliczenia
JZ koniec_programu  ; Jeśli tak, kończymy program
MOV AL, [CL]    ; Pobieramy cyfrę z drugiej liczby
CMP AL, 20      ; Sprawdzamy, czy to spacja (ASCII 20)
JZ koniec_programu  ; Jeśli tak, kończymy program
SUB CL, 10      ; Przechodzimy do pierwszej cyfry
MOV BL, [CL]    ; Pobieramy cyfrę z pierwszej liczby
ADD CL, 20      ; Przechodzimy do miejsca wyniku
SUB BL, AL      ; Odejmujemy drugą cyfrę od pierwszej
PUSH BL         ; Zapisujemy wynik na stosie
POP AL          ; Pobieramy wynik ze stosu
CMP AL, 0       ; Sprawdzamy, czy wynik jest ujemny
JS pozyczka     ; Jeśli tak, przechodzimy do obsługi pożyczki
JMP wypisz_wynik  ; Jeśli nie, przechodzimy do wyświetlenia wyniku

; ==================================================
; OBSŁUGA POŻYCZKI
; ==================================================

pozyczka:
ADD AL, DL      ; Dodajemy wartość systemu (2 lub 10), żeby poprawić wynik
DEC CL          ; Cofamy się do poprzedniej cyfry
MOV BL, [CL]    ; Pobieramy wartość
DEC BL          ; Odejmujemy 1 (pożyczka)
MOV [CL], BL    ; Zapisujemy nową wartość
ADD CL, 10      ; Wracamy do właściwej cyfry

; ==================================================
; SYGNALIZACJA BŁĘDU (PRZEKROCZENIE LIMITU CYFR)
; ==================================================

blad_przekroczenia:
MOV AL, 90      ; Przypisanie do AL wartości 90 (czerwone światło)
OUT 01          ; Wyświetlenie czerwonego światła na wyjściu 01
JMP koniec_programu  ; Skok do zakończenia programu

; ==================================================
; WYŚWIETLENIE WYNIKU
; ==================================================

wypisz_wynik:
ADD AL, 30      ; Konwersja wyniku na ASCII
MOV [CL], AL    ; Zapisujemy wynik w pamięci
SUB CL, 11      ; Przechodzimy do kolejnej pary cyfr
JMP petla_obliczen  ; Powtarzamy obliczenia dla następnej pary

; ==================================================
; KONIEC PROGRAMU
; ==================================================

koniec_programu:
END  ; Zatrzymujemy program
