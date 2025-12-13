import 'user.dart';

/// Help Request Model
class HelpRequest {
  final String id;
  final User user;
  final String category;
  final String description;
  final String location;
  final String? imageUrl;
  final DateTime timestamp;
  final String status; // 'Needy', 'Helped', 'Upcoming'
  final double? distance; // in km
  final int helpersCount;
  final bool hasPoll;
  final Poll? poll;

  HelpRequest({
    required this.id,
    required this.user,
    required this.category,
    required this.description,
    required this.location,
    this.imageUrl,
    required this.timestamp,
    required this.status,
    this.distance,
    this.helpersCount = 0,
    this.hasPoll = false,
    this.poll,
  });
}

/// Poll Model
class Poll {
  final String question;
  final List<PollOption> options;

  Poll({
    required this.question,
    required this.options,
  });
}

/// Poll Option Model
class PollOption {
  final String text;
  final int votes;

  PollOption({
    required this.text,
    this.votes = 0,
  });
}
