import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/helpers.dart';
import '../services/mock_data_service.dart';
import '../models/event.dart';

/// Events Screen
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = MockDataService.getEvents();

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
                    onPressed: () {},
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
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Create Event'),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(text: 'Upcoming Events'),
                      Tab(text: 'My Registrations'),
                    ],
                  ),
                ],
              ),
            ),
            
            // Events List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return _buildEventCard(events[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(CommunityEvent event) {
    final isGradient = event.id == '1';
    
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
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 48, color: AppColors.textLight),
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
                child: ElevatedButton(
                  onPressed: event.isFull ? null : () {},
                  child: Text(event.isFull ? 'Event Full' : 'Register as Volunteer'),
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
