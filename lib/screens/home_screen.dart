import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../models/help_request.dart';
import '../services/help_request_repository.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/create_help_request_modal.dart';

/// Home Screen with Feed
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All Posts';
  final List<String> _tabs = ['All Posts', 'Needy', 'Helped', 'Upcoming Events'];

  // Persistent Filter State
  double _currentRadius = AppConfig.defaultRadius;
  String _selectedCategory = 'All';
  String _selectedTimeline = 'All'; // 'All', 'Recently Posted', 'This Week', 'This Month'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // Check if the index is changing or has changed to update filter feed correctly
    setState(() {
      _selectedFilter = _tabs[_tabController.index];
    });
  }

  void _filterRequests() {
    // Just trigger a rebuild so the StreamBuilder applies the new local filters
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
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
            // New Header Design
            _buildNewHeader(),
            
            // Location and Filter Row
            _buildLocationFilterRow(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Tab Bar with new styling
            _buildNewTabBar(),
            
            // Posts List Stream
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: HelpRequestRepository().getHelpRequestsStream(
                  status: _selectedFilter == 'All Posts' ? 'All' : _selectedFilter,
                  category: _selectedCategory,
                ),
                builder: (context, snapshot) {
                  // Loading State
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  // Empty State from Firestore/Fallback
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Local Filtering for Radius and Timeline
                  var temp = snapshot.data!;
                  
                  // Distance Radius Filter
                  temp = temp.where((p) {
                    final distance = p['distance'] as double?;
                    return distance == null || distance <= (_currentRadius / 1000.0);
                  }).toList();

                  // Timeline Filter
                  final now = DateTime.now();
                  if (_selectedTimeline == 'Recently Posted') {
                    temp = temp.where((p) {
                      final createdAt = p['createdAt'];
                      if (createdAt is DateTime) return now.difference(createdAt).inHours <= 24;
                      if (createdAt is Timestamp) return now.difference(createdAt.toDate()).inHours <= 24;
                      return false;
                    }).toList();
                  } else if (_selectedTimeline == 'This Week') {
                    temp = temp.where((p) {
                      final createdAt = p['createdAt'];
                      if (createdAt is DateTime) return now.difference(createdAt).inDays <= 7;
                      if (createdAt is Timestamp) return now.difference(createdAt.toDate()).inDays <= 7;
                      return false;
                    }).toList();
                  } else if (_selectedTimeline == 'This Month') {
                    temp = temp.where((p) {
                      final createdAt = p['createdAt'];
                      if (createdAt is DateTime) return now.difference(createdAt).inDays <= 30;
                      if (createdAt is Timestamp) return now.difference(createdAt.toDate()).inDays <= 30;
                      return false;
                    }).toList();
                  }

                  // Empty State after local filters
                  if (temp.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: temp.length,
                    itemBuilder: (context, index) {
                      final post = temp[index];
                      
                      // Map the dynamic Firestore dictionary back to our UI HelpRequest structure
                      final requestObj = HelpRequest(
                        id: post['id'] ?? '',
                        authorId: post['authorUid'] ?? '',
                        author: post['authorName'] ?? 'Unknown',
                        authorAvatar: post['authorAvatar'] ?? '👤',
                        category: post['category'] ?? 'General',
                        description: post['description'] ?? '',
                        location: post['locationName'] ?? 'Unknown Location',
                        imageUrls: List<String>.from(post['imageUrls'] ?? []),
                        status: post['status'] ?? 'Needy',
                        timePosted: post['createdAt'] is DateTime 
                            ? post['createdAt'] 
                            : (post['createdAt'] is Timestamp ? post['createdAt'].toDate() : DateTime.now()),
                        helpersCount: post['helpersCount'] ?? 0,
                        distance: post['distance'],
                        poll: post['hasPoll'] == true && post['poll'] != null 
                              ? Poll(
                                  question: post['poll']['question'],
                                  options: List<String>.from(post['poll']['options']),
                                  votes: Map<String, int>.from(post['poll']['votes'])
                                )
                              : null,
                      );

                      return PostCard(
                        request: requestObj,
                        onTap: () {
                          // Navigate to post detail
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCreateHelpRequestModal(context),
        icon: const Icon(Icons.add),
        label: const Text('Post Help Request'),
      ),
    );
  }

  Widget _buildNewHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.purpleGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.volunteer_activism,
              color: AppColors.textWhite,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // App Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConfig.appName,
                  style: AppTextStyles.h4,
                ),
                Text(
                  'Connecting Hearts, Changing Lives',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Current Location\nMumbai, Maharashtra',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.3,
              ),
              maxLines: 2,
            ),
          ),
          IconButton(
            onPressed: _showFilterModal,
            icon: const Icon(Icons.tune),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search help requests...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.backgroundGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Color _getTabColor(String tab, bool isSelected) {
    if (!isSelected) return AppColors.surface;
    switch (tab) {
      case 'All Posts':
        return AppColors.primary; // Blue
      case 'Needy':
        return AppColors.urgent; // Red
      case 'Helped':
        return AppColors.success; // Green
      case 'Upcoming Events':
        return AppColors.upcoming; // Purple
      default:
        return AppColors.primary;
    }
  }

  Widget _buildNewTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _tabController.index == index;
            
            return GestureDetector(
              onTap: () {
                _tabController.animateTo(index);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _getTabColor(tab, isSelected),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(color: AppColors.border),
                ),
                child: Text(
                  tab,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No requests found',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to post a help request or adjust filters',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal() {
    double tempRadius = _currentRadius;
    String tempCategory = _selectedCategory;
    String tempTimeline = _selectedTimeline;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filters', style: AppTextStyles.h3),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  
                  // Radius Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Distance Radius', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        '${(tempRadius / 1000).toStringAsFixed(1)} km',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.success,
                      inactiveTrackColor: AppColors.success.withOpacity(0.2),
                      thumbColor: AppColors.success,
                      overlayColor: AppColors.success.withOpacity(0.1),
                      valueIndicatorColor: AppColors.success,
                      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                    ),
                    child: Slider(
                      value: tempRadius,
                      min: AppConfig.minRadius,
                      max: AppConfig.maxRadius,
                      divisions: 19,
                      label: '${(tempRadius / 1000).toStringAsFixed(1)} km',
                      onChanged: (value) {
                        setModalState(() {
                          tempRadius = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Category Section
                  Text('Category', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', ...AppConfig.categories].map((category) {
                      final isSelected = tempCategory == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.backgroundGray,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : AppColors.border,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              tempCategory = category;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  
                  // Timeline Section
                  Text('Timeline', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Recently Posted', 'This Week', 'This Month'].map((timeline) {
                      final isSelected = tempTimeline == timeline;
                      return ChoiceChip(
                        label: Text(timeline),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.backgroundGray,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : AppColors.border,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              tempTimeline = timeline;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempRadius = AppConfig.defaultRadius;
                              tempCategory = 'All';
                              tempTimeline = 'All';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Reset', style: TextStyle(color: AppColors.textPrimary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentRadius = tempRadius;
                              _selectedCategory = tempCategory;
                              _selectedTimeline = tempTimeline;
                              _filterRequests();
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
