import 'package:flutter/material.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';

class ChatWithBoboScreen extends StatefulWidget {
  const ChatWithBoboScreen({super.key});

  @override
  State<ChatWithBoboScreen> createState() => _ChatWithBoboScreenState();
}

class _ChatWithBoboScreenState extends State<ChatWithBoboScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late List<_ChatMessage> _messages;
  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = [
      _ChatMessage(
        id: 'welcome-user',
        text: 'Hi Bobo!',
        isUser: true,
        timeLabel: '09:41',
      ),
      _ChatMessage(
        id: 'welcome-bot',
        text: 'Hello there! How can I assist you today?',
        isUser: false,
        timeLabel: '09:41',
        showsAvatar: true,
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final rawText = _controller.text.trim();
    if (rawText.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages = [
        ..._messages,
        _ChatMessage(
          id: 'user-${DateTime.now().microsecondsSinceEpoch}',
          text: rawText,
          isUser: true,
          timeLabel: _timeNow(),
        ),
      ];
      _isBotTyping = true;
    });
    _scrollToBottom();

    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    final reply = _buildReply(rawText);
    setState(() {
      _messages = [
        ..._messages,
        _ChatMessage(
          id: 'bot-${DateTime.now().microsecondsSinceEpoch}',
          text: reply,
          isUser: false,
          timeLabel: _timeNow(),
        ),
      ];
      _isBotTyping = false;
    });
    _scrollToBottom();
  }

  String _buildReply(String input) {
    final text = input.toLowerCase();
    if (text.contains('automation') || text.contains('scene')) {
      return 'You can create automation from the Smart tab. Open Smart, tap the plus button, choose a condition in If, then add actions in Then and save the scene.';
    }
    if (text.contains('device') || text.contains('add') || text.contains('connect')) {
      return 'To add a device, tap the plus button on Home, choose Add Device, then let Smartify look for nearby devices or use Scan for a QR flow.';
    }
    if (text.contains('energy') || text.contains('report')) {
      return 'Open Reports to review device usage, compare rooms, and check detailed energy bills for each connected device.';
    }
    if (text.contains('voice') || text.contains('assistant')) {
      return 'You can use the mic button on Home for voice commands and link external assistants from Settings > Voice Assistants.';
    }
    return 'Smartify can help you control devices, create automations, manage reports, and configure your home settings. Tell me what you want to set up next.';
  }

  String _timeNow() {
    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Chat with Bobo'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: viewInsets),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                itemCount: _messages.length + (_isBotTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isBotTyping && index == _messages.length) {
                    return const _TypingRow();
                  }
                  final message = _messages[index];
                  return _MessageRow(message: message);
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FA),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: const InputDecoration(
                            hintText: 'Ask me anything ...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: LightColorTokens.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor =
        message.isUser ? LightColorTokens.primary : const Color(0xFFF5F5F7);
    final textColor = message.isUser ? Colors.white : const Color(0xFF2A2A2A);
    final radius = BorderRadius.circular(14).copyWith(
      bottomRight: message.isUser ? const Radius.circular(4) : null,
      bottomLeft: !message.isUser ? const Radius.circular(4) : null,
    );

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (message.showsAvatar) const _BoboAvatar(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 302),
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: radius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      message.timeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: message.isUser
                            ? Colors.white.withValues(alpha: 0.86)
                            : const Color(0xFF8F95A3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoboAvatar extends StatelessWidget {
  const _BoboAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14, left: 4),
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: LightColorTokens.primary, width: 2),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
              top: 20,
              child: Container(
                width: 32,
                height: 6,
                decoration: BoxDecoration(
                  color: LightColorTokens.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              top: 28,
              left: 22,
              child: _AvatarEar(),
            ),
            Positioned(
              top: 28,
              right: 22,
              child: _AvatarEar(),
            ),
            Positioned(
              left: 26,
              top: 34,
              child: _AvatarEye(),
            ),
            Positioned(
              right: 26,
              top: 34,
              child: _AvatarEye(),
            ),
            Positioned(
              bottom: 24,
              child: Container(
                width: 12,
                height: 6,
                decoration: BoxDecoration(
                  color: LightColorTokens.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarEar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 18,
      decoration: BoxDecoration(
        border: Border.all(color: LightColorTokens.primary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _AvatarEye extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 14,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _TypingRow extends StatelessWidget {
  const _TypingRow();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(14).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _TypingDot(delayMs: 0),
            SizedBox(width: 6),
            _TypingDot(delayMs: 120),
            SizedBox(width: 6),
            _TypingDot(delayMs: 240),
          ],
        ),
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  const _TypingDot({required this.delayMs});

  final int delayMs;

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 720),
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.25, end: 1).animate(_controller),
      child: const SizedBox(
        width: 8,
        height: 8,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: LightColorTokens.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timeLabel,
    this.showsAvatar = false,
  });

  final String id;
  final String text;
  final bool isUser;
  final String timeLabel;
  final bool showsAvatar;
}
