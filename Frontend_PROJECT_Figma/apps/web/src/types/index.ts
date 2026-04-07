export interface AuthUser {
  id: string;
  email: string;
  createdAt: string;
}

export interface AuthResponse {
  accessToken: string;
  user: AuthUser;
}

export interface DeviceSummary {
  deviceId: string;
  type: string;
  name: string;
  relayOn: boolean;
  isOnline: boolean;
  lastSeenAt: string | null;
  latestTelemetry?: TelemetryPoint | null;
}

export interface TelemetryPoint {
  recordedAt?: string;
  bucket?: string;
  voltage: number;
  current: number;
  activePower: number;
  energyKwh: number;
  frequency: number;
  powerFactor: number;
  relayOn: boolean;
}

export interface DeviceDetail extends DeviceSummary {
  latestTelemetry: TelemetryPoint | null;
}

export interface ReportDeviceSummary {
  deviceId: string;
  name: string;
  consumedEnergyKwh: number | string | null;
  averagePower: number | string | null;
  lastTelemetryAt: string | null;
}

export interface ReportSummary {
  totalEnergyKwh: number;
  deviceCount: number;
  devices: ReportDeviceSummary[];
}
