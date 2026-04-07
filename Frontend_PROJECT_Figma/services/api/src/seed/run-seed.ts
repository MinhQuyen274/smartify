import 'reflect-metadata';
import { AppDataSource } from '../database/typeorm.datasource';
import { DeviceEntity } from '../devices/device.entity';
import { DeviceClaimEntity } from '../claims/device-claim.entity';

async function seed() {
  await AppDataSource.initialize();

  const deviceRepository = AppDataSource.getRepository(DeviceEntity);
  const claimRepository = AppDataSource.getRepository(DeviceClaimEntity);
  const seedDeviceId = process.env.SEED_DEVICE_ID ?? 'demo-power-node-01';
  const seedClaimCode = process.env.SEED_CLAIM_CODE ?? 'KAN-POWER-01';
  const seedDeviceName = process.env.SEED_DEVICE_NAME ?? 'Smart Power Node';
  const seedDeviceType = process.env.SEED_DEVICE_TYPE ?? 'smart-power-node';

  let device = await deviceRepository.findOne({ where: { deviceId: seedDeviceId } });
  if (!device) {
    device = deviceRepository.create({
      deviceId: seedDeviceId,
      type: seedDeviceType,
      name: seedDeviceName,
      relayOn: false,
      isOnline: false,
    });
    device = await deviceRepository.save(device);
  } else {
    device.type = seedDeviceType;
    device.name = seedDeviceName;
    device = await deviceRepository.save(device);
  }

  const claim = await claimRepository.findOne({
    where: { device: { id: device.id } },
    relations: ['device'],
  });

  if (!claim) {
    await claimRepository.save(
      claimRepository.create({
        device,
        claimCode: seedClaimCode,
      }),
    );
  }

  await AppDataSource.destroy();
  console.log(`Seed complete for ${seedDeviceId}`);
}

seed().catch((error) => {
  console.error('Seed failure', error);
  process.exit(1);
});
