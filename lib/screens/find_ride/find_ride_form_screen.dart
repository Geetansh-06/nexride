
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'search_ride_screen.dart';

class FindRideFormScreen extends StatefulWidget {
  const FindRideFormScreen({super.key});

  @override
  State<FindRideFormScreen> createState() => _FindRideFormScreenState();
}

class _FindRideFormScreenState extends State<FindRideFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController =
  TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int passengerCount = 1;

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
      helpText: 'Select journey date',
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select journey time',
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _searchRides() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null) {
      _showMessage('Please select your journey date.');
      return;
    }

    if (selectedTime == null) {
      _showMessage('Please select your journey time.');
      return;
    }

    final String pickup = pickupController.text.trim();
    final String destination = destinationController.text.trim();

    if (pickup.toLowerCase() == destination.toLowerCase()) {
      _showMessage('Pickup and destination cannot be the same.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchRideScreen(
          pickup: pickup,
          destination: destination,
          journeyDate: selectedDate!,
          journeyTime: selectedTime!,
          passengerCount: passengerCount,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: AppColors.primaryLight,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSelectionTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryLight,
                  size: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: value.startsWith('Select')
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String dateText = selectedDate == null
        ? 'Select journey date'
        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';

    final String timeText = selectedTime == null
        ? 'Select journey time'
        : selectedTime!.format(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find a Ride',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan your journey',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Enter your travel details to find a suitable ride.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                _buildLocationField(
                  label: 'Pickup Location',
                  hint: 'Where will your journey start?',
                  controller: pickupController,
                  icon: Icons.my_location_rounded,
                ),

                const SizedBox(height: 22),

                _buildLocationField(
                  label: 'Destination',
                  hint: 'Where do you want to go?',
                  controller: destinationController,
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 22),

                _buildSelectionTile(
                  label: 'Journey Date',
                  value: dateText,
                  icon: Icons.calendar_month_outlined,
                  onTap: _selectDate,
                ),

                const SizedBox(height: 22),

                _buildSelectionTile(
                  label: 'Journey Time',
                  value: timeText,
                  icon: Icons.access_time_rounded,
                  onTap: _selectTime,
                ),

                const SizedBox(height: 22),

                _buildLabel('Number of Passengers'),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            color: AppColors.primaryLight,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Passengers',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: passengerCount > 1
                                ? () {
                              setState(() {
                                passengerCount--;
                              });
                            }
                                : null,
                            icon: const Icon(
                              Icons.remove_circle_outline,
                            ),
                            color: AppColors.primaryLight,
                          ),
                          Text(
                            '$passengerCount',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: passengerCount < 7
                                ? () {
                              setState(() {
                                passengerCount++;
                              });
                            }
                                : null,
                            icon: const Icon(
                              Icons.add_circle_outline,
                            ),
                            color: AppColors.primaryLight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _searchRides,
                    icon: const Icon(Icons.search_rounded),
                    label: const Text(
                      'Search Rides',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
