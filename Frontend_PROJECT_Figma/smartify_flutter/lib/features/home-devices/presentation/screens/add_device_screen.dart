import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/models/home_devices_models.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/scan_qr_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/manual_setup_code_form_widget.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/mode_tab_bar.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/processing_setup_code_widget.dart';
import 'package:smartify_flutter/features/home-devices/state/home_devices_store.dart';
import 'package:smartify_flutter/shared/widgets/pressable_scale.dart';

enum _AddDeviceStage { browsing, detected, connecting, connected }

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen>
    with TickerProviderStateMixin {
  static const _demoProvisioningCode = 'demo-power-node-01|KAN-POWER-01';

  late final AnimationController _scanPulseCtrl;
  late final AnimationController _connectProgressCtrl;
  _AddDeviceStage _stage = _AddDeviceStage.browsing;
  _DiscoverableDevice? _selectedDevice;
  String? _provisioningCode;
  bool _manualProcessing = false;
  bool _handledRouteArgs = false;

  @override
  void initState() {
    super.initState();
    _scanPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _connectProgressCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            if (mounted) setState(() {});
          });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final store = context.read<HomeDevicesStore>();
      if (store.addDeviceTab == 0) {
        store.startScan();
      }
    });
  }

  @override
  void dispose() {
    _scanPulseCtrl.dispose();
    _connectProgressCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledRouteArgs) return;
    _handledRouteArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['scan'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final store = context.read<HomeDevicesStore>();
        if (!mounted) return;
        final device = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScanQrScreen()),
        );
        if (device is String && mounted) {
          final scannedDevice = _DiscoverableDevice(
            id: _deviceIdFromProvisioningCode(device) ?? 'scan-lamp',
            name: 'Smart Power Node',
            type: DeviceType.light,
            connectivity: 'Wi-Fi',
            imagePath: 'assets/bong_den.jpg',
            category: 'Lighting',
          );
          _provisioningCode = device;
          _onSelectDevice(store, scannedDevice);
          _startConnection(store);
        }
      });
    }
  }

  Future<void> _startConnection(HomeDevicesStore store) async {
    final device = _selectedDevice;
    if (device == null) return;

    store.setPendingDevice(device.toSmartDevice(store.selectedRoom));
    setState(() {
      _stage = _AddDeviceStage.connecting;
    });

    final animationFuture = _connectProgressCtrl.forward(from: 0);
    final claimed = await store.connectQRDevice(
      _provisioningCode ?? _demoProvisioningCode,
      device.name,
    );
    if (!mounted) return;
    if (!claimed || !store.isConnected) {
      _connectProgressCtrl.stop();
      _connectProgressCtrl.reset();
      setState(() {
        _stage = _AddDeviceStage.detected;
      });
      _showClaimStatus(store.errorMessage ?? 'Could not confirm this device.');
      return;
    }

    await animationFuture;
    if (!mounted) return;
    setState(() {
      _stage = _AddDeviceStage.connected;
    });
    _showClaimStatus('${device.name} connected successfully.');
  }

  void _onSelectDevice(HomeDevicesStore store, _DiscoverableDevice device) {
    store.setPendingDevice(device.toSmartDevice(store.selectedRoom));
    setState(() {
      _selectedDevice = device;
      _provisioningCode ??= _demoProvisioningCode;
      _stage = _AddDeviceStage.detected;
    });
  }

  void _resetToDiscovery(HomeDevicesStore store) {
    store.resetAddDeviceFlow();
    store.startScan();
    setState(() {
      _stage = _AddDeviceStage.browsing;
      _selectedDevice = null;
      _provisioningCode = null;
    });
  }

  void _showClaimStatus(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  String? _controlRouteFor(DeviceType type) {
    if (type == DeviceType.light) return AppRoutes.homeDevicesControlLamp;
    if (type == DeviceType.electrical) return AppRoutes.homeDevicesControlAc;
    if (type == DeviceType.camera) return AppRoutes.homeDevicesControlCamera;
    if (type == DeviceType.speaker) return AppRoutes.homeDevicesControlSpeaker;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<HomeDevicesStore>();
    final progress = (_connectProgressCtrl.value * 100).round().clamp(0, 100);

    if (_stage == _AddDeviceStage.connected) {
      final device = _selectedDevice;
      if (device == null) return const SizedBox.shrink();
      return _ConnectedView(
        device: device,
        onHomepage: () {
          store.completeDeviceSetup();
          Navigator.pop(context);
        },
        onControlDevice: () {
          final targetDeviceId = store.lastClaimedDeviceId ?? device.id;
          store.completeDeviceSetup();
          final route = _controlRouteFor(device.type);
          if (route == null) {
            Navigator.pop(context);
            return;
          }
          Navigator.pushReplacementNamed(
            context,
            route,
            arguments: targetDeviceId,
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: LightColorTokens.background,
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Add Device'),
        ),
        centerTitle: true,
        backgroundColor: LightColorTokens.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (_stage == _AddDeviceStage.detected ||
                _stage == _AddDeviceStage.connecting) {
              _resetToDiscovery(store);
              return;
            }
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final store = context.read<HomeDevicesStore>();
              final device = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanQrScreen()),
              );
              if (device is String && mounted) {
                final scannedDevice = _DiscoverableDevice(
                  id: _deviceIdFromProvisioningCode(device) ?? 'scan-lamp',
                  name: 'Smart Power Node',
                  type: DeviceType.light,
                  connectivity: 'Wi-Fi',
                  imagePath: 'assets/bong_den.jpg',
                  category: 'Lighting',
                );
                _provisioningCode = device;
                _onSelectDevice(store, scannedDevice);
                _startConnection(store);
              }
            },
            icon: Icon(
              _stage == _AddDeviceStage.browsing
                  ? Icons.qr_code_scanner_rounded
                  : Icons.more_vert_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          if (_stage == _AddDeviceStage.browsing)
            _BrowseDevicesView(
              store: store,
              scanAnimation: _scanPulseCtrl,
              onSelectTab: (index) {
                store.setAddDeviceTab(index);
                if (index == 0) {
                  store.startScan();
                }
              },
              onSelectDevice: (device) => _onSelectDevice(store, device),
              onConnectAll: () =>
                  _onSelectDevice(store, _discoverableDevices.first),
              onManualSubmit: (code) async {
                final rootNav = Navigator.of(context, rootNavigator: true);
                final device = _DiscoverableDevice(
                  id: _deviceIdFromProvisioningCode(code) ?? 'manual-lamp',
                  name: 'Smart Power Node',
                  type: DeviceType.light,
                  connectivity: 'Wi-Fi',
                  imagePath: 'assets/bong_den.jpg',
                  category: 'Lighting',
                );
                store.setPendingDevice(
                  device.toSmartDevice(store.selectedRoom),
                );
                setState(() => _manualProcessing = true);
                showProcessingSetupCode(context);
                final claimed = await store.processManualSetupCode(code);
                if (!mounted) return;
                if (rootNav.canPop()) rootNav.pop();
                if (!claimed || !store.isConnected) {
                  setState(() => _manualProcessing = false);
                  _showClaimStatus(
                    store.errorMessage ?? 'Could not confirm this device.',
                  );
                  return;
                }
                setState(() {
                  _manualProcessing = false;
                  _selectedDevice = device;
                  _stage = _AddDeviceStage.connected;
                });
                _showClaimStatus('${device.name} connected successfully.');
              },
            )
          else if (_stage == _AddDeviceStage.detected)
            _DetectedDeviceView(
              device: _selectedDevice!,
              onConnect: () => _startConnection(store),
            )
          else
            _ConnectingDeviceView(device: _selectedDevice!, progress: progress),
          if (_manualProcessing)
            const ModalBarrier(dismissible: false, color: Colors.black12),
        ],
      ),
    );
  }
}

