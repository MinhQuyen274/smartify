# Smartify IoT MVP

Smartify is an end-to-end IoT MVP for a smart power controller built around:

- `smartify_flutter/`: mobile app in Flutter
- `services/api/`: NestJS API with PostgreSQL, MQTT bridge, and Socket.IO
- `apps/web/`: React dashboard
- `firmware/esp32-power-node/`: ESP32 firmware for relay control and usage tracking

### Current Hardware Layout
The smart node uses an **ESP32-S3** to control a relay and track device usage duration. It eliminates the need for expensive PZEM sensors by calculating ON-time on the server.
- **Relay Control**: GPIO 7
- **Physical Switch (Toggle)**: GPIO 40
- **On-Time Tracking**: Automatically calculates how long a device has been active and displays it in premium Flutter/Web dashboards.

## Runtime

Server-side services run with Docker Compose:

- PostgreSQL on `5432`
- Mosquitto MQTT on `1883`
- Mosquitto WebSocket on `9001`
- NestJS API + Socket.IO on `3000`

## Quick Start

1. Copy env templates:
   - `services/api/.env.example` -> `services/api/.env`
   - `apps/web/.env.example` -> `apps/web/.env`
   - `firmware/esp32-power-node/include/secrets.template.h` -> `firmware/esp32-power-node/include/secrets.h`
2. Install workspace deps:
   - `npm install`
3. Start Docker services and seed demo data:
   - `npm run bootstrap:local`
4. Run web locally:
   - `npm run dev:web`
5. Run Flutter from [smartify_flutter/README.md](D:/Frontend_PROJECT_Figma/smartify_flutter/README.md)

## Demo Defaults

- Seeded demo device type: `smart-power-node`
- Seeded demo device ID: `demo-power-node-01`
- Seeded claim code: `KAN-POWER-01`
- Seeded user: created through `/auth/sign-up`

## ESP32 Provisioning Flow

1. Keep firmware and API seed values aligned:
   - `firmware/esp32-power-node/include/secrets.h`
   - `services/api/.env`
2. Set the same values for:
   - `DEVICE_ID` <-> `SEED_DEVICE_ID`
   - `CLAIM_CODE` <-> `SEED_CLAIM_CODE`
3. Rebuild the API stack after changing seed values:
   - `docker compose up -d --build api`
4. Flash the ESP32 firmware.
5. After the ESP32 joins Wi-Fi, it exposes a provisioning page on:
   - `http://<device-ip>/`
6. Open that page on another screen. It renders a real QR code containing:
   - `{"deviceId":"...","claimCode":"..."}`
7. In the mobile app:
   - sign up / sign in
   - scan the QR
   - claim the device
   - control ON/OFF from the lamp screen

## Network Notes

- Preferred demo setup: laptop hosts the hotspot and Docker services.
- Firmware tries the primary configured SSID first, then fallback SSID `kan`.
- Hotspot credentials and server host values belong only in local env or firmware secrets files.

## Repository Docs

- [project-overview-pdr.md](D:/Frontend_PROJECT_Figma/docs/project-overview-pdr.md)
- [system-architecture.md](D:/Frontend_PROJECT_Figma/docs/system-architecture.md)
- [code-standards.md](D:/Frontend_PROJECT_Figma/docs/code-standards.md)
- [codebase-summary.md](D:/Frontend_PROJECT_Figma/docs/codebase-summary.md)
