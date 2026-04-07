import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_flow_scaffold.dart';

class SmartOptionConditionScreenArgs {
  const SmartOptionConditionScreenArgs({
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.icon,
    required this.color,
    this.summaryPrefix,
    this.location = 'New York City',
  });

  final String title;
  final List<String> options;
  final String selectedOption;
  final IconData icon;
  final Color color;
  final String? summaryPrefix;
  final String location;
}

class SmartOptionConditionScreen extends StatefulWidget {
  const SmartOptionConditionScreen({super.key, required this.args});

  final SmartOptionConditionScreenArgs args;

  @override
  State<SmartOptionConditionScreen> createState() =>
      _SmartOptionConditionScreenState();
}

class _SmartOptionConditionScreenState extends State<SmartOptionConditionScreen> {
  late String _selected = widget.args.selectedOption;

  @override
  Widget build(BuildContext context) {
    return SmartFlowScaffold(
      title: widget.args.title,
      actionLabel: 'Continue',
      onAction: () {
        final prefix = widget.args.summaryPrefix;
        final title =
            prefix == null ? _selected : '$prefix: $_selected';
        Navigator.pop(
          context,
          SceneSummaryItem(
            id: '${widget.args.title}-$title',
            title: title,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Row(
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
              ),
              const Divider(height: 1, color: Color(0xFFE9EBF0)),
              for (final option in widget.args.options)
                RadioListTile<String>(
                  value: option,
                  groupValue: _selected,
                  onChanged: (value) => setState(() => _selected = value!),
                  activeColor: const Color(0xFF4A68F6),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  title: Text(option, style: Theme.of(context).textTheme.titleLarge),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
