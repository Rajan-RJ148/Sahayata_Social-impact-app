import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../config/app_config.dart';

/// Create Help Request Modal
class CreateHelpRequestModal extends StatefulWidget {
  const CreateHelpRequestModal({super.key});

  @override
  State<CreateHelpRequestModal> createState() => _CreateHelpRequestModalState();
}

class _CreateHelpRequestModalState extends State<CreateHelpRequestModal> {
  String? _selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _useCurrentLocation = false;
  bool _addPoll = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create Help Request', style: AppTextStyles.h3),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Category Selection
              Text(
                'Category *',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConfig.categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Description
              Row(
                children: [
                  Text(
                    'Description *',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      // Voice to text functionality
                    },
                    icon: const Icon(Icons.mic, size: 16),
                    label: const Text('Voice to Text'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Describe the help needed... (or use voice input)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Location
              Text(
                'Location *',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on),
                  hintText: 'Enter location or use current location',
                  border: const OutlineInputBorder(),
                  enabled: !_useCurrentLocation,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    _useCurrentLocation = !_useCurrentLocation;
                    if (_useCurrentLocation) {
                      _locationController.text = 'Using current location...';
                    } else {
                      _locationController.clear();
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _useCurrentLocation
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Use Current Location',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Photo Upload
              Text(
                'Photo (Optional)',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  // Image picker functionality
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.border,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.backgroundGray,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add Photo',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Add Community Poll
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Community Poll',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Let the community decide on help details',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _addPoll,
                    onChanged: (value) {
                      setState(() {
                        _addPoll = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _selectedCategory != null &&
                              _descriptionController.text.isNotEmpty &&
                              _locationController.text.isNotEmpty
                          ? () {
                              // Handle post help request
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Help request posted successfully!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Post Help Request'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Show Create Help Request Modal
void showCreateHelpRequestModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CreateHelpRequestModal(),
  );
}
