# Smartify IoT MVP System Architecture

## Components

- ESP32 firmware publishes MQTT telemetry and state, receives MQTT commands.
- NestJS API bridges MQTT to PostgreSQL and Socket.IO.
- Flutter and React clients use REST + Socket.IO only.
- PostgreSQL stores users, devices, claims, commands, and telemetry.

## Core Data Flow

1. Device boots, connects to Wi-Fi, then MQTT.
2. Device publishes state and telemetry.
3. API stores telemetry and broadcasts live updates.
4. User sends power command from mobile or web.
5. API saves command, publishes MQTT command, receives ack, updates clients.

## Network Strategy

- Preferred demo topology: laptop hosts Docker services and hotspot.
- Firmware uses prioritized SSIDs from local secrets.
- `SERVER_HOST` points to the laptop-accessible API and MQTT host.