String? _deviceIdFromProvisioningCode(String rawCode) {
  try {
    final decoded = jsonDecode(rawCode);
    if (decoded is Map<String, dynamic>) {
      return decoded['deviceId'] as String?;
    }
  } catch (_) {}

  final parts = rawCode.trim().split('|');
  if (parts.length == 2) {
    return parts.first;
  }
  return null;
}

class _BrowseDevicesView extends StatelessWidget {
  const _BrowseDevicesView({
    required this.store,
    required this.scanAnimation,
    required this.onSelectTab,
    required this.onSelectDevice,
    required this.onConnectAll,
    required this.onManualSubmit,
  });

  final HomeDevicesStore store;
  final Animation<double> scanAnimation;
  final ValueChanged<int> onSelectTab;
  final ValueChanged<_DiscoverableDevice> onSelectDevice;
  final VoidCallback onConnectAll;
  final ValueChanged<String> onManualSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ModeTabBar(
          labels: const ['Nearby Devices', 'Add Manual'],
          selectedIndex: store.addDeviceTab,
          onSelected: onSelectTab,
          backgroundColor: LightColorTokens.background,
          activeColor: LightColorTokens.primary,
        ),
        const SizedBox(height: 8),
        if (store.addDeviceTab == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ManualSetupCodeFormWidget(
              onSubmit: onManualSubmit,
              onCancel: () => Navigator.pop(context),
            ),
          )
        else
          Expanded(
            child: _NearbyDiscoveryView(
              animation: scanAnimation,
              isSearching: store.isScanning,
              devices: _discoverableDevices.take(5).toList(growable: false),
              onSelectDevice: onSelectDevice,
              onConnectAll: onConnectAll,
            ),
          ),
      ],
    );
  }
}

