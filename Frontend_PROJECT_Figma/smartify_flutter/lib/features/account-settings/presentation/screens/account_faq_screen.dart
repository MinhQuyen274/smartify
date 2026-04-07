import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/features/account-settings/presentation/widgets/settings_scaffold.dart';

class AccountFaqScreen extends StatefulWidget {
  const AccountFaqScreen({super.key});

  @override
  State<AccountFaqScreen> createState() => _AccountFaqScreenState();
}

class _AccountFaqScreenState extends State<AccountFaqScreen> {
  static const _categories = ['General', 'Account', 'Services', 'Home'];
  static const _items = [
    _FaqItem(
      category: 'General',
      question: 'What is Smartify?',
      answer:
          'Smartify is a user-friendly smart home application that enables seamless control and automation of connected devices, enhancing your living experience through innovative technology.',
    ),
    _FaqItem(
      category: 'Home',
      question: 'How do I add a new device?',
      answer:
          'Open your home dashboard, tap Add Device, and follow the guided pairing steps for the device brand you are connecting.',
    ),
    _FaqItem(
      category: 'Services',
      question: 'How do I create an automation?',
      answer:
          'Go to Smart Scenes, choose Create Scene, select triggers and actions, then save your automation to your preferred home.',
    ),
    _FaqItem(
      category: 'General',
      question: 'What\'s the "Tap-to-Run" feature?',
      answer:
          'Tap-to-Run lets you execute a saved scene instantly with one tap instead of waiting for an automation trigger.',
    ),
    _FaqItem(
      category: 'Home',
      question: 'Can I use Smartify offline?',
      answer:
          'Some local controls may remain available, but cloud automations, notifications, and most remote actions require internet access.',
    ),
    _FaqItem(
      category: 'Account',
      question: 'How can I reset my password?',
      answer:
          'Use the Forgot Password flow from Sign In, verify the OTP code, and choose a new password for your Smartify account.',
    ),
  ];

  String _selectedCategory = _categories.first;
  String _query = '';
  String _expandedQuestion = _items.first.question;

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items.where((item) {
      final matchesCategory = item.category == _selectedCategory;
      final query = _query.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          item.question.toLowerCase().contains(query) ||
          item.answer.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return SettingsScaffold(
      title: 'FAQ',
      backgroundColor: const Color(0xFFF7F8FA),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFB7BCC8),
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFFB7BCC8),
              ),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => setState(() => _selectedCategory = category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? LightColorTokens.primary : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSelected
                            ? LightColorTokens.primary
                            : const Color(0xFFD8DCE5),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? Colors.white : LightColorTokens.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: _categories.length,
            ),
          ),
          const SizedBox(height: 22),
          ...filteredItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _FaqCard(
                item: item,
                isExpanded: _expandedQuestion == item.question,
                onTap: () {
                  setState(() {
                    _expandedQuestion = _expandedQuestion == item.question
                        ? ''
                        : item.question;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  final _FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 24,
                    color: const Color(0xFF727A89),
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFE7EAF0)),
                const SizedBox(height: 18),
                Text(
                  item.answer,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4A5160),
                    height: 1.8,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });

  final String category;
  final String question;
  final String answer;
}
