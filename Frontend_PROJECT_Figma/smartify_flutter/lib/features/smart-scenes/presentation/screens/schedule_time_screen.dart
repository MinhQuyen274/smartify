import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_flow_scaffold.dart';

class ScheduleTimeScreen extends StatefulWidget {
  const ScheduleTimeScreen({super.key});

  @override
  State<ScheduleTimeScreen> createState() => _ScheduleTimeScreenState();
}

class _ScheduleTimeScreenState extends State<ScheduleTimeScreen> {
  final List<String> _repeatOptions = const ['Every Day', 'Weekdays', 'Weekend'];
  bool _editingHour = true;
  int _hour = 21;
  int _minute = 0;
  String _repeat = 'Every Day';

  @override
  Widget build(BuildContext context) {
    final minuteText = _minute.toString().padLeft(2, '0');
    return SmartFlowScaffold(
      title: 'Schedule Time',
      actionLabel: 'Continue',
      onAction: () {
        final period = _hour >= 12 ? 'PM' : 'AM';
        Navigator.pop(
          context,
          SceneSummaryItem(
            id: 'schedule-$_hour-$_minute',
            title: 'Schedule Time: $_hour:$minuteText $period',
            subtitle: _repeat,
            icon: Icons.access_time_filled_rounded,
            color: const Color(0xFF4CAF50),
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
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Column(
              children: [
                InkWell(
                  onTap: _showRepeatSheet,
                  child: Row(
                    children: [
                      const Icon(Icons.repeat_rounded),
                      const SizedBox(width: 14),
                      Text('Repeat', style: Theme.of(context).textTheme.titleMedium),
                      const Spacer(),
                      Text(_repeat, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFE9EBF0)),
                const SizedBox(height: 22),
                InkWell(
                  onTap: () => setState(() => _editingHour = !_editingHour),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                        children: [
                          TextSpan(
                            text: _hour.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: _editingHour
                                  ? const Color(0xFF24262E)
                                  : const Color(0xFFB3B5BC),
                            ),
                          ),
                          const TextSpan(text: ' : ', style: TextStyle(color: Color(0xFFB3B5BC))),
                          TextSpan(
                            text: minuteText,
                            style: TextStyle(
                              color: _editingHour
                                  ? const Color(0xFFB3B5BC)
                                  : const Color(0xFF24262E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _SceneDial(
                  values: _editingHour
                      ? List.generate(24, (index) => index)
                      : List.generate(12, (index) => index == 0 ? 0 : index * 5),
                  selectedValue: _editingHour ? _hour : _minute,
                  onSelected: (value) {
                    setState(() {
                      if (_editingHour) {
                        _hour = value;
                      } else {
                        _minute = value;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showRepeatSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final option in _repeatOptions)
                ListTile(
                  title: Text(option),
                  trailing: option == _repeat
                      ? const Icon(Icons.check_rounded, color: Color(0xFF4A68F6))
                      : null,
                  onTap: () {
                    setState(() => _repeat = option);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SceneDial extends StatelessWidget {
  const _SceneDial({
    required this.values,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<int> values;
  final int selectedValue;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const size = 320.0;
    const radius = 118.0;
    final selectedIndex = values.indexOf(selectedValue).clamp(0, values.length - 1);

    return GestureDetector(
      onPanUpdate: (details) => _selectFromOffset(details.localPosition, size),
      onTapDown: (details) => _selectFromOffset(details.localPosition, size),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE4E6ED)),
                ),
              ),
            ),
            CustomPaint(
              size: const Size(size, size),
              painter: _DialPointerPainter(
                index: selectedIndex,
                count: values.length,
                radius: radius,
              ),
            ),
            for (int index = 0; index < values.length; index++)
              _DialLabel(
                label: values[index].toString().padLeft(2, '0'),
                index: index,
                count: values.length,
                radius: radius,
                selected: values[index] == selectedValue,
              ),
          ],
        ),
      ),
    );
  }

  void _selectFromOffset(Offset offset, double size) {
    final center = Offset(size / 2, size / 2);
    final dx = offset.dx - center.dx;
    final dy = offset.dy - center.dy;
    if (dx.abs() < 14 && dy.abs() < 14) return;
    final angle = (math.atan2(dy, dx) + math.pi / 2 + math.pi * 2) %
        (math.pi * 2);
    final step = (math.pi * 2) / values.length;
    final index = (angle / step).round() % values.length;
    onSelected(values[index]);
  }
}

class _DialPointerPainter extends CustomPainter {
  const _DialPointerPainter({
    required this.index,
    required this.count,
    required this.radius,
  });

  final int index;
  final int count;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final angle = (math.pi * 2 / count) * index - math.pi / 2;
    final knob = Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
    final paint = Paint()
      ..color = const Color(0xFF4A68F6)
      ..strokeWidth = 3;
    canvas.drawLine(center, knob, paint);
    canvas.drawCircle(center, 5, paint);
    canvas.drawCircle(knob, 22, Paint()..color = const Color(0xFF4A68F6));
  }

  @override
  bool shouldRepaint(covariant _DialPointerPainter oldDelegate) {
    return oldDelegate.index != index || oldDelegate.count != count;
  }
}

class _DialLabel extends StatelessWidget {
  const _DialLabel({
    required this.label,
    required this.index,
    required this.count,
    required this.radius,
    required this.selected,
  });

  final String label;
  final int index;
  final int count;
  final double radius;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    const size = 320.0;
    final angle = (math.pi * 2 / count) * index - math.pi / 2;
    final center = size / 2;
    final x = center + math.cos(angle) * radius - 18;
    final y = center + math.sin(angle) * radius - 14;
    return Positioned(
      left: x,
      top: y,
      child: SizedBox(
        width: 36,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected ? Colors.white : const Color(0xFF24262E),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