class _NearbyDiscoveryView extends StatelessWidget {
  const _NearbyDiscoveryView({
    required this.animation,
    required this.isSearching,
    required this.devices,
    required this.onSelectDevice,
    required this.onConnectAll,
  });

  final Animation<double> animation;
  final bool isSearching;
  final List<_DiscoverableDevice> devices;
  final ValueChanged<_DiscoverableDevice> onSelectDevice;
  final VoidCallback onConnectAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Looking for nearby devices...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF23252D),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const _ConnectionHintPill(),
          const SizedBox(height: 26),
          Expanded(
            child: Center(
              child: _NearbyDiscoveryRadar(
                animation: animation,
                showDevices: !isSearching,
                devices: devices,
                onSelectDevice: onSelectDevice,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: FilledButton(
              onPressed: onConnectAll,
              style: FilledButton.styleFrom(
                backgroundColor: LightColorTokens.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(29),
                ),
              ),
              child: const Text(
                'Connect to All Devices',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Can\'t find your devices?',
            style: TextStyle(fontSize: 13, color: Color(0xFF585858)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Learn more',
            style: TextStyle(fontSize: 13, color: LightColorTokens.primary),
          ),
        ],
      ),
    );
  }
}

class _NearbyDiscoveryRadar extends StatelessWidget {
  const _NearbyDiscoveryRadar({
    required this.animation,
    required this.showDevices,
    required this.devices,
    required this.onSelectDevice,
  });

  final Animation<double> animation;
  final bool showDevices;
  final List<_DiscoverableDevice> devices;
  final ValueChanged<_DiscoverableDevice> onSelectDevice;

