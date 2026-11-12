
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/driver_booking_store.dart';

class IncomingDriverRequestsScreen extends StatefulWidget {
  const IncomingDriverRequestsScreen({super.key});

  @override
  State<IncomingDriverRequestsScreen> createState() =>
      _IncomingDriverRequestsScreenState();
}

class _IncomingDriverRequestsScreenState
    extends State<IncomingDriverRequestsScreen> {
  String selectedStatus = 'Pending';

  final List<String> statuses = [
    'All',
    'Pending',
    'Accepted',
    'Rejected',
    'Completed',
  ];

  List<Map<String, dynamic>> _getFilteredBookings() {
    final bookings = DriverBookingStore.bookings.value;

    final filtered = selectedStatus == 'All'
        ? bookings
        : bookings
        .where((booking) => booking['status'] == selectedStatus)
        .toList();

    return filtered.reversed.toList();
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Not specified';

    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }

    return date.toString();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.greenAccent;
      case 'Completed':
        return AppColors.success;
      case 'Rejected':
        return AppColors.error;
      default:
        return Colors.white54;
    }
  }

  Future<void> _updateRequest({
    required String bookingId,
    required bool accept,
  }) async {
    final String action = accept ? 'Accept' : 'Reject';

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            '$action Request?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            accept
                ? 'Are you sure you want to accept this driver booking request?'
                : 'Are you sure you want to reject this driver booking request?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                accept ? AppColors.primary : AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(action),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final bool updated = accept
        ? DriverBookingStore.acceptBooking(bookingId)
        : DriverBookingStore.rejectBooking(bookingId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated
              ? 'Request ${accept ? 'accepted' : 'rejected'} successfully.'
              : 'Request could not be updated.',
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (context, index) =>
        const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = selectedStatus == status;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedStatus = status;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white12,
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isSelected
                      ? Colors.black
                      : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> booking) {
    final String bookingId =
        booking['bookingId']?.toString() ?? '';

    final Map<String, dynamic> details =
    Map<String, dynamic>.from(
      booking['bookingDetails'] ?? {},
    );

    final String status =
        booking['status']?.toString() ?? 'Pending';

    final bool isPending = status == 'Pending';

    final String pickup =
        details['pickup']?.toString() ?? 'Not specified';

    final String destination =
        details['destination']?.toString() ?? 'Not specified';

    final String serviceType =
        details['serviceType']?.toString() ??
            details['service']?.toString() ??
            'Driver Service';

    final String tripType =
        details['tripType']?.toString() ?? 'Not specified';

    final String journeyDate =
    _formatDate(details['journeyDate']);

    final String journeyTime =
        details['journeyTime']?.toString() ?? 'Not specified';

    final String passengers =
        details['passengers']?.toString() ?? 'Not specified';

    final String vehicle =
        details['vehicleDetails']?.toString() ??
            details['vehicleType']?.toString() ??
            'Not specified';

    final String experience =
        details['driverExperience']?.toString() ??
            details['experience']?.toString() ??
            'Not specified';

    final Color statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isPending
                      ? 'New Booking Request'
                      : 'Driver Booking Request',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            bookingId,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 18),

          // Journey route
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.circle_outlined,
                    color: Colors.greenAccent,
                    size: 17,
                  ),
                  Container(
                    width: 1.5,
                    height: 35,
                    color: Colors.white24,
                  ),
                  const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 19,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pickup Location',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      pickup,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'Destination',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      destination,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

          _buildInfoRow(
            Icons.work_outline,
            'Service Type',
            serviceType,
          ),

          _buildInfoRow(
            Icons.calendar_month,
            'Journey Date',
            journeyDate,
          ),

          _buildInfoRow(
            Icons.access_time,
            'Journey Time',
            journeyTime,
          ),

          _buildInfoRow(
            Icons.route,
            'Trip Type',
            tripType,
          ),

          _buildInfoRow(
            Icons.people_outline,
            'Passengers',
            passengers,
          ),

          _buildInfoRow(
            Icons.directions_car_outlined,
            'Vehicle Details',
            vehicle,
          ),

          _buildInfoRow(
            Icons.workspace_premium_outlined,
            'Driver Experience',
            experience,
          ),

          if (details['notes'] != null &&
              details['notes'].toString().trim().isNotEmpty)
            _buildInfoRow(
              Icons.notes,
              'Additional Notes',
              details['notes'].toString(),
            ),

          // Action buttons only for Pending requests.
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _updateRequest(
                        bookingId: bookingId,
                        accept: false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(
                        color: Colors.redAccent,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _updateRequest(
                        bookingId: bookingId,
                        accept: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Accept Request',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;

    switch (selectedStatus) {
      case 'Pending':
        message =
        'New pending driver booking requests will appear here.';
        break;
      case 'Accepted':
        message =
        'Your accepted booking requests will appear here.';
        break;
      case 'Rejected':
        message =
        'Your rejected booking requests will appear here.';
        break;
      case 'Completed':
        message =
        'Your completed driver bookings will appear here.';
        break;
      default:
        message =
        'Your driver booking requests will appear here.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 65,
              color: Colors.white.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Requests Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Driver Requests',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: DriverBookingStore.bookings,
          builder: (context, child) {
            final List<Map<String, dynamic>> filteredBookings =
            _getFilteredBookings();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 5, 16, 16),
                  child: Text(
                    'Manage your incoming driver booking requests.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildStatusSelector(),
                ),

                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Requests',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${filteredBookings.length} found',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Expanded(
                  child: filteredBookings.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16, 0, 16, 20,
                    ),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      return _buildRequestCard(
                        filteredBookings[index],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
