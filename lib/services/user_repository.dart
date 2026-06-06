import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data_service.dart';

/*
 * SECTION 3.1 BLUEPRINT: FIRESTORE USERS COLLECTION SCHEMA
 * 
 * This repository is the definitive source of truth for the User domain,
 * writing to and reading from the 'users/{uid}' document path.
 * 
 * Target Production Fields (16 target fields):
 * 1. uid (String) - Firebase Auth User ID
 * 2. displayName (String) - Full name of the user
 * 3. email (String) - Email address
 * 4. phone (String) - Phone number (optional if email auth)
 * 5. avatarUrl (String) - Storage URL for profile picture
 * 6. isVerified (bool) - Verification status flag
 * 7. isNGO (bool) - True if registered as an NGO/Organization
 * 8. city (String) - Primary operating city
 * 9. memberSince (Timestamp/String) - Account creation date
 * 10. peopleHelped (int) - Analytics counter for total helps
 * 11. hoursContributed (int) - Analytics counter for hours
 * 12. impactScore (int) - Gamification reputation score
 * 13. avgResponseTime (String) - Performance metric
 * 14. earnedBadges (List<String>) - Array of earned badge IDs
 * 15. fcmToken (String) - Firebase Cloud Messaging token for push notifications
 * 16. location (GeoPoint) - Exact geographic coordinates
 */

/// Repository handling all Firestore data operations for the User domain.
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new user document in Firestore upon successful registration.
  Future<void> createUserDocument(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).set(
            data,
            SetOptions(merge: true),
          );
    } catch (e) {
      print('Error creating user document: $e');
      rethrow;
    }
  }

  /// Streams the user document from Firestore in real-time.
  /// 
  /// STRICT FALLBACK RULE: If the document does not exist, has an error, 
  /// or is completely empty, it yields a mapped version of the static 
  /// MockDataService.currentUser so UI screens never break during early migration.
  Stream<Map<String, dynamic>> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null || snapshot.data()!.isEmpty) {
        return _getMockFallbackData();
      }
      return snapshot.data()!;
    }).handleError((error) {
      print('Error streaming user document ($uid): $error');
      // On any stream error, emit the fallback mock data map
      return _getMockFallbackData();
    });
  }

  /// Helper method providing the mapped mock fallback data payload
  Map<String, dynamic> _getMockFallbackData() {
    final mockUser = MockDataService.currentUser;
    return {
      'uid': mockUser.id,
      'displayName': mockUser.name,
      'email': 'mock.user@sahayata.app', // Fallback structural field
      'phone': '+91 9876543210',         // Fallback structural field
      'avatarUrl': mockUser.avatar,
      'isVerified': mockUser.isVerified,
      'isNGO': mockUser.isNGO,
      'city': mockUser.city,
      'memberSince': mockUser.memberSince,
      'peopleHelped': mockUser.peopleHelped,
      'hoursContributed': mockUser.hoursContributed,
      'impactScore': mockUser.impactScore,
      'avgResponseTime': mockUser.avgResponseTime,
      'earnedBadges': mockUser.earnedBadges,
      'fcmToken': null,
      'location': null,
    };
  }
}
