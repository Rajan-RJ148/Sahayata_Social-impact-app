/// Event Model
class CommunityEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? time;
  final String location;
  final int volunteersNeeded;
  final int volunteersRegistered;
  final String? imageUrl;
  final bool isNGOVerified;
  final String category; // 'food', 'clothing', 'medical', etc.

  CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.time,
    required this.location,
    required this.volunteersNeeded,
    this.volunteersRegistered = 0,
    this.imageUrl,
    this.isNGOVerified = false,
    required this.category,
  });
  
  bool get isFull => volunteersRegistered >= volunteersNeeded;
  
  String get volunteerStatus => '$volunteersRegistered / $volunteersNeeded volunteers';
}
