
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'driver_requirements_screen.dart';
import 'review_booking_screen.dart';

class TripDetailsScreen extends StatefulWidget {
  final String serviceType;

  const TripDetailsScreen({
    super.key,
    required this.serviceType,
  });

  @override
  State<TripDetailsScreen> createState() =>
      _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final TextEditingController pickupController =
  TextEditingController();

  final TextEditingController destinationController =
  TextEditingController();

  DateTime? journeyDate;
  DateTime? returnDate;
  TimeOfDay? journeyTime;

  String tripType = 'One Way';

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    return time.format(context);
  }

  Future<void> _selectJourneyDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: journeyDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryLight,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() {
        journeyDate = selected;

        if (returnDate != null &&
            returnDate!.isBefore(selected)) {
          returnDate = null;
        }
      });
    }
  }

  Future<void> _selectReturnDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: returnDate ??
          (journeyDate ?? DateTime.now()).add(
            const Duration(days: 1),
          ),
      firstDate: journeyDate ?? DateTime.now(),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryLight,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() {
        returnDate = selected;
      });
    }
  }

  Future<void> _selectJourneyTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: journeyTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryLight,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() {
        journeyTime = selected;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.primaryLight,
              size: 21,
            ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryLight,
                  size: 21,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: value.startsWith('Select')
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontSize: 13,
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

  Widget _buildTripTypeOption(String type) {
    final bool isSelected = tripType == type;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            tripType = type;

            if (type == 'One Way') {
              returnDate = null;
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.18)
                : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryLight
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? AppColors.primaryLight
                    : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 7),
              Text(
                type,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continue() async {
    if (pickupController.text.trim().isEmpty ||
        destinationController.text.trim().isEmpty) {
      _showMessage('Please enter pickup and destination.');
      return;
    }

    if (pickupController.text.trim().toLowerCase() ==
        destinationController.text.trim().toLowerCase()) {
      _showMessage('Pickup and destination cannot be same.');
      return;
    }

    if (journeyDate == null || journeyTime == null) {
      _showMessage('Please select journey date and time.');
      return;
    }

    if (tripType == 'Round Trip' && returnDate == null) {
      _showMessage('Please select your return date.');
      return;
    }

    final Map<String, dynamic> tripDetails = {
      'serviceType': widget.serviceType,
      'pickup': pickupController.text.trim(),
      'destination': destinationController.text.trim(),
      'journeyDate': journeyDate,
      'journeyTime': journeyTime,
      'tripType': tripType,
      'returnDate': returnDate,
    };

    // Step 1: Open Driver Requirements screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverRequirementsScreen(
          tripDetails: tripDetails,
        ),
      ),
    );

    if (!mounted) return;

    // Step 2: Receive all completed details.
    if (result is Map<String, dynamic>) {
      // Step 3: Open Review Booking screen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewBookingScreen(
            bookingDetails: result,
          ),
        ),
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMyCar = widget.serviceType == 'my_car';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Trip Details',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Where do you want to go?',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your journey details to find the right driver.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isMyCar
                                ? Icons.directions_car_rounded
                                : Icons.car_rental_rounded,
                            color: AppColors.primaryLight,
                            size: 23,
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              isMyCar
                                  ? 'Driver for My Car'
                                  : 'Driver with Vehicle',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    _buildTextField(
                      label: 'Pickup Location',
                      hint: 'Enter pickup location',
                      icon: Icons.my_location_rounded,
                      controller: pickupController,
                    ),

                    const SizedBox(height: 20),

                    _buildTextField(
                      label: 'Destination',
                      hint: 'Enter destination',
                      icon: Icons.location_on_outlined,
                      controller: destinationController,
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Trip Type',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        _buildTripTypeOption('One Way'),
                        const SizedBox(width: 12),
                        _buildTripTypeOption('Round Trip'),
                      ],
                    ),

                    const SizedBox(height: 22),

                    _buildDateTimeField(
                      label: 'Journey Date',
                      value: _formatDate(journeyDate),
                      icon: Icons.calendar_month_outlined,
                      onTap: _selectJourneyDate,
                    ),

                    const SizedBox(height: 20),

                    _buildDateTimeField(
                      label: 'Pickup Time',
                      value: _formatTime(journeyTime),
                      icon: Icons.access_time_rounded,
                      onTap: _selectJourneyTime,
                    ),

                    if (tripType == 'Round Trip') ...[
                      const SizedBox(height: 20),
                      _buildDateTimeField(
                        label: 'Return Date',
                        value: _formatDate(returnDate),
                        icon: Icons.event_repeat_rounded,
                        onTap: _selectReturnDate,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
