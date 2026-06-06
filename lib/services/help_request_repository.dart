import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data_service.dart';

/*
 * SECTION 3.2 BLUEPRINT: FIRESTORE HELP REQUESTS COLLECTION SCHEMA
 * 
 * Target Collection Path: 'help_requests/{requestId}'
 * 
 * Target Production Fields (13 fields):
 * 1. authorUid (String) - Firebase Auth UID of the creator
 * 2. category (String) - Help category (e.g., Food, Medical)
 * 3. description (String) - Main text content
 * 4. location (GeoPoint) - Exact geographic coordinates
 * 5. locationName (String) - Human-readable address/city
 * 6. imageUrls (List<String>) - Array of Firebase Storage image paths
 * 7. status (String) - Current state (Needy, Helped, etc.)
 * 8. createdAt (Timestamp/String) - Post creation time
 * 9. updatedAt (Timestamp/String) - Last modification time
 * 10. helpersCount (int) - Number of people who responded
 * 11. hasPoll (bool) - Indicates if a poll is attached
 * 12. poll (Map<String, dynamic>) - Embedded poll options and votes
 * 13. geohash (String) - Geo-indexing hash for radius queries
 */

/// Repository handling all Firestore data operations for Help Requests.
class HelpRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new help request document in Firestore.
  Future<void> createHelpRequest(Map<String, dynamic> requestData) async {
    try {
      await _firestore.collection('help_requests').add(requestData);
    } catch (e) {
      print('Error creating help request: $e');
      rethrow;
    }
  }

  /// Streams a filtered list of help requests from Firestore in real-time.
  /// 
  /// STRICT FALLBACK RULE: If the snapshot is empty or throws a collection error,
  /// it gracefully catches the issue and yields a mapped list populated directly 
  /// from the 18 static records inside MockDataService.getHelpRequests().
  Stream<List<Map<String, dynamic>>> getHelpRequestsStream({String? status, String? category}) {
    Query query = _firestore.collection('help_requests');

    if (status != null && status.isNotEmpty && status != 'All') {
      query = query.where('status', isEqualTo: status);
    }
    if (category != null && category.isNotEmpty && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    // Default sorting logic
    query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _getMockFallbackData(status: status, category: category);
      }
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Inject the document ID for UI routing
        return data;
      }).toList();
    }).handleError((error) {
      print('Error streaming help requests: $error');
      // On any stream error (e.g., missing index, permission denied), emit mock data
      return _getMockFallbackData(status: status, category: category);
    });
  }

  /// Helper method providing the mapped mock fallback data payload
  List<Map<String, dynamic>> _getMockFallbackData({String? status, String? category}) {
    // Fetch the 18 static records
    var mockRequests = MockDataService.getHelpRequests();

    // Apply basic filtering to simulate the query
    if (status != null && status.isNotEmpty && status != 'All') {
      mockRequests = mockRequests.where((req) => req.status == status).toList();
    }
    if (category != null && category.isNotEmpty && category != 'All') {
      mockRequests = mockRequests.where((req) => req.category == category).toList();
    }

    // Map the HelpRequest objects into Maps matching the target schema closely
    return mockRequests.map((req) {
      return {
        'id': req.id,
        'authorUid': req.authorId,
        'authorName': req.author, // Structural UI helper field
        'authorAvatar': req.authorAvatar, // Structural UI helper field
        'category': req.category,
        'description': req.description,
        'location': null, // Map to GeoPoint in actual production
        'locationName': req.location,
        'imageUrls': req.imageUrls,
        'status': req.status,
        'createdAt': req.timePosted,
        'updatedAt': req.timePosted,
        'helpersCount': req.helpersCount,
        'hasPoll': req.poll != null,
        'poll': req.poll != null
            ? {
                'question': req.poll!.question,
                'options': req.poll!.options,
                'votes': req.poll!.votes,
              }
            : null,
        'geohash': null,
        'distance': req.distance, // Structural UI helper field
      };
    }).toList();
  }
}
