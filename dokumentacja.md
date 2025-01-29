# 📚 Dokumentacja - Odejmowanie SMS32v50
---

## 📌 Treść projektu
Pisemne odejmowanie w systemie dwójkowym i dziesiętnym. Wyboru systemu użytkownik dokonuje na początku działania programu. Liczby wprowadzane są z klawiatury, a wynik wyświetla się na wyświetlaczu VDU. Zalecane jest także wyświetlanie wprowadzanych liczb. Dodawane liczby mają 1-10 cyfr. Jeżeli podczas wprowadzania zostanie podane więcej niż 10 cyfr, to fakt ten zostanie zasygnalizowany na sygnalizacji świetlnej. Podobnie należy zasygnalizować przekroczenie 10 cyfr w wynikowej liczbie.

---

Program realizuje odejmowanie dwóch liczb w systemie dziesiętnym lub binarnym, z obsługą błędów i wyświetlaniem wyników. Wspiera wprowadzanie danych z klawiatury oraz wyświetlanie wyników na ekranie VDU.



---

## 📌 Spis treści
1. [Opis działania programu](#📝-opis-działania-programu)  
2. [Kod programu z opisem](#💻-kod-programu-z-opisem)  
   - [Wybór systemu liczbowego](#🛠️-1-wybór-systemu-liczbowego)  
   - [System dziesiętny](#🔟-2-system-dziesiętny)  
   - [Wprowadzanie liczb](#🔢-3-wprowadzanie-liczb)  
   - [Przejście do obliczeń](#➡️-4-przejście-do-obliczeń)  
   - [Obliczenia (odejmowanie)](#➖-5-obliczenia-odejmowanie)  
   - [Obsługa pożyczki](#🔄-6-obsługa-pożyczki)  
   - [Sygnalizacja błędu](#⚠️-7-sygnalizacja-błędu)  
   - [Wyświetlenie wyniku](#📊-8-wyświetlenie-wyniku)  
   - [Koniec programu](#🏁-9-koniec-programu)  


---

## 📝 Opis działania programu

Pisemne odejmowanie w systemie dwójkowym i dziesiętnym. Wyboru systemu użytkownik dokonuje na początku działania programu. Liczby wprowadzane są z klawiatury, a wynik wyświetla się na wyświetlaczu VDU. Zalecane jest także wyświetlanie wprowadzanych liczb. Dodawane liczby mają 1-10 cyfr. Jeżeli podczas wprowadzania zostanie podane więcej niż 10 cyfr, to fakt ten zostanie zasygnalizowany na sygnalizacji świetlnej. Podobnie należy zasygnalizować przekroczenie 10 cyfr w wynikowej liczbie.

### ✨ Główne funkcjonalności programu
- Możliwość wyboru systemu liczbowego.
- Obsługa liczb o maksymalnej długości 10 cyfr.
- Automatyczna obsługa pożyczek w odejmowaniu.
- Sprawdzenie poprawności wprowadzonych danych.
- Sygnalizacja błędów (np. przekroczenie limitu cyfr).
- Czytelne wyświetlanie wyniku na ekranie VDU.

---

## 💻 Kod programu z opisem

### 🔧 1. Wybór systemu liczbowego
**Program rozpoczyna od wyczyszczenia pamięci i pobrania wyboru systemu liczbowego.**

```assembly
CLO             ; Czyścimy pamięć programu
IN 00           ; Oczekiwanie na wybór użytkownika: '1' - system dziesiętny, reszta - binarny
CMP AL, 31      ; Sprawdzamy, czy wciśnięto '1' (ASCII 31)
JZ system_dziesietny  ; Jeśli tak, przechodzimy do systemu dziesiętnego
MOV AL, 2       ; W przeciwnym razie ustawiamy system binarny
MOV [BC], AL    ; Zapisujemy wybór użytkownika w pamięci
JMP wprowadz_liczby  ; Przechodzimy do etapu wprowadzania liczb
```

### 🔟 2. System dziesiętny
**Jeśli użytkownik wybrał system dziesiętny, program ustawia odpowiednią wartość w pamięci i przechodzi do wprowadzania liczb.**

```assembly
system_dziesietny:
MOV AL, 10      ; Ustawiamy system dziesiętny
MOV [BC], AL    ; Zapisujemy wybór w pamięci
JMP wprowadz_liczby  ; Przechodzimy do wprowadzania liczb
```

### 🔢 3. Wprowadzanie liczb
**Użytkownik wprowadza pierwszą i drugą liczbę znak po znaku. Program sprawdza, czy nie przekroczono limitu 10 cyfr i zapisuje wartości w odpowiednich miejscach pamięci.**

```assembly
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
```

### ➡️ 4. Przejście do obliczeń
**Po wprowadzeniu liczb program przechodzi do etapu obliczeń.**

```assembly
krok:
CMP CL, CF      ; Sprawdzamy, czy wpisano drugą liczbę
JNS oblicz_wynik  ; Jeśli tak, przechodzimy do obliczeń
MOV CL, D1      ; Zmieniamy miejsce wpisywania na drugą linię
MOV DL, DB      ; Ograniczamy liczbę cyfr do 10
JMP petla_wprowadzania  ; Wracamy do wpisywania drugiej liczby
```

### ➖ 5. Obliczenia (odejmowanie)
**Program wykonuje odejmowanie cyfra po cyfrze, uwzględniając pożyczkę.**

```assembly
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
```

### 🔄 6. Obsługa pożyczki
**Jeśli wynik odejmowania jest ujemny, program obsługuje pożyczkę od następnej cyfry.**

```assembly
pozyczka:
ADD AL, DL      ; Dodajemy wartość systemu (2 lub 10), żeby poprawić wynik
DEC CL          ; Cofamy się do poprzedniej cyfry
MOV BL, [CL]    ; Pobieramy wartość
DEC BL          ; Odejmujemy 1 (pożyczka)
MOV [CL], BL    ; Zapisujemy nową wartość
ADD CL, 10      ; Wracamy do właściwej cyfry
```

### ⚠️ 7. Sygnalizacja błędu (przekroczenie limitu cyfr)
**Jeśli użytkownik przekroczy limit 10 cyfr, program sygnalizuje błąd.**

```assembly
blad_przekroczenia:
MOV AL, 90      ; Przypisanie do AL wartości 90 (czerwone światło)
OUT 01          ; Wyświetlenie czerwonego światła na wyjściu 01
JMP koniec_programu  ; Skok do zakończenia programu
```

### 📊 8. Wyświetlenie wyniku
**Program wyświetla wynik na ekranie VDU.**

```assembly
wypisz_wynik:
ADD AL, 30      ; Konwersja wyniku na ASCII
MOV [CL], AL    ; Zapisujemy wynik w pamięci
SUB CL, 11      ; Przechodzimy do kolejnej pary cyfr
JMP petla_obliczen  ; Powtarzamy obliczenia dla następnej pary
```

### 🏁 9. Koniec programu
**Program kończy działanie po wyświetleniu wyniku.**

```assembly
koniec_programu:
END  ; Zatrzymujemy program
```
