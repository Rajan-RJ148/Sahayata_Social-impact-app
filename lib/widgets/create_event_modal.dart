import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Create Community Event Modal
class CreateEventModal extends StatefulWidget {
  const CreateEventModal({super.key});

  @override
  State<CreateEventModal> createState() => _CreateEventModalState();
}

class _CreateEventModalState extends State<CreateEventModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _volunteersController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _volunteersController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null &&
        _locationController.text.isNotEmpty &&
        _volunteersController.text.isNotEmpty;
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
              Text('Create Community Event', style: AppTextStyles.h3),
              const SizedBox(height: 24),

              // Event Title
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Description
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Date and Time Row
              Row(
                children: [
                  // Date Picker
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? _formatDate(_selectedDate!)
                              : 'dd-mm-yyyy',
                          style: TextStyle(
                            color: _selectedDate != null
                                ? AppColors.textPrimary
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Time Picker
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _selectedTime != null
                              ? _formatTime(_selectedTime!)
                              : '--:--',
                          style: TextStyle(
                            color: _selectedTime != null
                                ? AppColors.textPrimary
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'Location',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Volunteers Needed
              TextField(
                controller: _volunteersController,
                decoration: const InputDecoration(
                  hintText: 'Volunteers Needed',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
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
                      onPressed: _isFormValid()
                          ? () {
                              // Handle create event
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Event created successfully!'),
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
                      child: const Text('Create Event'),
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

/// Show Create Event Modal
void showCreateEventModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CreateEventModal(),
  );
}
