
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/driver_booking_store.dart';

class DriverBookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> booking;

  const DriverBookingDetailsScreen({
    super.key,
    required this.booking,
  });

  @override
  State<DriverBookingDetailsScreen> createState() =>
      _DriverBookingDetailsScreenState();
}

class _DriverBookingDetailsScreenState
    extends State<DriverBookingDetailsScreen> {

  Map<String, dynamic> get bookingDetails {
    final details = widget.booking['bookingDetails'];

    if (details is Map<String, dynamic>) {
      return details;
    }

    return widget.booking;
  }

  // Saved vehicle details
  Map<String, dynamic> get vehicleDetails {
    final vehicle = bookingDetails['vehicleDetails'];

    if (vehicle is Map<String, dynamic>) {
      return vehicle;
    }

    return {};
  }

  String getValue(String key) {
    final value = bookingDetails[key];

    if (value == null || value.toString().trim().isEmpty) {
      return 'Not provided';
    }

    return value.toString();
  }

  // Read vehicle information from nested map first,
  // then use flattened booking fields as fallback.
  String getVehicleValue(
      String nestedKey,
      String bookingKey,
      ) {
    final nestedValue = vehicleDetails[nestedKey];

    if (nestedValue != null &&
        nestedValue.toString().trim().isNotEmpty) {
      return nestedValue.toString();
    }

    return getValue(bookingKey);
  }

  String get bookingId =>
      widget.booking['bookingId']?.toString() ?? 'Not available';

  Map<String, dynamic> get latestBooking {
    final currentBooking =
    DriverBookingStore.bookings.value.where(
          (item) => item['bookingId'] == bookingId,
    );

    if (currentBooking.isNotEmpty) {
      return currentBooking.first;
    }

    return widget.booking;
  }

  String get currentStatus =>
      latestBooking['status']?.toString() ?? 'Pending';

  Future<void> cancelBooking() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Cancel Booking?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this driver booking?',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'No, Keep It',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    final bool cancelled =
    DriverBookingStore.cancelBooking(bookingId);

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          cancelled
              ? 'Booking cancelled successfully.'
              : 'Booking could not be cancelled. Please check its status.',
        ),
      ),
    );
  }

  // Mark Accepted Booking as Completed
  Future<void> completeBooking() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Complete Booking?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Have you successfully completed this driver service? '
                'Once completed, the booking status cannot be changed.',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Not Yet',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Yes, Completed',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    final bool completed =
    DriverBookingStore.completeBooking(bookingId);

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          completed
              ? 'Driver booking marked as completed.'
              : 'Booking could not be completed. Please check its status.',
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 6,
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

  Widget buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(title),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceType = getValue('serviceType');
    final status = currentStatus;

    final bool canCancel = status == 'Pending';
    final bool canComplete = status == 'Accepted';

    final completedAt = latestBooking['completedAt'];

    String completedDate = '';

    if (completedAt is DateTime) {
      completedDate =
      '${completedAt.day}/${completedAt.month}/${completedAt.year} '
          '${completedAt.hour.toString().padLeft(2, '0')}:'
          '${completedAt.minute.toString().padLeft(2, '0')}';
    }

    final statusColor = status == 'Cancelled' ||
        status == 'Rejected'
        ? AppColors.error
        : status == 'Completed' || status == 'Accepted'
        ? AppColors.success
        : AppColors.warning;

    final statusIcon = status == 'Cancelled' ||
        status == 'Rejected'
        ? Icons.cancel_outlined
        : status == 'Completed'
        ? Icons.task_alt
        : status == 'Accepted'
        ? Icons.check_circle_outline
        : Icons.pending_actions;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Booking Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Booking Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Status',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        statusIcon,
                        color: statusColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  if (status == 'Completed' &&
                      completedDate.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Completed on: $completedDate',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),
                  const Text(
                    'Booking ID',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SelectableText(
                    bookingId,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Service Information
            buildSection(
              title: 'Service Information',
              children: [
                buildDetailRow(
                  'Service Type',
                  serviceType == 'my_car'
                      ? 'Driver for My Car'
                      : serviceType == 'with_vehicle'
                      ? 'Driver with Vehicle'
                      : serviceType,
                ),
              ],
            ),

            // Trip Information
            buildSection(
              title: 'Trip Information',
              children: [
                buildDetailRow(
                  'Pickup Location',
                  getValue('pickup'),
                ),
                buildDetailRow(
                  'Destination',
                  getValue('destination'),
                ),
                buildDetailRow(
                  'Trip Type',
                  getValue('tripType'),
                ),
                buildDetailRow(
                  'Journey Date',
                  getValue('journeyDate'),
                ),
                buildDetailRow(
                  'Journey Time',
                  getValue('journeyTime'),
                ),
                if (getValue('returnDate') != 'Not provided')
                  buildDetailRow(
                    'Return Date',
                    getValue('returnDate'),
                  ),
              ],
            ),

            // Vehicle Information
            if (serviceType == 'my_car')
              buildSection(
                title: 'Vehicle Information',
                children: [
                  buildDetailRow(
                    'Vehicle Type',
                    getVehicleValue('vehicleType', 'vehicleType'),
                  ),
                  buildDetailRow(
                    'Brand',
                    getVehicleValue('brand', 'vehicleBrand'),
                  ),
                  buildDetailRow(
                    'Model',
                    getVehicleValue('model', 'vehicleModel'),
                  ),
                  buildDetailRow(
                    'Registration Number',
                    getVehicleValue(
                      'registration',
                      'vehicleRegistration',
                    ),
                  ),
                  buildDetailRow(
                    'Colour',
                    getVehicleValue('colour', 'vehicleColour'),
                  ),
                  buildDetailRow(
                    'Seating Capacity',
                    getVehicleValue(
                      'seatingCapacity',
                      'vehicleSeatingCapacity',
                    ),
                  ),
                  buildDetailRow(
                    'Vehicle Transmission',
                    getValue('vehicleTransmission'),
                  ),
                ],
              ),

            // Passenger Information
            if (serviceType == 'with_vehicle')
              buildSection(
                title: 'Passenger Information',
                children: [
                  buildDetailRow(
                    'Passengers',
                    getValue('passengers'),
                  ),
                ],
              ),

            // Driver Requirements
            buildSection(
              title: 'Driver Requirements',
              children: [
                buildDetailRow(
                  'Experience',
                  getValue('driverExperience'),
                ),
                buildDetailRow(
                  'Preferred Transmission',
                  getValue('driverTransmission'),
                ),
              ],
            ),

            // Additional Notes
            if (getValue('additionalNotes') != 'Not provided')
              buildSection(
                title: 'Additional Notes',
                children: [
                  Text(
                    getValue('additionalNotes'),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

            // Complete Booking Button
            if (canComplete) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: completeBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Mark as Completed',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],

            // Cancel Booking Button
            if (canCancel) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: cancelBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Cancel Booking',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
