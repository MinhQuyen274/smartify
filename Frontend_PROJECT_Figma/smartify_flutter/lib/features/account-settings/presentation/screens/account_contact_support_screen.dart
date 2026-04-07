import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_surface_card.dart';

class AccountContactSupportScreen extends StatelessWidget {
  const AccountContactSupportScreen({super.key});

  static const _channels = [
    _SupportChannel('Customer Support', _SupportChannelType.customerSupport),
    _SupportChannel('Website', _SupportChannelType.website),
    _SupportChannel('WhatsApp', _SupportChannelType.whatsapp),
    _SupportChannel('Facebook', _SupportChannelType.facebook),
    _SupportChannel('Twitter', _SupportChannelType.twitter),
    _SupportChannel('Instagram', _SupportChannelType.instagram),
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Contact Support',
      backgroundColor: const Color(0xFFF7F8FA),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        itemBuilder: (context, index) {
          final channel = _channels[index];
          return SettingsSurfaceCard(
            title: channel.label,
            leading: _SupportIcon(type: channel.type),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: LightColorTokens.textPrimary,
              size: 24,
            ),
            onTap: () => _showChannelDialog(context, channel.label),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemCount: _channels.length,
      ),
    );
  }

  Future<void> _showChannelDialog(BuildContext context, String label) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(label),
          content: Text('This prototype would open the $label channel.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _SupportIcon extends StatelessWidget {
  const _SupportIcon({required this.type});

  final _SupportChannelType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _SupportChannelType.customerSupport:
        return const Icon(
          Icons.headset_mic_rounded,
          color: LightColorTokens.primary,
          size: 28,
        );
      case _SupportChannelType.website:
        return const Icon(
          Icons.language_rounded,
          color: LightColorTokens.primary,
          size: 28,
        );
      case _SupportChannelType.whatsapp:
        return const _BrandLetter(letter: 'W');
      case _SupportChannelType.facebook:
        return const _BrandLetter(letter: 'f');
      case _SupportChannelType.twitter:
        return const _BrandLetter(letter: 't');
      case _SupportChannelType.instagram:
        return const _BrandLetter(letter: 'i');
    }
  }
}

class _BrandLetter extends StatelessWidget {
  const _BrandLetter({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: LightColorTokens.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        letter,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SupportChannel {
  const _SupportChannel(this.label, this.type);

  final String label;
  final _SupportChannelType type;
}

enum _SupportChannelType {
  customerSupport,
  website,
  whatsapp,
  facebook,
  twitter,
  instagram,
}
