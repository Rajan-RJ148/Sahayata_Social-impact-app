# HelpConnect - Connecting Hearts, Changing Lives

A Flutter-based community compassion app that connects people in need with those who can help. Built to facilitate location-based help requests, real-time notifications, and community engagement.

## 📱 About

HelpConnect is a social impact application designed to help needy individuals (like roadside beggars and those in difficult situations) by connecting them with compassionate community members who can provide assistance in various forms - food, medical aid, shelter, clothing, financial support, or time.

## ✨ Features

### Core Features
- **Location-Based Help Requests**: Post and discover help requests within a configurable radius (500m-10km)
- **Real-Time Feed**: Browse help requests with filters (All Posts, Needy, Helped, Upcoming Events)
- **Category System**: Organize requests by Food, Medical, Shelter, Clothing, Financial, Education
- **"I Can Help" Response System**: Connect helpers with those in need
- **Anonymous Chat**: Secure messaging with privacy protection
- **Community Events**: Organize and participate in food drives, clothing collections, and more
- **Impact Dashboard**: Track community statistics and your personal impact
- **Achievement Badges**: Earn recognition for helping (First Help, Food Helper, Quick Responder, SEWADAAR, etc.)
- **NGO Verification**: Verified badges for registered organizations
- **Community Polls**: Let the community decide on help details

### User Features
- **Profile Statistics**: Track people helped, hours contributed, impact score, and average response time
- **Badge Sharing**: Share achievements on social media (WhatsApp, Facebook, Twitter, LinkedIn, Instagram, Telegram)
- **Leaderboard**: See top contributors in the community
- **Success Stories**: Read and share inspiring stories of help provided

### Safety Features
- **Anonymous Contact**: Phone numbers stay private until you choose to share
- **Safety Guidelines**: Built-in precautions and best practices
- **Report & Block**: Tools to report suspicious activity
- **Public Meeting Recommendations**: Always meet in well-lit, public areas

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/helpconnect_app.git
   cd helpconnect_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── config/
│   ├── app_config.dart      # App configuration (CHANGE APP NAME HERE)
│   └── theme.dart            # App theme and styling
├── models/
│   ├── user.dart             # User data model
│   ├── help_request.dart     # Help request model
│   ├── event.dart            # Community event model
│   └── chat.dart             # Chat models
├── screens/
│   ├── onboarding_screen.dart
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── events_screen.dart
│   ├── chat_list_screen.dart
│   └── impact_screen.dart
├── widgets/
│   ├── bottom_nav_bar.dart
│   ├── post_card.dart
│   └── custom_button.dart
├── services/
│   └── mock_data_service.dart  # Sample data for testing
├── utils/
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   └── helpers.dart
└── main.dart
```

## 🎨 Customization

### Changing the App Name

The app name is centralized in `lib/config/app_config.dart`:

```dart
class AppConfig {
  static const String appName = 'HelpConnect';  // CHANGE THIS
  static const String appTagline = 'Connecting Hearts, Changing Lives';  // AND THIS
  // ... rest of config
}
```

Simply modify these constants to change the app name throughout the entire application!

### Customizing Colors

All colors are defined in `lib/utils/app_colors.dart`. Modify the color constants to match your brand.

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Google Fonts**: Inter font family
- **FL Chart**: Beautiful charts for analytics
- **Geolocator**: Location services
- **Image Picker**: Photo uploads
- **Provider**: State management
- **Share Plus**: Social media sharing

## 📸 Screenshots

[Screenshots of your app will be added here]

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Designed with compassion for helping those in need
- Inspired by the power of community and human kindness
- Built to make a difference in people's lives

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

**Made with ❤️ for making the world a better place**
