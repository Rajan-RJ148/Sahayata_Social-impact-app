import '../models/user.dart';
import '../models/help_request.dart';
import '../models/event.dart';
import '../models/chat.dart';

/// Mock Data Service
/// Provides sample data for testing the UI
class MockDataService {
  // Mock Users
  static final User currentUser = User(
    id: '1',
    name: 'Rahul Sharma',
    avatar: '👨',
    isVerified: true,
    city: 'Mumbai, Maharashtra',
    memberSince: DateTime(2024, 1, 1),
    peopleHelped: 42,
    hoursContributed: 128,
    impactScore: 850,
    avgResponseTime: 15,
    badges: ['First Help', 'Food Helper', 'Quick Responder', 'SEWADAAR'],
  );
  
  static final List<User> users = [
    User(id: '2', name: 'Amit Kumar', avatar: '👨', isVerified: true, peopleHelped: 67),
    User(id: '3', name: 'Priya Sharma', avatar: '👩', isVerified: false, peopleHelped: 58),
    User(id: '4', name: 'Medical Aid NGO', avatar: '🏥', isVerified: true, isNGO: true),
    User(id: '5', name: 'Hope Foundation', avatar: '💙', isVerified: true, isNGO: true),
    User(id: '6', name: 'Anonymous User', avatar: '👤', isVerified: true),
  ];
  
  // Mock Help Requests
  static List<HelpRequest> getHelpRequests() {
    return [
      HelpRequest(
        id: '1',
        user: users[0],
        category: 'Food',
        description: 'Elderly person near Station Road needs food and medical assistance. Very urgent situation.',
        location: 'Station Road, Andheri East, Mumbai',
        imageUrl: 'assets/images/help1.jpg',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        status: 'Needy',
        distance: 1.2,
        helpersCount: 0,
      ),
      HelpRequest(
        id: '2',
        user: users[1],
        category: 'Food',
        description: 'Successfully distributed 50 food packets to street vendors. Thank you to all volunteers who helped! 🙏',
        location: 'Dadar, Mumbai',
        imageUrl: 'assets/images/help2.jpg',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        status: 'Helped',
        distance: 2.8,
        helpersCount: 12,
      ),
      HelpRequest(
        id: '3',
        user: users[3],
        category: 'Medical',
        description: 'Free medical camp this Sunday at Powai Community Center. Bring your family for checkups!',
        location: 'Powai, Mumbai',
        imageUrl: 'assets/images/medical.jpg',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Upcoming',
        distance: 5.2,
        helpersCount: 8,
        hasPoll: true,
        poll: Poll(
          question: 'What time works best?',
          options: [
            PollOption(text: '9 AM - 12 PM', votes: 15),
            PollOption(text: '2 PM - 5 PM', votes: 23),
          ],
        ),
      ),
    ];
  }
  
  // Mock Events
  static List<CommunityEvent> getEvents() {
    return [
      CommunityEvent(
        id: '1',
        title: 'Winter Clothing Drive',
        description: 'Help us collect warm clothes for those in need this winter',
        date: DateTime(2024, 12, 15),
        time: null,
        location: 'Various locations',
        volunteersNeeded: 234,
        volunteersRegistered: 234,
        category: 'clothing',
      ),
      CommunityEvent(
        id: '2',
        title: 'Community Food Drive',
        description: 'Join us in collecting and distributing food to those in need',
        date: DateTime(2024, 12, 15),
        time: '10:00 AM - 4:00 PM',
        location: 'Andheri Community Center',
        volunteersNeeded: 60,
        volunteersRegistered: 45,
        imageUrl: 'assets/images/food_drive.jpg',
        isNGOVerified: true,
        category: 'food',
      ),
    ];
  }
  
  // Mock Chat Conversations
  static List<ChatConversation> getChatConversations() {
    return [
      ChatConversation(
        id: '1',
        otherUser: users[5],
        lastMessage: 'Thank you so much for your help!',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
        unreadCount: 3,
        category: 'food help',
      ),
      ChatConversation(
        id: '2',
        otherUser: users[4],
        lastMessage: 'We appreciate your contribution',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
        category: 'medical help',
      ),
      ChatConversation(
        id: '3',
        otherUser: users[5],
        lastMessage: 'When can we meet?',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 1,
        category: 'clothing help',
      ),
    ];
  }
  
  // Mock Chat Messages
  static List<ChatMessage> getChatMessages() {
    return [
      ChatMessage(
        id: '1',
        text: 'Hi! I saw your post about needing food assistance.',
        isSent: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
      ChatMessage(
        id: '2',
        text: 'Yes, thank you for reaching out!',
        isSent: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        hasReaction: true,
        reaction: '👍',
      ),
      ChatMessage(
        id: '3',
        text: 'I can bring some groceries today around 3 PM. Does that work?',
        isSent: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      ChatMessage(
        id: '4',
        text: 'That would be wonderful! The location is near Station Road.',
        isSent: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        hasReaction: true,
        reaction: '👍',
      ),
      ChatMessage(
        id: '5',
        text: 'Perfect! See you then 🙏',
        isSent: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }
  
  // Mock Impact Stats
  static Map<String, dynamic> getImpactStats() {
    return {
      'totalHelps': 1248,
      'activeVolunteers': 342,
      'hoursContributed': 4567,
      'citiesReached': 12,
      'monthlyTrend': [
        {'month': 'Jul', 'helps': 95},
        {'month': 'Aug', 'helps': 120},
        {'month': 'Sep', 'helps': 145},
        {'month': 'Oct', 'helps': 175},
        {'month': 'Nov', 'helps': 200},
        {'month': 'Dec', 'helps': 220},
      ],
      'categoryDistribution': {
        'Food': 450,
        'Medical': 280,
        'Shelter': 210,
        'Clothing': 180,
        'Education': 128,
      },
      'needDensity': {
        'Andheri': 45,
        'Bandra': 35,
        'Dadar': 55,
        'Powai': 30,
        'Thane': 35,
      },
    };
  }
  
  // Mock Leaderboard
  static List<Map<String, dynamic>> getLeaderboard() {
    return [
      {'user': User(id: '1', name: 'Priya Patel', avatar: '👩', peopleHelped: 67), 'rank': 1},
      {'user': User(id: '2', name: 'Amit Kumar', avatar: '👨', peopleHelped: 58), 'rank': 2},
      {'user': User(id: '3', name: 'Sneha Reddy', avatar: '👩', peopleHelped: 52), 'rank': 3},
      {'user': User(id: '4', name: 'Raj Sharma', avatar: '👨', peopleHelped: 48), 'rank': 4},
      {'user': User(id: '5', name: 'Maya Singh', avatar: '👩', peopleHelped: 45), 'rank': 5},
    ];
  }
  
  // Mock Success Stories
  static List<Map<String, String>> getSuccessStories() {
    return [
      {
        'text': 'Thanks to the HelpConnect community, I received warm meals for a week during difficult times. Forever grateful! 🙏',
        'author': 'Anonymous, Andheri',
        'time': '2 days ago',
      },
      {
        'text': 'Our NGO partnered with HelpConnect for winter clothing drive. We collected 500+ items in just one week!',
        'author': 'Hope Foundation',
        'time': '5 days ago',
      },
    ];
  }
}
