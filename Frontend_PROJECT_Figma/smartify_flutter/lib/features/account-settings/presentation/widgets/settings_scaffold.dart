import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class SettingsScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool centerTitle;

  const SettingsScaffold({
    super.key,
    required this.title,
    required this.child,
    this.backgroundColor,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = backgroundColor ?? LightColorTokens.background;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        elevation: 0,
        centerTitle: centerTitle,
        actions: actions,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: LightColorTokens.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: child,
    );
  }
}
