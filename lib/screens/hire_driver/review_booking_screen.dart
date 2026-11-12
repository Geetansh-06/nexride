
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/driver_booking_store.dart';
import 'booking_confirmation_screen.dart';

class ReviewBookingScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;

  const ReviewBookingScreen({
    super.key,
    required this.bookingDetails,
  });

  @override
  State<ReviewBookingScreen> createState() =>
      _ReviewBookingScreenState();
}

class _ReviewBookingScreenState extends State<ReviewBookingScreen> {
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

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryLight,
            size: 20,
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
    );
  }

  Widget _detailRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
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

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(title, icon),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Future<void> _confirmBooking() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Confirm Booking Request?',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'Your details are ready. This is a demo flow; '
                'the request will be saved temporarily on this screen session. '
                'It will not be sent to a backend yet.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Go Back',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final String bookingId =
    DriverBookingStore.addBooking(widget.bookingDetails);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          bookingDetails: widget.bookingDetails,
          bookingId: bookingId,
        ),
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
        details['driverExperience']?.toString() ?? 'Not provided';

    final String driverTransmission =
        details['driverTransmission']?.toString() ?? 'Not provided';

    final String notes =
        details['additionalNotes']?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Review Booking',
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
                      'Review your details',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Please check all the information before confirming.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Service Information
                    _buildSection(
                      title: 'Service',
                      icon: Icons.miscellaneous_services_rounded,
                      children: [
                        _detailRow('Selected Service', _serviceName()),
                      ],
                    ),

                    // Trip Information
                    _buildSection(
                      title: 'Trip Information',
                      icon: Icons.route_rounded,
                      children: [
                        _detailRow(
                          'Pickup',
                          details['pickup']?.toString() ?? '',
                        ),
                        _detailRow(
                          'Destination',
                          details['destination']?.toString() ?? '',
                        ),
                        _detailRow(
                          'Trip Type',
                          details['tripType']?.toString() ?? '',
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

                    // Vehicle Information
                    _buildSection(
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

                    // Driver Requirements
                    _buildSection(
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
                    if (notes.isNotEmpty)
                      _buildSection(
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

                    // Information Note
                    Container(
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
                              'Please verify your trip, vehicle and driver '
                                  'requirements. You can go back to edit them.',
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

            // Confirm Booking Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Confirm Booking Request',
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
