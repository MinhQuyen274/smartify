import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_flow_scaffold.dart';

class DelayActionScreen extends StatefulWidget {
  const DelayActionScreen({super.key});

  @override
  State<DelayActionScreen> createState() => _DelayActionScreenState();
}

class _DelayActionScreenState extends State<DelayActionScreen> {
  int _hours = 0;
  int _minutes = 15;
  int _seconds = 30;

  @override
  Widget build(BuildContext context) {
    return SmartFlowScaffold(
      title: 'Delay the Action',
      actionLabel: 'Continue',
      onAction: () {
        Navigator.pop(
          context,
          SceneSummaryItem(
            id: 'delay-$_hours-$_minutes-$_seconds',
            title: 'Delay the Action',
            subtitle: '${_hours} h ${_minutes} mins ${_seconds} secs'
                .replaceFirst('0 h ', ''),
            icon: Icons.access_time_filled_rounded,
            color: const Color(0xFF607D8B),
          ),
        );
      },
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: _PickerColumn(
                values: List.generate(24, (index) => index),
                selected: _hours,
                unit: 'h',
                onChanged: (value) => setState(() => _hours = value),
              ),
            ),
            Expanded(
              child: _PickerColumn(
                values: List.generate(60, (index) => index),
                selected: _minutes,
                unit: 'm',
                onChanged: (value) => setState(() => _minutes = value),
              ),
            ),
            Expanded(
              child: _PickerColumn(
                values: List.generate(60, (index) => index),
                selected: _seconds,
                unit: 's',
                onChanged: (value) => setState(() => _seconds = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerColumn extends StatelessWidget {
  const _PickerColumn({
    required this.values,
    required this.selected,
    required this.unit,
    required this.onChanged,
  });

  final List<int> values;
  final int selected;
  final String unit;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = FixedExtentScrollController(initialItem: selected);
    return SizedBox(
      height: 220,
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: 46,
        useMagnifier: true,
        magnification: 1.12,
        onSelectedItemChanged: (index) => onChanged(values[index]),
        children: values
            .map(
              (value) => Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$value',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      TextSpan(
                        text: '  $unit',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF666A73),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
