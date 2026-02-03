#Requires -Version 5.1
<#
.SYNOPSIS
    Konfiguracja withings-sync na Windows
.DESCRIPTION
    Instaluje uv, Python 3.12, zaleznosci projektu i przeprowadza autoryzacje OAuth.
#>

param(
    [string]$ConfigFolder = "$env:USERPROFILE\.withings-sync"
)

$ErrorActionPreference = "Stop"

function Write-Step { param($msg) Write-Host "`n[*] $msg" -ForegroundColor Cyan }
function Write-OK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Err { param($msg) Write-Host "[BLAD] $msg" -ForegroundColor Red }

Write-Host @"
========================================
  withings-sync - Konfiguracja Windows
========================================
"@ -ForegroundColor Magenta

# 1. Install uv
Write-Step "Instalacja uv (menedzer pakietow Python)..."
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
}
Write-OK "uv zainstalowany"

# 2. Install Python 3.12
Write-Step "Instalacja Python 3.12.11..."
uv python install 3.12.11
Write-OK "Python 3.12.11 zainstalowany"

# 3. Create config folder
Write-Step "Tworzenie folderu konfiguracji: $ConfigFolder"
New-Item -ItemType Directory -Force -Path $ConfigFolder | Out-Null
Write-OK "Folder utworzony"

# 4. Sync project
Write-Step "Instalacja zaleznosci projektu..."
uv sync --frozen
Write-OK "Zaleznosci zainstalowane"

# 5. First run instructions
Write-Host @"

========================================
  AUTORYZACJA WITHINGS
========================================
Za chwile uruchomie pierwsze polaczenie.

1. Otworzy sie link - skopiuj go do przegladarki
2. Zaloguj sie do konta Withings
3. Skopiuj TOKEN i wklej tutaj
4. Masz 30 sekund na wklejenie!

Nacisnij ENTER aby kontynuowac...
"@ -ForegroundColor Yellow

Read-Host

uv run withings-sync --config-folder $ConfigFolder

Write-OK @"

Konfiguracja zakonczona!

UZYCIE:
  uv run withings-sync --config-folder $ConfigFolder

AUTOMATYZACJA (Harmonogram Zadan):
  Zobacz README_PL.md sekcja 'Harmonogram Zadan'
"@
