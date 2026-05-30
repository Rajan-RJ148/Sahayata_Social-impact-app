import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../models/help_request.dart';
import '../services/mock_data_service.dart';
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
  
  List<HelpRequest> _allRequests = [];
  List<HelpRequest> _filteredRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  void _loadData() {
    _allRequests = MockDataService.getHelpRequests();
    _filterRequests();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedFilter = _tabs[_tabController.index];
        _filterRequests();
      });
    }
  }

  void _filterRequests() {
    setState(() {
      if (_selectedFilter == 'All Posts') {
        _filteredRequests = _allRequests;
      } else if (_selectedFilter == 'Needy') {
        _filteredRequests = _allRequests.where((r) => r.status == 'Needy').toList();
      } else if (_selectedFilter == 'Helped') {
        _filteredRequests = _allRequests.where((r) => r.status == 'Helped').toList();
      } else if (_selectedFilter == 'Upcoming Events') {
        _filteredRequests = _allRequests.where((r) => r.status == 'Upcoming').toList();
      }
    });
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
            // New Header Design
            _buildNewHeader(),
            
            // Location and Filter Row
            _buildLocationFilterRow(),
            
            // Search Bar
            _buildSearchBar(),
            
            // Tab Bar with new styling
            _buildNewTabBar(),
            
            // Posts List
            Expanded(
              child: _filteredRequests.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredRequests.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          request: _filteredRequests[index],
                          onTap: () {
                            // Navigate to post detail
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
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
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
                  color: isSelected ? AppColors.textPrimary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
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
            'Be the first to post a help request',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            double _radius = AppConfig.defaultRadius;
            Set<String> _selectedCategories = {'All'};

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filters', style: AppTextStyles.h3),
                  const SizedBox(height: 24),
                  
                  // Radius Slider
                  Text('Radius', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Slider(
                    value: _radius,
                    min: AppConfig.minRadius,
                    max: AppConfig.maxRadius,
                    divisions: 19,
                    label: '${(_radius / 1000).toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setModalState(() {
                        _radius = value;
                      });
                    },
                  ),
                  Text(
                    '${(_radius / 1000).toStringAsFixed(1)} km',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  
                  // Category Chips
                  Text('Category', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', ...AppConfig.categories].map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (category == 'All') {
                              _selectedCategories = {'All'};
                            } else {
                              _selectedCategories.remove('All');
                              if (selected) {
                                _selectedCategories.add(category);
                              } else {
                                _selectedCategories.remove(category);
                              }
                              if (_selectedCategories.isEmpty) {
                                _selectedCategories = {'All'};
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Apply Button
                  CustomButton(
                    text: 'Apply Filters',
                    onPressed: () {
                      Navigator.pop(context);
                      // Apply filters logic here
                    },
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
