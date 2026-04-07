# Smartify IoT MVP Code Standards

## General

- Keep files focused and small.
- Prefer clear DTOs and service boundaries over shared mutable state.
- Keep env secrets out of source control.

## API

- Use NestJS modules by business domain.
- Validate incoming DTOs.
- Emit realtime updates only after state persistence succeeds.

## Flutter

- Keep `provider + ChangeNotifier`.
- Move transport code into repositories/services.
- Keep UI optimistic only when rollback is implemented.

## Web

- Use route-level pages and small presentational components.
- Keep API and socket code in dedicated hooks/services.

## Firmware

- Keep secrets in `secrets.h` only.
- Separate GPIO, MQTT, and telemetry concerns into small helpers when practical.
