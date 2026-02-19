// lib/screens/ai_assistant_screen.dart
import 'package:flutter/material.dart';
import 'package:shopzy/models/chat_message.dart';
import 'package:shopzy/services/ai_shopping_assistant_service.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/chat_message_widget.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final AiShoppingAssistantService _aiService = AiShoppingAssistantService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
    _textController.addListener(() {
      setState(() {}); // Rebuild to update send button state
    });
  }

  void _addInitialMessage() async {
    final welcomeResponse = await _aiService.getWelcomeMessage();
    _addMessage(ChatMessage.ai(aiResponse: welcomeResponse));
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    _listKey.currentState?.insertItem(
      _messages.length - 1,
      duration: const Duration(milliseconds: 400),
    );
    _scrollToBottom();
  }


  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMessage = text.trim();
    _textController.clear();

    _addMessage(ChatMessage.user(text: userMessage));

    setState(() {
      _isLoading = true;
    });
    _addMessage(const ChatMessage.typing());
    _scrollToBottom();

    try {
      final response = await _aiService.getResponse(userMessage);
      // Remove typing indicator before adding AI response
      final typingMessageIndex = _messages.lastIndexWhere((m) => m.type == ChatMessageType.ai_typing);
      if(typingMessageIndex != -1) {
        final removedItem = _messages.removeAt(typingMessageIndex);
        _listKey.currentState?.removeItem(
            typingMessageIndex,
                (context, animation) => ChatMessageWidget(message: removedItem, animation: animation),
            duration: Duration.zero
        );
      }
      _addMessage(ChatMessage.ai(aiResponse: response));
    } catch (e) {
      final typingMessageIndex = _messages.lastIndexWhere((m) => m.type == ChatMessageType.ai_typing);
      if(typingMessageIndex != -1) {
        final removedItem = _messages.removeAt(typingMessageIndex);
        _listKey.currentState?.removeItem(
            typingMessageIndex,
                (context, animation) => ChatMessageWidget(message: removedItem, animation: animation),
            duration: Duration.zero
        );
      }
      _addMessage(ChatMessage.ai(aiResponse: {'ui_message': 'Oops, something went wrong.'}));
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Shopping Assistant'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                return ChatMessageWidget(
                  message: _messages[index],
                  animation: animation,
                  onQuickActionTapped: _handleSubmitted,
                );
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    final bool canSend = _textController.text.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.0)),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Ask a question...',
                    hintStyle: const TextStyle(color: AppColors.secondaryText),
                  ).copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(color: AppColors.textCharcoal, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: CircleAvatar(
                backgroundColor: canSend ? AppColors.primary : AppColors.secondaryText.withOpacity(0.5),
                radius: 24,
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  onPressed: _isLoading || !canSend ? null : () => _handleSubmitted(_textController.text),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}