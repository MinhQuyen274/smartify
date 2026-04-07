import { MigrationInterface, QueryRunner } from 'typeorm';

export class InitialSchema1711939200000 implements MigrationInterface {
  name = 'InitialSchema1711939200000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query('CREATE EXTENSION IF NOT EXISTS "pgcrypto"');
    await queryRunner.query(`
      CREATE TABLE "users" (
        "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
        "email" varchar(255) NOT NULL UNIQUE,
        "password_hash" varchar(255) NOT NULL,
        "created_at" timestamptz NOT NULL DEFAULT now()
      )
    `);
    await queryRunner.query(`
      CREATE TABLE "devices" (
        "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
        "device_id" varchar(120) NOT NULL UNIQUE,
        "type" varchar(60) NOT NULL,
        "name" varchar(120) NOT NULL,
        "relay_on" boolean NOT NULL DEFAULT false,
        "is_online" boolean NOT NULL DEFAULT false,
        "last_seen_at" timestamptz,
        "owner_id" uuid REFERENCES "users"("id") ON DELETE SET NULL,
        "created_at" timestamptz NOT NULL DEFAULT now(),
        "updated_at" timestamptz NOT NULL DEFAULT now()
      )
    `);
    await queryRunner.query(`
      CREATE TABLE "device_claims" (
        "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
        "device_id" uuid NOT NULL UNIQUE REFERENCES "devices"("id") ON DELETE CASCADE,
        "claim_code" varchar(120) NOT NULL UNIQUE,
        "claimed_by_user_id" uuid REFERENCES "users"("id") ON DELETE SET NULL,
        "claimed_at" timestamptz,
        "created_at" timestamptz NOT NULL DEFAULT now()
      )
    `);
    await queryRunner.query(`
      CREATE TABLE "device_commands" (
        "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
        "device_id" uuid NOT NULL REFERENCES "devices"("id") ON DELETE CASCADE,
        "request_id" varchar(120) NOT NULL UNIQUE,
        "desired_relay_on" boolean NOT NULL,
        "source" varchar(60) NOT NULL,
        "issued_by_user_id" uuid REFERENCES "users"("id") ON DELETE SET NULL,
        "acked" boolean NOT NULL DEFAULT false,
        "ack_success" boolean,
        "created_at" timestamptz NOT NULL DEFAULT now(),
        "acked_at" timestamptz
      )
    `);
    await queryRunner.query(`
      CREATE TABLE "device_telemetry" (
        "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
        "device_id" uuid NOT NULL REFERENCES "devices"("id") ON DELETE CASCADE,
        "recorded_at" timestamptz NOT NULL,
        "voltage" double precision NOT NULL,
        "current" double precision NOT NULL,
        "active_power" double precision NOT NULL,
        "energy_kwh" double precision NOT NULL,
        "frequency" double precision NOT NULL,
        "power_factor" double precision NOT NULL,
        "relay_on" boolean NOT NULL,
        "source" varchar(60) NOT NULL DEFAULT 'telemetry'
      )
    `);
    await queryRunner.query(
      'CREATE INDEX "idx_telemetry_device_time" ON "device_telemetry" ("device_id", "recorded_at" DESC)',
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query('DROP INDEX IF EXISTS "idx_telemetry_device_time"');
    await queryRunner.query('DROP TABLE IF EXISTS "device_telemetry"');
    await queryRunner.query('DROP TABLE IF EXISTS "device_commands"');
    await queryRunner.query('DROP TABLE IF EXISTS "device_claims"');
    await queryRunner.query('DROP TABLE IF EXISTS "devices"');
    await queryRunner.query('DROP TABLE IF EXISTS "users"');
  }
}
