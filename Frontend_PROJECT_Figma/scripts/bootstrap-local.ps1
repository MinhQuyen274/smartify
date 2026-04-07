$ErrorActionPreference = "Stop"

Set-Location $PSScriptRoot\..

if (-not (Test-Path "services/api/.env")) {
  Copy-Item "services/api/.env.example" "services/api/.env"
}

if (-not (Test-Path "apps/web/.env")) {
  Copy-Item "apps/web/.env.example" "apps/web/.env"
}

docker compose up -d --build postgres mosquitto api
npm install
npm run migration:run --workspace services/api
npm run seed --workspace services/api

Write-Host "Smartify local stack is ready."
