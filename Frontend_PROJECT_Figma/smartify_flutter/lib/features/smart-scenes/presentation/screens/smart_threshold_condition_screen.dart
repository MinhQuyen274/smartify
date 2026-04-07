import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_flow_scaffold.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_segmented_control.dart';

class SmartThresholdConditionScreenArgs {
  const SmartThresholdConditionScreenArgs({
    required this.title,
    required this.icon,
    required this.color,
    required this.unit,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.minLabel,
    required this.maxLabel,
    this.location = 'New York City',
  });

  final String title;
  final IconData icon;
  final Color color;
  final String unit;
  final double min;
  final double max;
  final double initialValue;
  final String minLabel;
  final String maxLabel;
  final String location;
}

class SmartThresholdConditionScreen extends StatefulWidget {
  const SmartThresholdConditionScreen({super.key, required this.args});

  final SmartThresholdConditionScreenArgs args;

  @override
  State<SmartThresholdConditionScreen> createState() =>
      _SmartThresholdConditionScreenState();
}

class _SmartThresholdConditionScreenState
    extends State<SmartThresholdConditionScreen> {
  ComparatorMode _mode = ComparatorMode.greaterThan;
  late double _value = widget.args.initialValue;

  @override
  Widget build(BuildContext context) {
    final displayValue = _value.round();
    return SmartFlowScaffold(
      title: widget.args.title,
      actionLabel: 'Continue',
      onAction: () {
        Navigator.pop(
          context,
          SceneSummaryItem(
            id: '${widget.args.title}-${_mode.symbol}-$displayValue',
            title:
                '${widget.args.title}: ${_mode.symbol} $displayValue${widget.args.unit}',
            subtitle: widget.args.location,
            icon: widget.args.icon,
            color: widget.args.color,
          ),
        );
      },
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 24),
                    const SizedBox(width: 16),
                    Text('Location', style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    Text(
                      widget.args.location,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFE9EBF0)),
                const SizedBox(height: 16),
                SmartSegmentedControl(
                  labels: const ['<', '=', '>'],
                  selectedIndex: ComparatorMode.values.indexOf(_mode),
                  onSelected: (index) => setState(
                    () => _mode = ComparatorMode.values[index],
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$displayValue',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      TextSpan(
                        text: widget.args.unit,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFF666A73),
                            ),
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: _value,
                  min: widget.args.min,
                  max: widget.args.max,
                  activeColor: const Color(0xFF4A68F6),
                  inactiveColor: const Color(0xFFE9EBF0),
                  onChanged: (value) => setState(() => _value = value),
                ),
                Row(
                  children: [
                    Text(
                      widget.args.minLabel,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF666A73),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.args.maxLabel,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF666A73),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
