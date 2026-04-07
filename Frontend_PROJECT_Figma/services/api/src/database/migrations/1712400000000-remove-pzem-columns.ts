import { MigrationInterface, QueryRunner } from 'typeorm';

export class RemovePzemColumns1712400000000 implements MigrationInterface {
  name = 'RemovePzemColumns1712400000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "device_telemetry" DROP COLUMN "voltage"`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" DROP COLUMN "current"`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" DROP COLUMN "active_power"`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" DROP COLUMN "energy_kwh"`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" DROP COLUMN "frequency"`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" DROP COLUMN "power_factor"`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "device_telemetry" ADD "voltage" double precision NOT NULL DEFAULT 0`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" ADD "current" double precision NOT NULL DEFAULT 0`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" ADD "active_power" double precision NOT NULL DEFAULT 0`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" ADD "energy_kwh" double precision NOT NULL DEFAULT 0`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" ADD "frequency" double precision NOT NULL DEFAULT 0`);
    await queryRunner.query(`ALTER TABLE "device_telemetry" ADD "power_factor" double precision NOT NULL DEFAULT 0`);
  }
}
