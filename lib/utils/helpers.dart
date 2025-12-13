import 'package:intl/intl.dart';

/// Helper Functions
class Helpers {
  /// Format distance in km
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toInt()}m away';
    }
    return '${distanceInKm.toStringAsFixed(1)} km away';
  }
  
  /// Format time ago
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }
  
  /// Format date
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }
  
  /// Format time
  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
  
  /// Format date range
  static String formatDateRange(DateTime start, DateTime end) {
    final startStr = DateFormat('MMM d').format(start);
    final endStr = DateFormat('d').format(end);
    return '$startStr-$endStr';
  }
  
  /// Get category color name
  static String getCategoryColor(String category) {
    final colors = {
      'Food': 'blue',
      'Medical': 'red',
      'Shelter': 'orange',
      'Clothing': 'green',
      'Financial': 'purple',
      'Education': 'indigo',
    };
    return colors[category] ?? 'blue';
  }
}
