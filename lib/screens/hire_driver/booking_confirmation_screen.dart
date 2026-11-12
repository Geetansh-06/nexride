
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;
  final String bookingId;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingDetails,
    required this.bookingId,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends State<BookingConfirmationScreen> {
  String _formatDate(dynamic value) {
    if (value is! DateTime) return 'Not provided';

    return '${value.day.toString().padLeft(2, '0')}/'
        '${value.month.toString().padLeft(2, '0')}/'
        '${value.year}';
  }

  String _formatTime(dynamic value) {
    if (value is TimeOfDay) {
      return value.format(context);
    }

    return 'Not provided';
  }

  String _serviceName() {
    return widget.bookingDetails['serviceType'] == 'my_car'
        ? 'Driver for My Car'
        : 'Driver with Vehicle';
  }

  void _goToHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _detailRow(String label, String value) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryLight,
                size: 19,
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.bookingDetails;

    final bool isMyCar = details['serviceType'] == 'my_car';

    // Saved vehicle information.
    final Map<String, dynamic> vehicleDetails =
    details['vehicleDetails'] is Map
        ? Map<String, dynamic>.from(details['vehicleDetails'])
        : {};

    final String vehicleType =
        details['vehicleType']?.toString() ?? '';

    final String vehicleBrand =
        details['vehicleBrand']?.toString() ??
            vehicleDetails['brand']?.toString() ??
            '';

    final String vehicleModel =
        details['vehicleModel']?.toString() ??
            vehicleDetails['model']?.toString() ??
            '';

    final String vehicleRegistration =
        details['vehicleRegistration']?.toString() ??
            vehicleDetails['registration']?.toString() ??
            '';

    final String vehicleColour =
        details['vehicleColour']?.toString() ??
            vehicleDetails['colour']?.toString() ??
            '';

    final String vehicleSeatingCapacity =
        details['vehicleSeatingCapacity']?.toString() ??
            vehicleDetails['seatingCapacity']?.toString() ??
            '';

    final String vehicleTransmission =
        details['vehicleTransmission']?.toString() ?? '';

    final String passengers =
        details['passengers']?.toString() ?? '';

    final String experience =
        details['driverExperience']?.toString() ?? '';

    final String driverTransmission =
        details['driverTransmission']?.toString() ?? '';

    final String notes =
        details['additionalNotes']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(
            color: AppColors.textPrimary,
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
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                child: Column(
                  children: [
                    // Success Icon
                    Container(
                      height: 86,
                      width: 86,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 58,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Booking Request Created!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 9),

                    const Text(
                      'Your demo booking has been saved temporarily. '
                          'Backend submission is not connected yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Booking ID
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'BOOKING ID',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 9),
                          SelectableText(
                            widget.bookingId,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Pending',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Booking Summary
                    _buildSummarySection(
                      title: 'Booking Summary',
                      icon: Icons.receipt_long_rounded,
                      children: [
                        _detailRow('Service', _serviceName()),
                        _detailRow(
                          'Pickup',
                          details['pickup']?.toString() ?? 'Not provided',
                        ),
                        _detailRow(
                          'Destination',
                          details['destination']?.toString() ??
                              'Not provided',
                        ),
                        _detailRow(
                          'Trip Type',
                          details['tripType']?.toString() ?? 'Not provided',
                        ),
                        _detailRow(
                          'Journey Date',
                          _formatDate(details['journeyDate']),
                        ),
                        _detailRow(
                          'Pickup Time',
                          _formatTime(details['journeyTime']),
                        ),
                        if (details['tripType'] == 'Round Trip')
                          _detailRow(
                            'Return Date',
                            _formatDate(details['returnDate']),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Vehicle Information
                    _buildSummarySection(
                      title: 'Vehicle Information',
                      icon: Icons.directions_car_rounded,
                      children: [
                        _detailRow(
                          'Vehicle Category',
                          vehicleType,
                        ),
                        if (isMyCar) ...[
                          _detailRow(
                            'Car Brand',
                            vehicleBrand,
                          ),
                          _detailRow(
                            'Car Model',
                            vehicleModel,
                          ),
                          _detailRow(
                            'Registration Number',
                            vehicleRegistration,
                          ),
                          _detailRow(
                            'Vehicle Colour',
                            vehicleColour,
                          ),
                          _detailRow(
                            'Seating Capacity',
                            vehicleSeatingCapacity.isNotEmpty
                                ? '$vehicleSeatingCapacity seats'
                                : '',
                          ),
                          _detailRow(
                            'Car Transmission',
                            vehicleTransmission,
                          ),
                        ],
                        if (!isMyCar)
                          _detailRow(
                            'Passengers',
                            passengers,
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Driver Requirements
                    _buildSummarySection(
                      title: 'Driver Requirements',
                      icon: Icons.person_rounded,
                      children: [
                        _detailRow(
                          'Driving Experience',
                          experience,
                        ),
                        _detailRow(
                          'Transmission Preference',
                          driverTransmission,
                        ),
                      ],
                    ),

                    // Additional Notes
                    if (notes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSummarySection(
                        title: 'Additional Notes',
                        icon: Icons.notes_rounded,
                        children: [
                          Text(
                            notes,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Demo Information
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primaryLight,
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'This is a demo booking. No driver has been '
                                  'notified and no real booking has been submitted.',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Back to Home Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _goToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 15,
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
