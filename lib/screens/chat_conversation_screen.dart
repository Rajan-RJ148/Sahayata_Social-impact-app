import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/helpers.dart';
import '../models/chat.dart';
import '../models/user.dart';

/// Enhanced Chat Conversation Screen matching new design
class ChatConversationScreen extends StatefulWidget {
  final ChatConversation conversation;

  const ChatConversationScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Sample messages matching screenshot
    _messages.addAll([
      ChatMessage(
        id: '1',
        text: 'Hi! I saw your post about needing food assistance.',
        isSent: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ChatMessage(
        id: '2',
        text: 'Yes, thank you for reaching out!',
        isSent: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
        hasReaction: true,
        reaction: '👍',
      ),
      ChatMessage(
        id: '3',
        text: 'I can bring some groceries today around 3 PM. Does that work?',
        isSent: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 27)),
      ),
      ChatMessage(
        id: '4',
        text: 'That would be wonderful! The location is near Station Road.',
        isSent: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        hasReaction: true,
        reaction: '👍',
      ),
      ChatMessage(
        id: '5',
        text: 'Perfect! See you then 🙏',
        isSent: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 24)),
      ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _messageController.text.trim(),
        isSent: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.chatAnonymous.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      widget.conversation.otherUser.avatar ?? '👤',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  if (widget.conversation.otherUser.isVerified)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          size: 12,
                          color: AppColors.verified,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.otherUser.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Contact kept private for safety',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          // Warning Banner
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.primary.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '⚠️ Your phone number is anonymous. Be cautious when sharing personal information.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundGray,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mic),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send),
                      color: AppColors.textWhite,
                      padding: const EdgeInsets.all(8),
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isSent
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isSent
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isSent) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.chatAnonymous.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.conversation.otherUser.avatar ?? '👤',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: message.isSent
                        ? AppColors.primary
                        : AppColors.chatOther,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: message.isSent
                          ? const Radius.circular(16)
                          : const Radius.circular(4),
                      bottomRight: message.isSent
                          ? const Radius.circular(4)
                          : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: message.isSent
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              if (message.isSent) const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(
              left: message.isSent ? 0 : 40,
              right: message.isSent ? 8 : 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textLight,
                    fontSize: 11,
                  ),
                ),
                if (message.hasReaction && message.reaction != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGray,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      message.reaction!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
