import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data_service.dart';

/*
 * SECTION 3.3 BLUEPRINT: FIRESTORE COMMUNITY EVENTS COLLECTION SCHEMA
 * 
 * Target Collection Path: 'events/{eventId}'
 * 
 * Target Production Fields (13 fields):
 * 1. organizerUid (String) - Firebase Auth UID of the event creator
 * 2. title (String) - Name of the event
 * 3. description (String) - Detailed event information
 * 4. date (Timestamp/String) - Date of the event
 * 5. time (String) - Time string (e.g., "10:00 AM")
 * 6. location (GeoPoint) - Exact geographic coordinates
 * 7. locationName (String) - Human-readable address
 * 8. volunteersNeeded (int) - Target number of volunteers
 * 9. volunteersRegistered (int) - Current number of volunteers
 * 10. imageUrl (String) - Firebase Storage image path
 * 11. isNGOVerified (bool) - Indicates if organized by a verified NGO
 * 12. category (String) - Event category (e.g., Environment, Education)
 * 13. createdAt (Timestamp/String) - Post creation time
 */

/// Repository handling all Firestore data operations for Community Events.
class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Registers a user for a specific event by incrementing the volunteer count.
  Future<void> registerForEvent(String eventId, String uid) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'volunteersRegistered': FieldValue.increment(1),
        // In a full production implementation, we could also append the UID to an array
        // 'registeredUids': FieldValue.arrayUnion([uid])
      });
    } catch (e) {
      print('Error registering for event: $e');
      rethrow;
    }
  }

  /// Streams the list of upcoming events from Firestore in real-time.
  /// 
  /// STRICT FALLBACK RULE: If the snapshot is empty or throws a database connection
  /// error, it gracefully intercepts it and yields a mapped list populated directly 
  /// from the 10 hardcoded event records inside MockDataService.getCommunityEvents().
  Stream<List<Map<String, dynamic>>> getEventsStream() {
    return _firestore
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _getMockFallbackData();
      }
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Inject the document ID for UI routing
        return data;
      }).toList();
    }).handleError((error) {
      print('Error streaming events: $error');
      // On any stream error (e.g., missing index, permission denied), emit mock data
      return _getMockFallbackData();
    });
  }

  /// Helper method providing the mapped mock fallback data payload
  List<Map<String, dynamic>> _getMockFallbackData() {
    // Fetch the 10 static records from our mock service
    final mockEvents = MockDataService.getCommunityEvents();

    // Map the CommunityEvent objects into Maps matching the target schema closely
    return mockEvents.map((event) {
      return {
        'id': event.id,
        'organizerUid': event.organizerId,
        'organizerName': event.organizer, // Structural UI helper field
        'organizerAvatar': event.organizerAvatar, // Structural UI helper field
        'title': event.title,
        'description': event.description,
        'date': event.date,
        'time': event.time,
        'location': null, // Map to GeoPoint in actual production
        'locationName': event.location,
        'volunteersNeeded': event.volunteersNeeded,
        'volunteersRegistered': event.volunteersRegistered,
        'imageUrl': event.imageUrl,
        'isNGOVerified': event.isNGOVerified,
        'category': event.category,
        'createdAt': event.date, // Approximation for mock fallback
      };
    }).toList();
  }
}
