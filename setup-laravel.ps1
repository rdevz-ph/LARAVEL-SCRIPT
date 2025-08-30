# setup-laravel.ps1
$ErrorActionPreference = 'Stop'

function Require-Cmd($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    throw "$name not found in PATH."
  }
}

Write-Host ""
Write-Host "Laravel One-Click Setup (PowerShell)" -ForegroundColor Cyan

# Sanity: must be Laravel root
if (-not (Test-Path -Path ".\artisan")) {
  throw "artisan not found. Run this in your Laravel project root."
}

# Tools
Require-Cmd php
Require-Cmd composer
Require-Cmd npm

# composer install (idempotent)
if (Test-Path -Path ".\vendor\autoload.php") {
  Write-Host "[OK] composer already installed."
} else {
  Write-Host "[..] composer install"
  composer install
  Write-Host "[OK] composer install done."
}

# npm install (idempotent)
if (Test-Path -Path ".\node_modules") {
  Write-Host "[OK] npm packages already installed."
} else {
  Write-Host "[..] npm install"
  npm install
  Write-Host "[OK] npm install done."
}

# .env
if (Test-Path ".\.env") {
  Write-Host "[OK] .env exists."
} else {
  if (Test-Path ".\.env.example") {
    Write-Host "[..] copying .env.example -> .env"
    Copy-Item ".\.env.example" ".\.env" -Force
    Write-Host "[OK] .env created."
  } else {
    throw ".env and .env.example are missing. Provide one and re-run."
  }
}

# APP_KEY (only if missing/empty)
$envLines = Get-Content -LiteralPath ".\.env"
$appKeyLine = $envLines | Where-Object { $_ -match '^APP_KEY=' } | Select-Object -First 1
if (-not $appKeyLine -or $appKeyLine -replace '^APP_KEY=', '' -eq '') {
  Write-Host "[..] php artisan key:generate"
  php artisan key:generate
  Write-Host "[OK] APP_KEY generated."
} else {
  Write-Host "[OK] APP_KEY already set."
}

# storage:link (skip if exists)
if (Test-Path ".\public\storage") {
  Write-Host "[OK] storage link exists."
} else {
  Write-Host "[..] php artisan storage:link"
  try {
    php artisan storage:link
    Write-Host "[OK] storage linked."
  } catch {
    Write-Host "[!] storage:link failed (try running as Administrator). Continuing..."
  }
}

# migrate + seed
Write-Host "[..] php artisan migrate --force --no-interaction"
php artisan migrate --force --no-interaction
Write-Host "[OK] migrations up to date."

Write-Host "[..] php artisan db:seed --force --no-interaction"
php artisan db:seed --force --no-interaction
Write-Host "[OK] seeding complete."

# optimize
Write-Host "[..] php artisan optimize"
php artisan optimize
Write-Host "[OK] optimized."

# start initial build (new windows)
Write-Host "[..] starting Vite (npm run build) in a new window..."
Start-Process -FilePath "cmd.exe" -ArgumentList '/k','npm run build' -WorkingDirectory (Get-Location)

# start dev servers (new windows)
Write-Host "[..] starting Vite (npm run dev) in a new window..."
Start-Process -FilePath "cmd.exe" -ArgumentList '/k','npm run dev' -WorkingDirectory (Get-Location)

Write-Host "[..] starting Laravel server in a new window..."
Start-Process -FilePath "cmd.exe" -ArgumentList '/k','php artisan serve' -WorkingDirectory (Get-Location)

# open browser
Start-Sleep -Seconds 2
Start-Process "http://127.0.0.1:8000"

Write-Host ""
Write-Host "[OK] All done." -ForegroundColor Green
Read-Host "Press Enter to close"
