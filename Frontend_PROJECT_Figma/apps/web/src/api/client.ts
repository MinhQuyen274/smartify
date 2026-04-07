import {
  AuthResponse,
  DeviceDetail,
  DeviceSummary,
  ReportSummary,
  TelemetryPoint,
} from '../types';

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:3000';

async function request<T>(
  path: string,
  options: RequestInit = {},
  token?: string,
): Promise<T> {
  const response = await fetch(`${apiBaseUrl}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(options.headers ?? {}),
    },
  });

  if (!response.ok) {
    const errorBody = await response.text();
    throw new Error(errorBody || `Request failed: ${response.status}`);
  }

  return response.json() as Promise<T>;
}

export const apiClient = {
  signUp(email: string, password: string) {
    return request<AuthResponse>('/auth/sign-up', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
  },
  signIn(email: string, password: string) {
    return request<AuthResponse>('/auth/sign-in', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
  },
  getDevices(token: string) {
    return request<DeviceSummary[]>('/devices', {}, token);
  },
  getDevice(deviceId: string, token: string) {
    return request<DeviceDetail>(`/devices/${deviceId}`, {}, token);
  },
  getHistory(deviceId: string, token: string) {
    return request<TelemetryPoint[]>(`/devices/${deviceId}/history?interval=minute`, {}, token);
  },
  claimDevice(deviceId: string, claimCode: string, token: string, name?: string) {
    return request<DeviceSummary>(
      '/devices/claim',
      {
        method: 'POST',
        body: JSON.stringify({ deviceId, claimCode, name }),
      },
      token,
    );
  },
  sendPowerCommand(deviceId: string, relayOn: boolean, token: string) {
    return request<{ requestId: string }>(
      `/devices/${deviceId}/commands/power`,
      {
        method: 'POST',
        body: JSON.stringify({ relayOn }),
      },
      token,
    );
  },
  getReportSummary(token: string) {
    return request<ReportSummary>('/reports/summary', {}, token);
  },
};

export const realtimeUrl = import.meta.env.VITE_SOCKET_URL ?? apiBaseUrl;
