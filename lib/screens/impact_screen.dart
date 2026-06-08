import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('analytics').doc('global').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final data = snapshot.hasData && snapshot.data!.exists 
                ? (snapshot.data!.data() as Map<String, dynamic>?) 
                : null;
                
            // Strict Fallback Constraint
            final stats = data ?? MockDataService.getImpactStats();

            return SingleChildScrollView(
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
                  _buildMonthlyTrendSection(stats['monthlyTrend'] as List<dynamic>?),
                  
                  // Help by Category (Donut Chart)
                  _buildCategoryChart(stats['categoryDistribution'] as Map<String, dynamic>?),
                  
                  // Community Need Density (Bar Chart)
                  _buildCommunityDensityChart(stats['needDensity'] as Map<String, dynamic>?),
                  
                  // Top Contributors
                  _buildLeaderboardSection(),
                  
                  // Recent Success Stories
                  _buildSuccessStoriesSection(),
                  
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
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
                  value: (stats['totalHelps'] ?? 0).toString(),
                  label: 'Total Helps',
                  color: AppColors.urgent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.people_outline,
                  value: (stats['activeVolunteers'] ?? 0).toString(),
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
                  value: (stats['hoursContributed'] ?? 0).toString(),
                  label: 'Hours Contributed',
                  color: AppColors.upcoming,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.location_on_outlined,
                  value: (stats['citiesReached'] ?? 0).toString(),
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

  Widget _buildMonthlyTrendSection(List<dynamic>? trendData) {
    // If not provided from firestore mapping, fallback locally
    final defaultTrend = MockDataService.getImpactStats()['monthlyTrend'] as List<dynamic>;
    final dataToUse = trendData ?? defaultTrend;

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
              painter: LineChartPainter(dataToUse),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart(Map<String, dynamic>? categoryDistribution) {
    final dist = categoryDistribution ?? MockDataService.getImpactStats()['categoryDistribution'] as Map<String, dynamic>;
    
    final categories = [
      {'name': 'Food', 'value': dist['Food'] ?? 0, 'color': AppColors.primary},
      {'name': 'Medical', 'value': dist['Medical'] ?? 0, 'color': AppColors.urgent},
      {'name': 'Shelter', 'value': dist['Shelter'] ?? 0, 'color': AppColors.categoryShelter},
      {'name': 'Clothing', 'value': dist['Clothing'] ?? 0, 'color': AppColors.success},
      {'name': 'Education', 'value': dist['Education'] ?? 0, 'color': AppColors.upcoming},
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

  Widget _buildCommunityDensityChart(Map<String, dynamic>? needDensity) {
    final density = needDensity ?? MockDataService.getImpactStats()['needDensity'] as Map<String, dynamic>;
    
    final cities = [
      {'name': 'Andheri', 'value': density['Andheri'] ?? 0},
      {'name': 'Bandra', 'value': density['Bandra'] ?? 0},
      {'name': 'Dadar', 'value': density['Dadar'] ?? 0},
      {'name': 'Powai', 'value': density['Powai'] ?? 0},
      {'name': 'Thane', 'value': density['Thane'] ?? 0},
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
                  (city['value'] as num).toDouble(),
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
    final percentage = (value / maxValue).clamp(0.0, 1.0);
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
              decoration: const BoxDecoration(
                color: AppColors.upcoming,
                borderRadius: BorderRadius.vertical(
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
  final List<dynamic> monthlyData;

  LineChartPainter(this.monthlyData);

  @override
  void paint(Canvas canvas, Size size) {
    if (monthlyData.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Dynamically calculate points based on provided stats
    final maxHelps = monthlyData.fold<double>(
      0.0, 
      (max, item) => item['helps'] > max ? (item['helps'] as num).toDouble() : max
    );
    final ceiling = (maxHelps == 0 ? 220 : maxHelps) * 1.2;

    List<Offset> points = [];
    for (int i = 0; i < monthlyData.length; i++) {
      final item = monthlyData[i];
      final val = (item['helps'] as num).toDouble();
      
      final x = size.width * (i / (monthlyData.length > 1 ? monthlyData.length - 1 : 1));
      final y = size.height * (1 - (val / ceiling)).clamp(0.0, 1.0);
      
      points.add(Offset(x, y));
    }

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

    for (int i = 0; i < monthlyData.length; i++) {
      textPainter.text = TextSpan(
        text: monthlyData[i]['month'] ?? '',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          size.width * (i / (monthlyData.length > 1 ? monthlyData.length - 1 : 1)) - textPainter.width / 2,
          size.height - 20,
        ),
      );
    }

    // Draw y-axis labels
    final values = [
      '0', 
      (ceiling * 0.25).toInt().toString(), 
      (ceiling * 0.50).toInt().toString(), 
      (ceiling * 0.75).toInt().toString(), 
      ceiling.toInt().toString()
    ];
    
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
      (sum, cat) => sum + (cat['value'] as num).toDouble(),
    );

    if (total == 0) return; // Prevent zero-division crash

    double startAngle = -math.pi / 2;

    for (final category in categories) {
      final value = (category['value'] as num).toDouble();
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
