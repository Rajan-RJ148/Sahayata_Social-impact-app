import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../config/app_config.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../services/mock_data_service.dart';
import '../widgets/create_help_request_modal.dart';

/// Enhanced Impact Dashboard Screen with Analytics
class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = MockDataService.getImpactStats();

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
                    Text(AppConfig.appName, style: AppTextStyles.h3),
                    ElevatedButton.icon(
                      onPressed: () => showCreateHelpRequestModal(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Post Help Request'),
                    ),
                  ],
                ),
              ),
              
              // Community Impact Dashboard Header
              _buildImpactDashboardHeader(),
              
              // Summary Stats Cards Row
              _buildSummaryStatsRow(stats),

              // Monthly Trend Chart
              _buildMonthlyTrendSection(),
              
              // Help by Category (Donut Chart)
              _buildCategoryChart(),
              
              // Community Need Density (Bar Chart)
              _buildCommunityDensityChart(),
              
              // Top Contributors
              _buildLeaderboardSection(),
              
              // Recent Success Stories
              _buildSuccessStoriesSection(),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactDashboardHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Impact Dashboard',
            style: AppTextStyles.h2.copyWith(color: AppColors.textWhite),
          ),
          const SizedBox(height: 8),
          Text(
            'Real-time statistics of our collective impact',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textWhite.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStatsRow(Map<String, dynamic> stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.favorite_outline,
                  value: stats['totalHelps'].toString(),
                  label: 'Total Helps',
                  color: AppColors.urgent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.people_outline,
                  value: stats['activeVolunteers'].toString(),
                  label: 'Active Volunteers',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.access_time,
                  value: stats['hoursContributed'].toString(),
                  label: 'Hours Contributed',
                  color: AppColors.upcoming,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.location_on_outlined,
                  value: stats['citiesReached'].toString(),
                  label: 'Cities Reached',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Icon(Icons.trending_up, color: AppColors.secondary, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Help Trend', style: AppTextStyles.h4),
          const SizedBox(height: 24),
          // Simple line chart
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: LineChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart() {
    final categories = [
      {'name': 'Food', 'value': 450, 'color': AppColors.primary},
      {'name': 'Medical', 'value': 280, 'color': AppColors.urgent},
      {'name': 'Shelter', 'value': 210, 'color': AppColors.categoryShelter},
      {'name': 'Clothing', 'value': 180, 'color': AppColors.success},
      {'name': 'Education', 'value': 128, 'color': AppColors.upcoming},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Help by Category', style: AppTextStyles.h4),
          const SizedBox(height: 24),
          // Donut Chart
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: CustomPaint(
                size: const Size(200, 200),
                painter: DonutChartPainter(categories: categories),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: categories.map((cat) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: cat['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${cat['name']}: ${cat['value']}',
                    style: AppTextStyles.caption,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityDensityChart() {
    final cities = [
      {'name': 'Andheri', 'value': 45},
      {'name': 'Bandra', 'value': 38},
      {'name': 'Dadar', 'value': 52},
      {'name': 'Powai', 'value': 28},
      {'name': 'Thane', 'value': 35},
    ];
    final maxValue = 60.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Community Need Density', style: AppTextStyles.h4),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cities.map((city) {
                return _buildDensityBar(
                  city['name'] as String,
                  (city['value'] as int).toDouble(),
                  maxValue,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDensityBar(String name, double value, double maxValue) {
    final percentage = value / maxValue;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Value label
            Text(
              value.toInt().toString(),
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Bar
            Container(
              width: double.infinity,
              height: 150 * percentage,
              decoration: BoxDecoration(
                color: AppColors.upcoming,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // City label
            Text(
              name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    final leaderboard = MockDataService.getLeaderboard();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Top Contributors This Month', style: AppTextStyles.h4),
              const SizedBox(width: 8),
              const Text('🏆', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 16),
          ...leaderboard.map((entry) {
            return _buildLeaderboardItem(
              rank: entry['rank'],
              user: entry['user'],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem({required int rank, required user}) {
    final medals = {'1': '🥇', '2': '🥈', '3': '🥉', '4': '⭐', '5': '⭐'};
    final medal = medals[rank.toString()] ?? '⭐';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(medal, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.avatar ?? '👤',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${user.peopleHelped} people helped',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Rank #$rank',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStoriesSection() {
    final stories = [
      {
        'text': '"Thanks to the HelpConnect community, I received warm meals for a week during difficult times. Forever grateful! 🙏"',
        'author': 'Anonymous, Andheri',
        'time': '2 days ago',
      },
      {
        'text': '"Our NGO partnered with HelpConnect for winter clothing drive. We collected 500+ items in just one week!"',
        'author': 'Hope Foundation',
        'time': '5 days ago',
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: Text('Recent Success Stories', style: AppTextStyles.h4),
          ),
          ...stories.map((story) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story['text'] as String,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '- ${story['author']} • ${story['time']}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Line Chart Painter
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.45),
      Offset(size.width * 0.4, size.height * 0.30),
      Offset(size.width * 0.6, size.height * 0.20),
      Offset(size.width * 0.8, size.height * 0.10),
      Offset(size.width, size.height * 0.05),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }

    // Draw month labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    for (int i = 0; i < months.length; i++) {
      textPainter.text = TextSpan(
        text: months[i],
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          size.width * (i / 5) - textPainter.width / 2,
          size.height - 20,
        ),
      );
    }

    // Draw y-axis labels
    final values = ['0', '55', '110', '165', '220'];
    for (int i = 0; i < values.length; i++) {
      textPainter.text = TextSpan(
        text: values[i],
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          0,
          size.height - (size.height * 0.25 * i) - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Donut Chart Painter
class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> categories;

  DonutChartPainter({required this.categories});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final innerRadius = radius * 0.6;

    final total = categories.fold<double>(
      0,
      (sum, cat) => sum + (cat['value'] as int).toDouble(),
    );

    double startAngle = -math.pi / 2;

    for (final category in categories) {
      final value = (category['value'] as int).toDouble();
      final sweepAngle = (value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = category['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius - innerRadius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (radius + innerRadius) / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
