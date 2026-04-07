import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/widgets/smart_primary_action_button.dart';

class SmartFlowScaffold extends StatelessWidget {
  const SmartFlowScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.actions = const [],
    this.bodyPadding = const EdgeInsets.fromLTRB(24, 18, 24, 0),
    this.bottomInset = 20,
  });

  final String title;
  final Widget body;
  final String actionLabel;
  final VoidCallback? onAction;
  final List<Widget> actions;
  final EdgeInsets bodyPadding;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  if (actions.isEmpty)
                    const SizedBox(width: 48)
                  else
                    Row(mainAxisSize: MainAxisSize.min, children: actions),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: bodyPadding,
                child: body,
              ),
            ),
            SmartPrimaryActionButton(
              label: actionLabel,
              onTap: onAction,
              margin: EdgeInsets.fromLTRB(24, 12, 24, bottomInset),
            ),
          ],
        ),
      ),
    );
  }
}
