# Smartify IoT MVP Codebase Summary

## Root

- `docker-compose.yml`: backend stack runtime
- `docs/`: implementation and deployment docs
- `scripts/`: local bootstrap

## Backend

- `services/api/`: NestJS API, TypeORM, MQTT bridge, Socket.IO

## Web

- `apps/web/`: React dashboard for auth, device control, reports

## Firmware

- `firmware/esp32-power-node/`: PlatformIO Arduino firmware

## Mobile

- `smartify_flutter/`: Flutter app, originally mock/prototype, now being upgraded to real API/realtime flows