  static const List<Alignment> _positions = [
    Alignment(-0.56, -0.58),
    Alignment(0.6, -0.38),
    Alignment(-0.78, 0.12),
    Alignment(0.74, 0.3),
    Alignment(0.0, 0.7),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 328.0);
        return SizedBox.square(
          dimension: size,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size.square(size),
                    painter: _NearbyRadarPainter(pulse: animation.value),
                  ),
                  _RadarAvatar(size: size * 0.24),
                  for (var index = 0; index < devices.length; index++)
                    Positioned.fill(
                      child: IgnorePointer(
                        ignoring: !showDevices,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOut,
                          opacity: showDevices ? 1 : 0,
                          child: Align(
                            alignment: _positions[index],
                            child: _NearbyDeviceNode(
                              device: devices[index],
                              size: _nodeSizeFor(devices[index]),
                              onTap: () => onSelectDevice(devices[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  double _nodeSizeFor(_DiscoverableDevice device) {
    switch (device.type) {
      case DeviceType.camera:
        return 76;
      case DeviceType.speaker:
        return 72;
      case DeviceType.electrical:
        return 84;
      case DeviceType.light:
        return 68;
    }
  }
}

class _NearbyRadarPainter extends CustomPainter {
  _NearbyRadarPainter({required this.pulse});

  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.width / 2 - 10;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..color = LightColorTokens.primary.withValues(alpha: 0.18);
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = LightColorTokens.primary.withValues(
        alpha: 0.12 + (0.18 * pulse),
      );

    for (var step = 1; step <= 3; step++) {
      canvas.drawCircle(center, maxRadius * (step / 3), ringPaint);
    }
    canvas.drawCircle(center, maxRadius * (0.72 + (0.2 * pulse)), pulsePaint);
  }

  @override
  bool shouldRepaint(covariant _NearbyRadarPainter oldDelegate) {
    return oldDelegate.pulse != pulse;
  }
}

class _RadarAvatar extends StatelessWidget {
  const _RadarAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0F1F6), width: 6),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1D2BE), Color(0xFFB56A58)],
          ),
        ),
        child: const Icon(Icons.person_rounded, color: Colors.white, size: 36),
      ),
    );
  }
}

class _NearbyDeviceNode extends StatelessWidget {
  const _NearbyDeviceNode({
    required this.device,
    required this.size,
    required this.onTap,
  });

  final _DiscoverableDevice device;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(device.imagePath, fit: BoxFit.contain),
      ),
    );
  }
}

class _DetectedDeviceView extends StatelessWidget {
  const _DetectedDeviceView({required this.device, required this.onConnect});

  final _DiscoverableDevice device;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Connect to device',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2A2A),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _ConnectionHintPill(),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: LightColorTokens.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  device.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(
                  device.imagePath,
                  width: 260,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: FilledButton(
              onPressed: onConnect,
              style: FilledButton.styleFrom(
                backgroundColor: LightColorTokens.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(29),
                ),
              ),
              child: const Text(
                'Connect',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Can\'t connect with your devices?',
            style: TextStyle(fontSize: 13, color: Color(0xFF585858)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Learn more',
            style: TextStyle(fontSize: 13, color: LightColorTokens.primary),
          ),
        ],
      ),
    );
  }
}

class _ConnectingDeviceView extends StatelessWidget {
  const _ConnectingDeviceView({required this.device, required this.progress});

  final _DiscoverableDevice device;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Connect to device',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2A2A),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _ConnectionHintPill(),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: LightColorTokens.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  device.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ringSize = math.min(constraints.maxWidth, 320.0);
                  final imagePadding = ringSize * 0.2;
                  return SizedBox.square(
                    dimension: ringSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size.square(ringSize),
                          painter: _ConnectProgressPainter(
                            progress: progress / 100,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(imagePadding),
                          child: Image.asset(
                            device.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const FittedBox(
            child: Text(
              'Connecting...',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B6B6B)),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              '$progress%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: LightColorTokens.primary,
              ),
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Can\'t connect with your devices?',
            style: TextStyle(fontSize: 13, color: Color(0xFF585858)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Learn more',
            style: TextStyle(fontSize: 13, color: LightColorTokens.primary),
          ),
        ],
      ),
    );
  }
}

class _ConnectedView extends StatelessWidget {
  const _ConnectedView({
    required this.device,
    required this.onHomepage,
    required this.onControlDevice,
  });

