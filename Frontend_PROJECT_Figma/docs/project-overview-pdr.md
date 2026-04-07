# Smartify IoT MVP Project Overview

## Goal

Deliver an end-to-end MVP for a smart power controller that supports:

- local hard-switch ON/OFF
- remote ON/OFF from mobile and web
- live PZEM telemetry
- claim by QR/manual code
- persisted telemetry and reports in PostgreSQL

## Current Scope

- single-user auth
- one device type: `smart-power-node`
- Dockerized backend runtime
- Flutter mobile app
- React web dashboard
- ESP32 firmware

## Acceptance Criteria

- Device can be claimed from mobile and web.
- Relay state stays synchronized between firmware, backend, web, and mobile.
- Physical switch updates dashboards in near real time.
- Telemetry is stored and shown in reports.
- Local demo stack starts with documented commands only.
