import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { JwtService } from '@nestjs/jwt';
import { Server, Socket } from 'socket.io';
import { RequestUser } from '../shared/types/request-user';

@WebSocketGateway({
  cors: {
    origin: process.env.CORS_ORIGIN?.split(',') ?? true,
    credentials: true,
  },
})
export class RealtimeGateway implements OnGatewayConnection {
  @WebSocketServer()
  server!: Server;

  constructor(private readonly jwtService: JwtService) {}

  handleConnection(client: Socket) {
    const rawToken =
      client.handshake.auth?.token ??
      client.handshake.headers.authorization?.replace('Bearer ', '');

    if (!rawToken) {
      client.disconnect();
      return;
    }

    try {
      const user = this.jwtService.verify<RequestUser>(rawToken);
      client.data.user = user;
      client.join(this.userRoom(user.sub));
    } catch {
      client.disconnect();
    }
  }

  @SubscribeMessage('subscribe.device')
  subscribeDevice(@ConnectedSocket() client: Socket, @MessageBody() deviceId: string) {
    client.join(this.deviceRoom(deviceId));
    return { ok: true };
  }

  emitDeviceListUpdated(userId: string, payload: unknown) {
    this.server.to(this.userRoom(userId)).emit('device.updated', payload);
  }

  emitUserEvent(userId: string, event: string, payload: unknown) {
    this.server.to(this.userRoom(userId)).emit(event, payload);
  }

  emitTelemetry(deviceId: string, payload: unknown) {
    this.server.to(this.deviceRoom(deviceId)).emit('telemetry.received', payload);
  }

  emitCommandAck(deviceId: string, payload: unknown) {
    this.server.to(this.deviceRoom(deviceId)).emit('command.acknowledged', payload);
  }

  private userRoom(userId: string) {
    return `user:${userId}:devices`;
  }

  private deviceRoom(deviceId: string) {
    return `device:${deviceId}`;
  }
}
