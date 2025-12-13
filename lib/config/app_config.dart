/// App Configuration
/// This file contains all configurable constants for the app
class AppConfig {
  // App Identity - EASILY CHANGEABLE
  static const String appName = 'HelpConnect';
  static const String appTagline = 'Connecting Hearts, Changing Lives';
  
  // Version
  static const String version = '1.0.0';
  
  // Radius Options (in meters)
  static const double minRadius = 500;
  static const double maxRadius = 10000;
  static const double defaultRadius = 5000;
  
  // Categories
  static const List<String> categories = [
    'Food',
    'Medical',
    'Shelter',
    'Clothing',
    'Financial',
    'Education',
  ];
  
  // Category Icons (emoji)
  static const Map<String, String> categoryIcons = {
    'Food': '🍔',
    'Medical': '🏥',
    'Shelter': '🏠',
    'Clothing': '👕',
    'Financial': '💰',
    'Education': '📚',
  };
  
  // Post Status
  static const String statusNeedy = 'Needy';
  static const String statusHelped = 'Helped';
  static const String statusUpcoming = 'Upcoming';
  
  // Badges
  static const List<Map<String, String>> badges = [
    {'name': 'First Help', 'icon': '☀️', 'description': 'Helped your first person'},
    {'name': 'Food Helper', 'icon': '🎀', 'description': 'Provided food assistance 10 times'},
    {'name': 'Quick Responder', 'icon': '⚡', 'description': 'Average response time under 30 min'},
    {'name': 'Community Leader', 'icon': '👑', 'description': 'Organized 5 community events'},
    {'name': 'SEWADAAR', 'icon': '🤝', 'description': 'Dedicated volunteer with 50+ helps'},
    {'name': 'Medical Hero', 'icon': '🧩', 'description': 'Provided medical assistance'},
  ];
  
  // Social Media Share Template
  static String getBadgeShareMessage(String badgeName, String userName) {
    return '🎉 I just earned the \'$badgeName\' badge on $appName! '
        'Join me in making a difference in our community. '
        '#$appName #CommunityImpact 🙏\n\n'
        'View my profile: https://helpconnect.app/profile/$userName';
  }
  
  // Safety Guidelines
  static const List<String> safetyGuidelines = [
    'Always meet in public, well-lit areas',
    'Verify the authenticity of help requests',
    'Never share personal financial information',
    'Report suspicious activity immediately',
    'Trust your instincts - safety first',
  ];
}
