import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/helpers.dart';
import '../services/chat_repository.dart';
import 'chat_conversation_screen.dart';
import '../widgets/create_help_request_modal.dart';

/// Chat List Screen
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            
            // Conversations List Stream
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: ChatRepository().getConversationsStream(FirebaseAuth.instance.currentUser?.uid ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.textLight),
                          const SizedBox(height: 16),
                          Text(
                            'No Messages Yet',
                            style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  final conversations = snapshot.data!;

                  return ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      return _buildConversationTile(context, conversations[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, Map<String, dynamic> conversation) {
    final otherUserName = conversation['otherUserName'] ?? 'Unknown User';
    final otherUserAvatar = conversation['otherUserAvatar'] ?? '👤';
    final otherUserVerified = conversation['otherUserVerified'] ?? false;
    final lastMessage = conversation['lastMessage'] ?? '';
    final category = conversation['category'] ?? 'General';
    final unreadCount = conversation['unreadCount'] ?? 0;
    final id = conversation['id'] ?? '';
    
    final lastMessageTime = conversation['lastMessageTime'] is DateTime 
        ? conversation['lastMessageTime']
        : (conversation['lastMessageTime'] is Timestamp 
            ? conversation['lastMessageTime'].toDate() 
            : DateTime.now());

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
                otherUserAvatar,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          if (otherUserVerified)
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
            otherUserName,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            Helpers.formatTimeAgo(lastMessageTime),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
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
            lastMessage,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Re: $category',
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
              conversationId: id,
              otherUserName: otherUserName,
              otherUserAvatar: otherUserAvatar,
              otherUserVerified: otherUserVerified,
            ),
          ),
        );
      },
    );
  }
}
