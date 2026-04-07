import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';

class AccountVoiceAssistantsScreen extends StatefulWidget {
  const AccountVoiceAssistantsScreen({super.key});

  @override
  State<AccountVoiceAssistantsScreen> createState() =>
      _AccountVoiceAssistantsScreenState();
}

class _AccountVoiceAssistantsScreenState
    extends State<AccountVoiceAssistantsScreen> {
  final List<_AssistantCardData> _assistants = [
    _AssistantCardData('Google Assistant', false, _AssistantBrand.google),
    _AssistantCardData('Amazon Alexa', true, _AssistantBrand.alexa),
    _AssistantCardData('Microsoft Cortana', true, _AssistantBrand.cortana),
    _AssistantCardData('Samsung Bixby', false, _AssistantBrand.bixby),
    _AssistantCardData('Naver Clova', false, _AssistantBrand.clova),
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: 'Voice Assistants',
      backgroundColor: const Color(0xFFF7F8FA),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ],
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 182,
        ),
        itemCount: _assistants.length,
        itemBuilder: (context, index) {
          final item = _assistants[index];
          return _AssistantCard(
            item: item,
            onTap: () {
              final next = item.copyWith(isLinked: !item.isLinked);
              setState(() => _assistants[index] = next);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    next.isLinked
                        ? 'Linked ${next.name}'
                        : 'Unlinked ${next.name}',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AssistantCard extends StatelessWidget {
  const _AssistantCard({
    required this.item,
    required this.onTap,
  });

  final _AssistantCardData item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.isLinked
                  ? LightColorTokens.primary.withValues(alpha: 0.28)
                  : const Color(0xFFE8EBF3),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            children: [
              SizedBox(
                height: 82,
                child: Center(
                  child: _AssistantLogo(brand: item.brand),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.isLinked ? 'Linked' : 'Unlinked',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: item.isLinked
                      ? LightColorTokens.primary
                      : const Color(0xFF8E95A3),
                  fontWeight: item.isLinked ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssistantLogo extends StatelessWidget {
  const _AssistantLogo({required this.brand});

  final _AssistantBrand brand;

  @override
  Widget build(BuildContext context) {
    switch (brand) {
      case _AssistantBrand.google:
        return SizedBox(
          width: 78,
          height: 78,
          child: Stack(
            alignment: Alignment.center,
            children: const [
              Positioned(
                left: 8,
                top: 8,
                child: CircleAvatar(radius: 20, backgroundColor: Color(0xFF4D8CF5)),
              ),
              Positioned(
                right: 16,
                top: 30,
                child: CircleAvatar(radius: 8, backgroundColor: Color(0xFFFF5545)),
              ),
              Positioned(
                right: 16,
                bottom: 12,
                child: CircleAvatar(radius: 9, backgroundColor: Color(0xFFFFC107)),
              ),
              Positioned(
                right: 5,
                top: 18,
                child: CircleAvatar(radius: 4, backgroundColor: Color(0xFF4CAF50)),
              ),
            ],
          ),
        );
      case _AssistantBrand.alexa:
        return _RingLogo(
          color: const Color(0xFF5FC0EA),
          child: Container(
            width: 20,
            height: 30,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF5FC0EA), width: 5),
              ),
            ),
          ),
        );
      case _AssistantBrand.cortana:
        return const _RingLogo(color: Color(0xFF53BCE8));
      case _AssistantBrand.bixby:
        return Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFF5078FF), Color(0xFF28D3C7)],
            ),
          ),
          child: Center(
            child: Text(
              'b',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      case _AssistantBrand.clova:
        return Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: const Color(0xFF31E0B4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.local_florist_outlined, color: Colors.white, size: 42),
          ),
        );
    }
  }
}

class _RingLogo extends StatelessWidget {
  const _RingLogo({required this.color, this.child});

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 6),
      ),
      child: child == null ? null : Center(child: child),
    );
  }
}

class _AssistantCardData {
  const _AssistantCardData(this.name, this.isLinked, this.brand);

  final String name;
  final bool isLinked;
  final _AssistantBrand brand;

  _AssistantCardData copyWith({bool? isLinked}) {
    return _AssistantCardData(
      name,
      isLinked ?? this.isLinked,
      brand,
    );
  }
}

enum _AssistantBrand { google, alexa, cortana, bixby, clova }
