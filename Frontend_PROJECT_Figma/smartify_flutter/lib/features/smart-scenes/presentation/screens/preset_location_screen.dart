import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_flow_scaffold.dart';

class PresetLocationScreen extends StatelessWidget {
  const PresetLocationScreen({super.key, required this.isArrive});

  final bool isArrive;

  @override
  Widget build(BuildContext context) {
    const address = '701 7th Ave, New York, 10036, USA';
    return SmartFlowScaffold(
      title: isArrive ? 'Arrive at' : 'Leave',
      actionLabel: 'Confirm',
      onAction: () {
        Navigator.pop(
          context,
          SceneSummaryItem(
            id: '${isArrive ? 'arrive' : 'leave'}-preset-location',
            title: isArrive ? 'Arrive at' : 'Leave',
            subtitle: address,
            icon: isArrive ? Icons.login_rounded : Icons.logout_rounded,
            color: isArrive
                ? const Color(0xFF57C76C)
                : const Color(0xFFFF5A4E),
          ),
        );
      },
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/png/location_map_exact.png'),
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF4A68F6),
                        width: 3,
                      ),
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A68F6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/camera.jpg'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Address Details', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(address, style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
      ),
    );
  }
}

