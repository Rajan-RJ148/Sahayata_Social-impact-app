import 'package:flutter/material.dart';

/// Simple state management for the app
class AppState extends ChangeNotifier {
  Set<String> _registeredEventIds = {};
  
  Set<String> get registeredEventIds => _registeredEventIds;
  
  bool isRegistered(String eventId) {
    return _registeredEventIds.contains(eventId);
  }
  
  void registerForEvent(String eventId) {
    _registeredEventIds.add(eventId);
    notifyListeners();
  }
  
  void unregisterFromEvent(String eventId) {
    _registeredEventIds.remove(eventId);
    notifyListeners();
  }
}
