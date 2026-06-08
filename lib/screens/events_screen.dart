import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/helpers.dart';
import '../services/app_state.dart';
import '../services/event_repository.dart';
import '../models/event.dart';
import '../widgets/create_help_request_modal.dart';
import '../widgets/create_event_modal.dart';

/// Events Screen with Registration Functionality
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppConfig.appName, style: AppTextStyles.h4),
                  ElevatedButton.icon(
                    onPressed: () => showCreateHelpRequestModal(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Post Help Request'),
                  ),
                ],
              ),
            ),
            
            // Title and Create Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Community Events', style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text(
                    'Organize & participate in community drives',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => showCreateEventModal(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Event'),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Upcoming Events'),
                Tab(text: 'My Registrations'),
              ],
            ),
            
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Upcoming Events
                  _buildEventsList(showAll: true),
                  // My Registrations
                  _buildEventsList(showAll: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList({required bool showAll}) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: EventRepository().getEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.event_busy,
                  size: 64,
                  color: AppColors.textLight,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Events Found',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return Consumer<AppState>(
          builder: (context, appState, child) {
            // Map the raw Firestore dictionary back to our UI CommunityEvent structure
            final List<CommunityEvent> allMappedEvents = snapshot.data!.map((event) {
              return CommunityEvent(
                id: event['id'] ?? '',
                organizerId: event['organizerUid'] ?? '',
                organizer: event['organizerName'] ?? 'Unknown',
                organizerAvatar: event['organizerAvatar'] ?? '👤',
                title: event['title'] ?? '',
                description: event['description'] ?? '',
                date: event['date'] is DateTime 
                    ? event['date'] 
                    : (event['date'] is Timestamp ? event['date'].toDate() : DateTime.now()),
                time: event['time'],
                location: event['locationName'] ?? 'Unknown Location',
                volunteersNeeded: event['volunteersNeeded'] ?? 0,
                volunteersRegistered: event['volunteersRegistered'] ?? 0,
                imageUrl: event['imageUrl'],
                isNGOVerified: event['isNGOVerified'] ?? false,
                category: event['category'] ?? 'General',
              );
            }).toList();

            final events = showAll
                ? allMappedEvents
                : allMappedEvents.where((e) => appState.isRegistered(e.id)).toList();

            if (!showAll && events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.event_busy,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Registrations Yet',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Register for events to see them here',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return _buildEventCard(events[index], appState);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEventCard(CommunityEvent event, AppState appState) {
    final isGradient = event.id == '1';
    final isRegistered = appState.isRegistered(event.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: isGradient ? AppColors.pinkGradient : null,
        color: isGradient ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isGradient) ...[ 
              // Gradient Card Style
              Row(
                children: [
                  const Text('🧥', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textWhite.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: AppColors.textWhite.withOpacity(0.9)),
                  const SizedBox(width: 4),
                  Text(
                    'Dec 15-20',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textWhite.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 14, color: AppColors.textWhite.withOpacity(0.9)),
                  const SizedBox(width: 4),
                  Text(
                    '${event.volunteersRegistered} volunteers',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textWhite.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Regular Card Style
              if (event.isNGOVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        'NGO Verified',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              if (event.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    event.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        color: AppColors.backgroundGray,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 48,
                            color: AppColors.textLight,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              Text(event.title, style: AppTextStyles.h4),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              _buildEventDetail(Icons.calendar_today, Helpers.formatDate(event.date)),
              if (event.time != null) ...[
                const SizedBox(height: 8),
                _buildEventDetail(Icons.access_time, event.time!),
              ],
              const SizedBox(height: 8),
              _buildEventDetail(Icons.location_on, event.location),
              const SizedBox(height: 8),
              _buildEventDetail(Icons.people, event.volunteerStatus),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: event.isFull
                      ? null
                      : () {
                          if (isRegistered) {
                            appState.unregisterFromEvent(event.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Unregistered from ${event.title}'),
                                backgroundColor: AppColors.textSecondary,
                              ),
                            );
                          } else {
                            // Wire the backend logic first
                            EventRepository().registerForEvent(
                              event.id, 
                              FirebaseAuth.instance.currentUser?.uid ?? '',
                            );
                            // Followed by optimistic UI update
                            appState.registerForEvent(event.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registered for ${event.title}!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        },
                  icon: Icon(
                    isRegistered ? Icons.check_circle : Icons.person_add,
                  ),
                  label: Text(
                    event.isFull
                        ? 'Event Full'
                        : isRegistered
                            ? 'Registered'
                            : 'Register as Volunteer',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRegistered
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
