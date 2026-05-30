import 'package:flutter/material.dart';
import '../models/help_request.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/helpers.dart';
import '../config/app_config.dart';

/// Enhanced Post Card Widget matching new design
class PostCard extends StatelessWidget {
  final HelpRequest request;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.request,
    this.onTap,
  });

  Color get _statusColor {
    switch (request.status) {
      case 'Needy':
        return AppColors.urgent;
      case 'Helped':
        return AppColors.success;
      case 'Upcoming':
        return AppColors.upcoming;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Row
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        request.user.avatar ?? '👤',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and Time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              request.user.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (request.user.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                size: 16,
                                color: AppColors.verified,
                              ),
                            ],
                            if (request.user.isNGO) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'NGO',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              Helpers.formatTimeAgo(request.timestamp),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (request.distance != null) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                Helpers.formatDistance(request.distance!),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // More icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Status and Category Row
              Row(
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.status,
                      style: AppTextStyles.badge.copyWith(
                        color: _statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${AppConfig.categoryIcons[request.category]} ${request.category.toLowerCase()}',
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                request.description,
                style: AppTextStyles.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Location
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.location,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Click to view on map',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              
              // Image (if available)
              if (request.imageUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    request.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
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
              ],
              
              // Poll Link (if available)
              if (request.hasPoll) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.poll, size: 16),
                  label: const Text('View Community Poll'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
              
              // Helpers Count (if any)
              if (request.helpersCount > 0) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: 16,
                      color: AppColors.urgent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${request.helpersCount} helpers',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Action Buttons (only for Needy status)
              if (request.status == 'Needy') ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite, size: 18),
                        label: const Text('I Can Help'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
