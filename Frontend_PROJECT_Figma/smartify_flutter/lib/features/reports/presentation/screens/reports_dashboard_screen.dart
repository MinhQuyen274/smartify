import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/home-devices/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/reports/presentation/widgets/date_range_dropdown.dart';
import 'package:smartify_flutter/features/reports/presentation/widgets/device_usage_card.dart';
import 'package:smartify_flutter/features/reports/presentation/widgets/energy_summary_card.dart';
import 'package:smartify_flutter/features/reports/presentation/widgets/statistics_bar_chart.dart';
import 'package:smartify_flutter/features/reports/state/reports_store.dart';

/// Reports dashboard — energy summary cards + bar chart + device usage grid.
/// Matches Figma "Reports" screen (screen 103/105).
class ReportsDashboardScreen extends StatelessWidget {
  const ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ReportsStore>();

    return Scaffold(
      backgroundColor: LightColorTokens.background,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.homeDevicesDashboard);
          } else if (i == 1) {
            Navigator.pushReplacementNamed(context, AppRoutes.smartScenesDashboard);
          } else if (i == 3) {
            Navigator.pushReplacementNamed(context, AppRoutes.accountProfile);
          }
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'My Home',
                            style:
                                Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showCustomDatePicker(context, store),
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        color: LightColorTokens.textSecondary,
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
            ),

            // ── Energy summary cards row ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: AuthMotionSection(
                  child: Row(
                    children: [
                      for (int i = 0; i < store.summaries.length; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(
                          child: EnergySummaryCard(
                            summary: store.summaries[i],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ── Statistics section ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: AuthMotionSection(
                  delay: const Duration(milliseconds: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Statistics',
                            style:
                                Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          DateRangeDropdown(
                            options: ReportsStore.dateRangeOptions,
                            selectedValue: store.selectedRange,
                            onSelected: (value) {
                              if (value == 'custom') {
                                _showCustomDatePicker(context, store);
                              } else {
                                store.setDateRange(value);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      StatisticsBarChart(
                        data: store.monthlyUsage,
                        selectedIndex: store.selectedBarIndex,
                        onBarTap: store.selectBar,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Devices header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: AuthMotionSection(
                  delay: const Duration(milliseconds: 140),
                  child: Text(
                    'Devices',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),

            // ── Devices grid ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: store.loading && store.deviceUsageItems.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : SliverGrid.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                itemCount: store.deviceUsageItems.length,
                itemBuilder: (_, i) {
                  final item = store.deviceUsageItems[i];
                  return AuthMotionSection(
                    delay: Duration(milliseconds: 160 + 50 * i),
                    child: DeviceUsageCard(
                      item: item,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.reportsDeviceDetail,
                        arguments: item.id,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDatePicker(BuildContext context, ReportsStore store) {
    showDatePicker(
      context: context,
      initialDate: store.customDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Custom Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: LightColorTokens.primary,
            ),
          ),
          child: child!,
        );
      },
    ).then((picked) {
      if (picked != null) {
        store.setCustomDate(picked);
        store.setDateRange('custom');
      }
    });
  }
}
