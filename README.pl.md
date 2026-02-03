# withings-sync - Instrukcja dla Windows

Narzedzie do synchronizacji danych z wagi Withings do Garmin Connect i TrainerRoad.

## Wymagania systemowe

- Windows 10 lub nowszy
- Polaczenie z Internetem
- Konto Withings z podlaczona waga
- Konto Garmin Connect (opcjonalne)
- Konto TrainerRoad (opcjonalne)

## Szybka instalacja

Otwórz PowerShell jako Administrator i wykonaj:

```powershell
git clone https://github.com/jaroslawhartman/withings-sync.git
cd withings-sync
.\setup.ps1
```

## Jak otworzyc terminal w folderze projektu

1. Otwórz Eksplorator Windows
2. Przejdz do folderu `withings-sync`
3. Kliknij prawym przyciskiem myszy w pustym miejscu
4. Wybierz "Otwórz w terminalu" lub "Otwórz okno polecen tutaj"

Alternatywnie:
1. Nacisnij `Win + R`
2. Wpisz `powershell`
3. Wpisz `cd C:\sciezka\do\withings-sync`

## Instalacja reczna krok po kroku

### 1. Instalacja uv (menedzer pakietów Python)

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Zamknij i otwórz ponownie PowerShell.

### 2. Instalacja Python 3.12

```powershell
uv python install 3.12.11
```

### 3. Pobranie projektu

```powershell
git clone https://github.com/jaroslawhartman/withings-sync.git
cd withings-sync
```

### 4. Instalacja zaleznosci

```powershell
uv sync --frozen
```

### 5. Utworzenie folderu konfiguracji

```powershell
mkdir $env:USERPROFILE\.withings-sync
```

## Autoryzacja Withings OAuth

Przy pierwszym uruchomieniu musisz autoryzowac dostep do konta Withings:

```powershell
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync
```

1. Program wyswietli link - skopiuj go do przegladarki
2. Zaloguj sie do konta Withings
3. Zatwierdz dostep aplikacji
4. Skopiuj kod autoryzacyjny (TOKEN)
5. Wklej TOKEN w terminalu i nacisnij ENTER
6. **UWAGA**: Masz 30 sekund na wklejenie tokenu!

Po pomyslnej autoryzacji plik sesji zostanie zapisany w folderze konfiguracji.

## Autoryzacja Garmin Connect

Aby synchronizowac dane z Garmin Connect:

```powershell
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync --garmin-username TWOJ_EMAIL --garmin-password TWOJE_HASLO
```

Lub ustaw zmienne srodowiskowe:

```powershell
$env:GARMIN_USERNAME = "twoj@email.com"
$env:GARMIN_PASSWORD = "twoje_haslo"
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync
```

## Uzycie codzienne

### Podstawowa synchronizacja

```powershell
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync
```

### Synchronizacja z okreslonym zakresem dat

```powershell
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync --fromdate 2024-01-01 --todate 2024-01-31
```

### Eksport do pliku FIT

```powershell
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync --to-fit --output pomiary
```

### Eksport do JSON

```powershell
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync --to-json --output pomiary
```

### Tryb verbose (wiecej informacji)

```powershell
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync --verbose
```

### Pomoc

```powershell
uv run withings-sync --help
```

## Harmonogram Zadan Windows (Task Scheduler)

Aby automatycznie synchronizowac dane codziennie:

### 1. Utworz skrypt batch

Utwórz plik `sync-withings.bat` w folderze projektu:

```batch
@echo off
cd /d C:\sciezka\do\withings-sync
uv run withings-sync --config-folder %USERPROFILE%\.withings-sync --silent
```

### 2. Otwórz Harmonogram zadan

1. Nacisnij `Win + R`
2. Wpisz `taskschd.msc`
3. Nacisnij ENTER

### 3. Utwórz nowe zadanie

1. Kliknij "Utwórz zadanie podstawowe..."
2. Nazwa: `Withings Sync`
3. Wyzwalacz: Codziennie, o wybranej godzinie (np. 8:00)
4. Akcja: Uruchom program
5. Program: `C:\sciezka\do\withings-sync\sync-withings.bat`
6. Zaznacz "Otwórz okno wlasciwosci dla tego zadania po kliknieciu Zakoncz"
7. W zakladce "Ogólne" zaznacz "Uruchom niezaleznie od tego, czy uzytkownik jest zalogowany"

## Rozwiazywanie problemów

### Blad: "uv nie jest rozpoznawane"

Zamknij i otwórz ponownie PowerShell. Jesli problem sie powtarza:

```powershell
$env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
```

### Blad: Token wygasl

Usun plik sesji i autoryzuj ponownie:

```powershell
Remove-Item $env:USERPROFILE\.withings-sync\withings_*
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync
```

### Blad: Timeout podczas autoryzacji

Token Withings jest wazny tylko 30 sekund. Wykonaj autoryzacje ponownie i szybko wklej token.

### Blad: Nie mozna polaczyc z Garmin

Sprawdz dane logowania. Jesli uzywasz dwuskładnikowego uwierzytelniania (2FA), moze byc konieczne utworzenie hasla aplikacji.

### Blad SSL/TLS

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

### Logi debugowania

```powershell
uv run withings-sync --config-folder $env:USERPROFILE\.withings-sync --verbose --dump-raw
```

## Struktura plików konfiguracji

```
%USERPROFILE%\.withings-sync\
├── withings_user.json      # Dane sesji Withings
├── .garmin_session          # Sesja Garmin (jesli skonfigurowane)
└── *.oauth                  # Tokeny OAuth
```

## Wsparcie

- Zglos problem: https://github.com/jaroslawhartman/withings-sync/issues
- Dokumentacja: https://github.com/jaroslawhartman/withings-sync

## Licencja

MIT License
