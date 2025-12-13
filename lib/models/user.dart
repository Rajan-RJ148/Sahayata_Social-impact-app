/// User Model
class User {
  final String id;
  final String name;
  final String? avatar;
  final bool isVerified;
  final bool isNGO;
  final String? city;
  final DateTime? memberSince;
  
  // Statistics
  final int peopleHelped;
  final int hoursContributed;
  final int impactScore;
  final int avgResponseTime; // in minutes
  
  // Badges
  final List<String> badges;

  User({
    required this.id,
    required this.name,
    this.avatar,
    this.isVerified = false,
    this.isNGO = false,
    this.city,
    this.memberSince,
    this.peopleHelped = 0,
    this.hoursContributed = 0,
    this.impactScore = 0,
    this.avgResponseTime = 0,
    this.badges = const [],
  });
}
