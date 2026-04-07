import { AppDataSource } from './typeorm.datasource';

async function runMigrations() {
  await AppDataSource.initialize();
  await AppDataSource.runMigrations();
  await AppDataSource.destroy();
  console.log('Database migrations completed.');
}

runMigrations().catch((error) => {
  console.error('Migration failure', error);
  process.exit(1);
});
