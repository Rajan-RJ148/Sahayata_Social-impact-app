import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../services/mock_data_service.dart';
import '../models/user.dart';

/// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = MockDataService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Profile Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.purpleGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: AppColors.textWhite,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              user.avatar ?? '👤',
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Name and Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.name,
                                    style: AppTextStyles.h3.copyWith(
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                  if (user.isVerified) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.verified,
                                      color: AppColors.textWhite,
                                      size: 20,
                                    ),
                                  ],
                                ],
                              ),
                              if (user.memberSince != null)
                                Text(
                                  'Member since ${user.memberSince!.year}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textWhite.withOpacity(0.8),
                                  ),
                                ),
                              if (user.city != null)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: AppColors.textWhite,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      user.city!,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textWhite.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        // Settings
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings, color: AppColors.textWhite),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Statistics Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildStat(
                            icon: Icons.favorite,
                            value: user.peopleHelped.toString(),
                            label: 'People Helped',
                          ),
                        ),
                        Expanded(
                          child: _buildStat(
                            icon: Icons.access_time,
                            value: user.hoursContributed.toString(),
                            label: 'Hours Contributed',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStat(
                            icon: Icons.trending_up,
                            value: user.impactScore.toString(),
                            label: 'Impact Score',
                          ),
                        ),
                        Expanded(
                          child: _buildStat(
                            icon: Icons.speed,
                            value: '${user.avgResponseTime} min',
                            label: 'Avg Response',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Badges Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Badges & Achievements', style: AppTextStyles.h4),
                        Text(
                          '${user.badges.length} / ${AppConfig.badges.length} earned',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: AppConfig.badges.length,
                      itemBuilder: (context, index) {
                        final badge = AppConfig.badges[index];
                        final isEarned = user.badges.contains(badge['name']);
                        return _buildBadgeCard(
                          icon: badge['icon']!,
                          name: badge['name']!,
                          description: badge['description']!,
                          isEarned: isEarned,
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Add bottom safe padding to account for bottom navigation
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textWhite, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textWhite,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textWhite.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required String icon,
    required String name,
    required String description,
    required bool isEarned,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEarned ? AppColors.primary.withOpacity(0.1) : AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEarned ? AppColors.primary.withOpacity(0.3) : AppColors.border,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 32,
              color: isEarned ? null : Colors.grey.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isEarned ? AppColors.textPrimary : AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: isEarned ? AppColors.textSecondary : AppColors.textLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isEarned) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Share',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
