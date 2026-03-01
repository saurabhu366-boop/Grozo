// lib/widgets/chat_message_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopzy/models/chat_message.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/recipe_card_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final Animation<double> animation;
  final Function(String)? onQuickActionTapped;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.animation,
    this.onQuickActionTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == ChatMessageType.user;

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser) ...[
                const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.psychology_outlined, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: _buildMessageContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContainer() {
    final isUser = message.type == ChatMessageType.user;
    final isTyping = message.type == ChatMessageType.ai_typing;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 16, vertical: isTyping ? 18 : 12),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
          bottomRight: isUser ? Radius.zero : const Radius.circular(20),
        ),
        boxShadow: isUser
            ? null
            : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: isUser ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: _buildMessageContent(),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case ChatMessageType.user:
        return _buildUserMessage();
      case ChatMessageType.ai:
        return _buildAiMessage();
      case ChatMessageType.ai_typing:
        return const TypingIndicator();
    }
  }

  Widget _buildUserMessage() {
    return Text(
      message.text,
      style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
    );
  }

  Widget _buildFormattedText(String text) {
    final RegExp boldRegExp = RegExp(r'\*\*(.*?)\*\*');
    final RegExp bulletRegExp = RegExp(r'^(•|\*|-)\s');

    final List<TextSpan> children = [];
    final lines = text.split('\n');

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];

      if (line.isEmpty && i < lines.length - 1) {
        children.add(const TextSpan(text: '\n'));
        continue;
      }

      final hasBullet = bulletRegExp.hasMatch(line);
      if (hasBullet) {
        children.add(const TextSpan(text: '•  ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)));
        line = line.replaceFirst(bulletRegExp, '');
      }

      line.splitMapJoin(
        boldRegExp,
        onMatch: (Match match) {
          children.add(TextSpan(
            text: match.group(1),
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textCharcoal),
          ));
          return '';
        },
        onNonMatch: (String nonMatch) {
          children.add(TextSpan(text: nonMatch));
          return '';
        },
      );

      if (i < lines.length - 1) {
        children.add(const TextSpan(text: '\n'));
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: GoogleFonts.inter().fontFamily,
          color: AppColors.textCharcoal,
          fontSize: 16,
          height: 1.5,
        ),
        children: children,
      ),
    );
  }

  Widget _buildAiMessage() {
    final response = message.aiResponse!;
    final quickActions = (response['quick_actions'] as List?)?.cast<String>() ?? [];
    final responseType = response['response_type'] as String?;

    Widget content;
    switch (responseType) {
      case 'deal_card':
        content = _buildDealCard(response);
        break;
      case 'recipe_card':
        content = RecipeCardWidget(recipeData: response);
        break;
      default:
        content = _buildFormattedText(message.text);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        if (quickActions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: quickActions.map((action) => _buildQuickAction(action)).toList(),
          ),
        ]
      ],
    );
  }

  Widget _buildDealCard(Map<String, dynamic> response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (response['ui_message'] != null) ...[
          _buildFormattedText(response['ui_message']),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.local_offer_outlined, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (response['deal_title'] != null)
                      Text(
                        response['deal_title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textCharcoal,
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (response['deal_description'] != null)
                      _buildFormattedText(response['deal_description']),
                    if (response['bonus_info'] != null) ...[
                      const SizedBox(height: 8),
                      _buildFormattedText(response['bonus_info']),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildQuickAction(String action) {
    return GestureDetector(
      onTap: () => onQuickActionTapped?.call(action),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Text(
          action,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.2, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(0.1 * index, 0.4 + 0.1 * index, curve: Curves.easeInOut),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 8.0,
            height: 8.0,
            decoration: const BoxDecoration(
              color: AppColors.secondaryText,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}