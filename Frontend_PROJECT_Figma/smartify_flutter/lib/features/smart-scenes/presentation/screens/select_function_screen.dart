import 'package:flutter/material.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_flow_scaffold.dart';

class SelectFunctionScreen extends StatefulWidget {
  const SelectFunctionScreen({super.key, required this.device});

  final SmartSceneDevice device;

  @override
  State<SelectFunctionScreen> createState() => _SelectFunctionScreenState();
}

class _SelectFunctionScreenState extends State<SelectFunctionScreen> {
  String _value = 'ON';

  @override
  Widget build(BuildContext context) {
    return SmartFlowScaffold(
      title: 'Select Function',
      actionLabel: 'OK',
      onAction: () {
        Navigator.pop(
          context,
          SceneSummaryItem(
            id: '${widget.device.id}-$_value',
            title: widget.device.name,
            subtitle: '${widget.device.room} - Function: $_value',
            icon: widget.device.taskIcon,
            color: widget.device.taskColor,
          ),
        );
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 248,
              height: 248,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E6ED)),
              ),
              child: Center(
                child: Image.asset(widget.device.assetPath, width: 180, height: 120),
              ),
            ),
            const SizedBox(height: 22),
            Text(widget.device.name, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 10),
            Text(widget.device.room, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: const Color(0xFF787B85))),
            const SizedBox(height: 28),
            Row(
              children: [
                Text('Function', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF8A8D96))),
                const Expanded(child: Divider(indent: 14, color: Color(0xFFE9EBF0))),
              ],
            ),
            const SizedBox(height: 14),
            RadioListTile<String>(
              value: 'ON',
              groupValue: _value,
              activeColor: const Color(0xFF4A68F6),
              title: Text('ON', style: Theme.of(context).textTheme.titleLarge),
              onChanged: (value) => setState(() => _value = value!),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              value: 'OFF',
              groupValue: _value,
              activeColor: const Color(0xFF4A68F6),
              title: Text('OFF', style: Theme.of(context).textTheme.titleLarge),
              onChanged: (value) => setState(() => _value = value!),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
