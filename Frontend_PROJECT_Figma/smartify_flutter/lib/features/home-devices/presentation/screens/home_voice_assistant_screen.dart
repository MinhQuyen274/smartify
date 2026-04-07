import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';

class HomeVoiceAssistantScreen extends StatefulWidget {
  const HomeVoiceAssistantScreen({super.key});

  @override
  State<HomeVoiceAssistantScreen> createState() =>
      _HomeVoiceAssistantScreenState();
}

enum _VoiceAssistantPhase { listening, connecting, connected }

class _HomeVoiceAssistantScreenState extends State<HomeVoiceAssistantScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  _VoiceAssistantPhase _phase = _VoiceAssistantPhase.listening;
  String _commandText = 'Turn on all the lights in the entire room';
  String _statusText = 'Preparing voice assistant...';
  String _scopeText = 'Selected room';
  int _connectedDevices = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runMockSequence());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runMockSequence() async {
    final store = context.read<HomeDevicesStore>();
    final selectedRoom = store.selectedRoom;
    final targetAllRooms = selectedRoom == 'All Rooms';
    final targetLights = store.allDevices.where((device) {
      final roomMatches = targetAllRooms || device.room == selectedRoom;
      return device.type == DeviceType.light && roomMatches;
    }).toList(growable: false);

    if (!mounted) return;
    setState(() {
      _commandText = targetAllRooms
          ? 'Turn on all the lights in the entire home'
          : 'Turn on all the lights in the ${selectedRoom.toLowerCase()}';
      _scopeText = targetAllRooms ? 'Entire home' : selectedRoom;
      _statusText = 'Listening for your command...';
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _phase = _VoiceAssistantPhase.connecting;
      _statusText = targetLights.isEmpty
          ? 'Searching for compatible lights...'
          : 'Connecting to ${targetLights.length} light device${targetLights.length == 1 ? '' : 's'}...';
    });

    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    if (targetLights.isNotEmpty) {
      store.setDevicesWhere((device) {
        final roomMatches = targetAllRooms || device.room == selectedRoom;
        return device.type == DeviceType.light && roomMatches;
      }, true);
    }

    if (!mounted) return;
    setState(() {
      _phase = _VoiceAssistantPhase.connected;
      _connectedDevices = targetLights.length;
      _statusText = targetLights.isEmpty
          ? 'No lights available in $_scopeText.'
          : 'Connected to $_connectedDevices light device${_connectedDevices == 1 ? '' : 's'} in $_scopeText.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final headline = switch (_phase) {
      _VoiceAssistantPhase.listening => 'We are listening...',
      _VoiceAssistantPhase.connecting => 'Connecting devices...',
      _VoiceAssistantPhase.connected => 'Command completed',
    };
    final supporting = switch (_phase) {
      _VoiceAssistantPhase.listening => 'What do you want to do?',
      _VoiceAssistantPhase.connecting =>
        'Please wait while we connect your devices',
      _VoiceAssistantPhase.connected => _statusText,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 820;
            final waveHeight = compact ? 170.0 : 230.0;
            final orbSize = compact ? 108.0 : 138.0;
            final topSpacing = compact ? 12.0 : 18.0;
            final commandSpacing = compact ? 16.0 : 26.0;
            final orbSpacing = compact ? 8.0 : 18.0;

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 30),
                    ),
                  ),
                  SizedBox(height: topSpacing),
                  Text(
                    headline,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF626673),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      supporting,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: _phase == _VoiceAssistantPhase.connected
                            ? LightColorTokens.primary
                            : const Color(0xFF2D3037),
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(height: commandSpacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      '"$_commandText"',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                    ),
                  ),
                  if (_phase == _VoiceAssistantPhase.connecting) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F6FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusText,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: LightColorTokens.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    height: waveHeight,
                    width: double.infinity,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: _VoiceWavePainter(progress: _controller.value),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: orbSpacing),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final pulse =
                          0.96 + (math.sin(_controller.value * 2 * math.pi) * 0.05);
                      return Transform.scale(scale: pulse, child: child);
                    },
                    child: _VoiceOrb(size: orbSize),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VoiceOrb extends StatelessWidget {
  const _VoiceOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Color(0xFFBEF6FF),
            Color(0xFF5B7BFF),
            Color(0xFF192C8F),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x554A68F6),
            blurRadius: 26,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.74,
            height: size * 0.74,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  Color(0x00FFFFFF),
                  Color(0xCCFFFFFF),
                  Color(0x40D7A5FF),
                  Color(0x00805BFF),
                ],
              ),
            ),
          ),
          Transform.rotate(
            angle: -0.55,
            child: Container(
              width: size * 0.67,
              height: size * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [
                    Color(0x00FFFFFF),
                    Color(0xD8FFFFFF),
                    Color(0x889AF6FF),
                    Color(0x004A68F6),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceWavePainter extends CustomPainter {
  const _VoiceWavePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final guidePaint = Paint()
      ..color = const Color(0x154A68F6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), guidePaint);

    const layers = [
      _WaveLayer(Color(0xFFFFA126), 22, 1.8, 0.2),
      _WaveLayer(Color(0xFF8C2EFF), 28, 2.2, 1.1),
      _WaveLayer(Color(0xFF4A68F6), 74, 1.3, 2.0),
      _WaveLayer(Color(0xFF22B7FF), 38, 2.8, 3.1),
      _WaveLayer(Color(0xFF92C853), 36, 2.0, 4.0),
    ];

    for (final layer in layers) {
      final path = Path()..moveTo(0, centerY);
      for (double x = 0; x <= size.width; x += 4) {
        final t = x / size.width;
        final envelope = math.pow(math.sin(math.pi * t), 2).toDouble();
        final wave = math.sin(
          (t * layer.frequency * math.pi * 2) +
              (progress * math.pi * 2) +
              layer.phase,
        );
        final y = centerY - (layer.amplitude * envelope * wave);
        path.lineTo(x, y);
      }
      for (double x = size.width; x >= 0; x -= 4) {
        final t = x / size.width;
        final envelope = math.pow(math.sin(math.pi * t), 2).toDouble();
        final wave = math.sin(
          (t * layer.frequency * math.pi * 2) +
              (progress * math.pi * 2) +
              layer.phase,
        );
        final y = centerY + (layer.amplitude * envelope * wave);
        path.lineTo(x, y);
      }
      path.close();

      final paint = Paint()
        ..color = layer.color.withValues(alpha: 0.92)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _VoiceWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _WaveLayer {
  const _WaveLayer(this.color, this.amplitude, this.frequency, this.phase);

  final Color color;
  final double amplitude;
  final double frequency;
  final double phase;
}
