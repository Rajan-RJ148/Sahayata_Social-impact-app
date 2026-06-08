import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data_service.dart';

/*
 * SECTION 3.4 BLUEPRINT: FIRESTORE CHAT & MESSAGING COLLECTION SCHEMA
 * 
 * Target Collection Path: 'conversations/{conversationId}'
 * Target Subcollection Path: 'conversations/{conversationId}/messages/{messageId}'
 * 
 * Target Conversation Fields:
 * 1. participants (List<String>) - Array of user UIDs involved
 * 2. lastMessage (String) - Snippet of the latest message
 * 3. lastMessageTime (Timestamp/String) - Time of the latest message
 * 4. category (String) - Context category (e.g., 'food help')
 * 5. helpRequestId (String) - Associated help request ID
 * 6. createdAt (Timestamp/String) - Conversation initiation time
 * 
 * Target Message Fields:
 * 1. senderId (String) - Firebase Auth UID of the sender
 * 2. text (String) - Message body content
 * 3. timestamp (Timestamp/String) - Message send time
 * 4. reaction (String) - Emoji reaction if any
 * 5. mediaUrl (String) - Optional attached image/file URL
 * 6. type (String) - Message type (e.g., 'text', 'image')
 */

/// Repository handling all Firestore data operations for Chat & Messaging.
class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sends a new message and updates the parent conversation's last message metadata.
  Future<void> sendMessage(String conversationId, Map<String, dynamic> messageData) async {
    try {
      final batch = _firestore.batch();
      
      // 1. Add message to subcollection
      final messageRef = _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc();
          
      batch.set(messageRef, messageData);
      
      // 2. Update parent conversation metadata
      final conversationRef = _firestore.collection('conversations').doc(conversationId);
      batch.update(conversationRef, {
        'lastMessage': messageData['text'] ?? 'Sent an attachment',
        'lastMessageTime': messageData['timestamp'] ?? FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  /// Streams the list of active conversations for a given user.
  /// 
  /// STRICT FALLBACK RULE: If the snapshot is empty or throws a database error,
  /// yields mapped conversations from MockDataService to keep UI functional.
  Stream<List<Map<String, dynamic>>> getConversationsStream(String uid) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _getMockConversationsFallback();
      }
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    }).handleError((error) {
      print('Error streaming conversations: $error');
      return _getMockConversationsFallback();
    });
  }

  /// Streams the messages for a specific conversation.
  /// 
  /// STRICT FALLBACK RULE: Yields mock structural messages if the subcollection is empty.
  Stream<List<Map<String, dynamic>>> getMessagesStream(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _getMockMessagesFallback();
      }
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    }).handleError((error) {
      print('Error streaming messages: $error');
      return _getMockMessagesFallback();
    });
  }

  /// Helper method providing the mapped mock fallback data for conversations
  List<Map<String, dynamic>> _getMockConversationsFallback() {
    final mockConversations = MockDataService.getChatConversations();
    return mockConversations.map((conv) {
      return {
        'id': conv.id,
        'otherUserName': conv.otherUser.name,     // UI helper field
        'otherUserAvatar': conv.otherUser.avatar, // UI helper field
        'otherUserVerified': conv.otherUser.isVerified, // UI helper field
        'lastMessage': conv.lastMessage,
        'lastMessageTime': conv.lastMessageTime,
        'unreadCount': conv.unreadCount,
        'category': conv.category,
      };
    }).toList();
  }

  /// Helper method providing the mapped mock fallback data for messages
  List<Map<String, dynamic>> _getMockMessagesFallback() {
    final mockMessages = MockDataService.getChatMessages();
    return mockMessages.map((msg) {
      return {
        'id': msg.id,
        'text': msg.text,
        'isSent': msg.isSent, // UI helper field indicating direction
        'timestamp': msg.timestamp,
        'hasReaction': msg.hasReaction,
        'reaction': msg.reaction,
      };
    }).toList();
  }
}
