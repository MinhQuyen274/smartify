import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/reports/presentation/widgets/device_usage_card.dart';
import 'package:smartify_flutter/features/reports/state/reports_store.dart';

/// Detailed bill for a device type — 2-col grid of individual device bills.
/// Matches Figma "Smart Lamp (12)" detail screen (screen 106).
class DeviceDetailBillScreen extends StatelessWidget {
  const DeviceDetailBillScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ReportsStore>();
    final usage = store.deviceUsageById(deviceId);
    final bills = store.billsForDevice(deviceId);
    final title = usage != null
        ? '${usage.name} (${usage.deviceCount})'
        : 'Device Detail';

    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: LightColorTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Bills grid ──
            Expanded(
              child: bills.isEmpty
                  ? Center(
                      child: AuthMotionSection(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 56,
                              color: LightColorTokens.border,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'No data available',
                              style:
                                  Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.82,
                          ),
                      itemCount: bills.length,
                      itemBuilder: (_, i) {
                        return AuthMotionSection(
                          delay: Duration(milliseconds: 40 * i),
                          child: DeviceBillCard(item: bills[i]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
