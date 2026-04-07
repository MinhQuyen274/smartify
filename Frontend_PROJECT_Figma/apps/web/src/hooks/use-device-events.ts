import { useEffect } from 'react';
import { io } from 'socket.io-client';
import { realtimeUrl } from '../api/client';

interface UseDeviceEventsOptions {
  token: string | null;
  deviceId?: string;
  onEvent: () => void;
}

export function useDeviceEvents({ token, deviceId, onEvent }: UseDeviceEventsOptions) {
  useEffect(() => {
    if (!token) return;

    const socket = io(realtimeUrl, {
      auth: { token },
      transports: ['websocket'],
    });

    socket.on('connect', () => {
      if (deviceId) {
        socket.emit('subscribe.device', deviceId);
      }
    });

    socket.on('device.updated', onEvent);
    socket.on('telemetry.received', onEvent);
    socket.on('command.acknowledged', onEvent);

    return () => {
      socket.disconnect();
    };
  }, [deviceId, onEvent, token]);
}
