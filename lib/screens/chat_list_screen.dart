import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/helpers.dart';
import '../services/mock_data_service.dart';
import '../models/chat.dart';
import 'chat_conversation_screen.dart';
import '../widgets/create_help_request_modal.dart';

/// Chat List Screen
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = MockDataService.getChatConversations();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Messages', style: AppTextStyles.h2),
                  ElevatedButton.icon(
                    onPressed: () => showCreateHelpRequestModal(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Post Help Request'),
                  ),
                ],
              ),
            ),
            
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.backgroundGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Conversations List
            Expanded(
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  return _buildConversationTile(context, conversations[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, ChatConversation conversation) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.chatAnonymous.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                conversation.otherUser.avatar ?? '👤',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          if (conversation.otherUser.isVerified)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  size: 14,
                  color: AppColors.verified,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Text(
            conversation.otherUser.name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            Helpers.formatTimeAgo(conversation.lastMessageTime),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (conversation.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                conversation.unreadCount.toString(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conversation.lastMessage,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Re: ${conversation.category}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatConversationScreen(
              conversation: conversation,
            ),
          ),
        );
      },
    );
  }
}