  final _DiscoverableDevice device;
  final VoidCallback onHomepage;
  final VoidCallback onControlDevice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 70),
            Container(
              width: 78,
              height: 78,
              decoration: const BoxDecoration(
                color: LightColorTokens.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const FittedBox(
              child: Text(
                'Connected!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24262E),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You have connected to ${device.name}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6A6A6A)),
            ),
            const SizedBox(height: 34),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Image.asset(
                    device.imagePath,
                    width: 230,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
              decoration: const BoxDecoration(
                color: LightColorTokens.background,
                border: Border(top: BorderSide(color: Color(0xFFE1E1E1))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: onHomepage,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE7EAF4),
                          foregroundColor: LightColorTokens.primary,
                        ),
                        child: const Text(
                          'Go to Homepage',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: onControlDevice,
                        style: FilledButton.styleFrom(
                          backgroundColor: LightColorTokens.primary,
                        ),
                        child: const Text(
                          'Control Device',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionHintPill extends StatelessWidget {
  const _ConnectionHintPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MiniCircleIcon(icon: Icons.wifi_rounded),
          SizedBox(width: 4),
          _MiniCircleIcon(icon: Icons.bluetooth_rounded),
          SizedBox(width: 8),
          Text(
            'Turn on your Wifi & Bluetooth to connect',
            style: TextStyle(fontSize: 10, color: Color(0xFF7A7A7A)),
          ),
        ],
      ),
    );
  }
}

class _MiniCircleIcon extends StatelessWidget {
  const _MiniCircleIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: LightColorTokens.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 11),
    );
  }
}

class _ConnectProgressPainter extends CustomPainter {
  _ConnectProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - 12;
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = const Color(0xFFE8E8E8)
      ..strokeCap = StrokeCap.round;
    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = LightColorTokens.primary
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ConnectProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _DiscoverableDevice {
  const _DiscoverableDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.connectivity,
    required this.imagePath,
    required this.category,
  });

  final String id;
  final String name;
  final DeviceType type;
  final String connectivity;
  final String imagePath;
  final String category;

  SmartDevice toSmartDevice(String selectedRoom) {
    final room = selectedRoom == 'All Rooms' ? 'Living Room' : selectedRoom;
    return SmartDevice(
      id: id,
      name: name,
      room: room,
      type: type,
      connectivity: connectivity,
      icon: _iconForType(type),
      imagePath: imagePath,
      isOn: true,
    );
  }

  IconData _iconForType(DeviceType type) {
    if (type == DeviceType.light) return Icons.lightbulb_rounded;
    if (type == DeviceType.camera) return Icons.videocam_rounded;
    if (type == DeviceType.speaker) return Icons.speaker_rounded;
    return Icons.ac_unit_rounded;
  }
}

const List<_DiscoverableDevice> _discoverableDevices = [
  _DiscoverableDevice(
    id: 'det-cctv-1',
    name: 'Smart V1 CCTV',
    type: DeviceType.camera,
    connectivity: 'Wi-Fi',
    imagePath: 'assets/camera.jpg',
    category: 'Camera',
  ),
  _DiscoverableDevice(
    id: 'det-lamp-1',
    name: 'Smart Lamp',
    type: DeviceType.light,
    connectivity: 'Wi-Fi',
    imagePath: 'assets/bong_den.jpg',
    category: 'Lighting',
  ),
  _DiscoverableDevice(
    id: 'det-speaker-1',
    name: 'Stereo Speaker',
    type: DeviceType.speaker,
    connectivity: 'Bluetooth',
    imagePath: 'assets/stereo.jpg',
    category: 'Audio',
  ),
  _DiscoverableDevice(
    id: 'det-router-1',
    name: 'Router',
    type: DeviceType.electrical,
    connectivity: 'Wi-Fi',
    imagePath: 'assets/png/device_ac.png',
    category: 'Electrical',
  ),
  _DiscoverableDevice(
    id: 'det-ac-1',
    name: 'Air Conditioner',
    type: DeviceType.electrical,
    connectivity: 'Bluetooth',
    imagePath: 'assets/png/device_ac.png',
    category: 'Electrical',
  ),
];
