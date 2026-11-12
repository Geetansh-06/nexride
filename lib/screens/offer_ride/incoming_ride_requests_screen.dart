
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/ride_booking_store.dart';
import '../../services/ride_store.dart';

class IncomingRideRequestsScreen extends StatefulWidget {
  const IncomingRideRequestsScreen({super.key});

  @override
  State<IncomingRideRequestsScreen> createState() =>
      _IncomingRideRequestsScreenState();
}

class _IncomingRideRequestsScreenState
    extends State<IncomingRideRequestsScreen> {
  String selectedStatus = 'Pending';

  final List<String> statuses = [
    'All',
    'Pending',
    'Accepted',
    'Rejected',
    'Cancelled',
  ];

  // Show only requests for your published rides.
  List<Map<String, dynamic>> _getFilteredBookings() {
    final publishedRideIds = RideStore.publishedRides.value
        .map((ride) => ride['id'])
        .toSet();

    final ownBookings = RideBookingStore.bookings.value.where(
          (booking) => publishedRideIds.contains(booking['rideId']),
    );

    final filtered = selectedStatus == 'All'
        ? ownBookings.toList()
        : ownBookings
        .where((booking) => booking['status'] == selectedStatus)
        .toList();

    return filtered.reversed.toList();
  }

  Map<String, dynamic> _getPublishedRide(dynamic rideId) {
    for (final ride in RideStore.publishedRides.value) {
      if (ride['id'] == rideId) {
        return ride;
      }
    }

    return {};
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Not specified';

    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    }

    return date.toString();
  }

  String _formatTime(dynamic time) {
    if (time == null) return 'Not specified';

    if (time is TimeOfDay) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';

      return '$hour:$minute $period';
    }

    return time.toString();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.greenAccent;
      case 'Rejected':
        return AppColors.error;
      case 'Cancelled':
        return Colors.white54;
      default:
        return Colors.white54;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _updateRequest({
    required int bookingId,
    required bool accept,
  }) async {
    final action = accept ? 'Accept' : 'Reject';

    final confirmed = await showDialog<bool>(
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
                ? 'Are you sure you want to accept this ride booking request?'
                : 'Are you sure you want to reject this ride booking request?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
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
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: Text(action),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    // Find the booking and make sure it is still Pending.
    final booking = RideBookingStore.bookings.value.firstWhere(
          (item) => item['id'] == bookingId,
      orElse: () => <String, dynamic>{},
    );

    if (booking.isEmpty || booking['status'] != 'Pending') {
      _showMessage('This request is no longer pending.');
      return;
    }

    bool updated = false;

    if (accept) {
      final rideId = int.tryParse(booking['rideId'].toString());

      final passengerCount =
          int.tryParse(booking['passengerCount'].toString()) ?? 0;

      if (rideId == null || passengerCount <= 0) {
        _showMessage('Invalid ride or passenger information.');
        return;
      }

      // First reserve the seats.
      final seatsReserved = RideStore.reserveSeats(
        rideId: rideId,
        seats: passengerCount,
      );

      if (!seatsReserved) {
        _showMessage(
          'Unable to accept. This ride is inactive or does not have enough available seats.',
        );
        return;
      }

      // Accept only after seats have been reserved.
      updated = RideBookingStore.acceptBooking(bookingId);
    } else {
      // Reject does not change available seats.
      updated = RideBookingStore.rejectBooking(bookingId);
    }

    if (!mounted) return;

    _showMessage(
      updated
          ? 'Request ${accept ? 'accepted' : 'rejected'} successfully.'
          : 'Request could not be updated.',
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
                  color: isSelected ? Colors.black : Colors.white70,
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
    final bookingId = int.tryParse(booking['id'].toString());

    final ride = _getPublishedRide(booking['rideId']);

    final status = booking['status']?.toString() ?? 'Pending';
    final isPending = status == 'Pending';

    final pickup =
        booking['pickup']?.toString() ?? 'Not specified';

    final destination =
        booking['destination']?.toString() ?? 'Not specified';

    final journeyDate = _formatDate(booking['journeyDate']);
    final journeyTime = _formatTime(booking['journeyTime']);

    final passengers =
        booking['passengerCount']?.toString() ?? '0';

    final totalPrice = '₹${booking['totalPrice'] ?? 0}';

    final pricePerSeat =
        ride['price']?.toString() ?? 'Not specified';

    final vehicle =
        ride['vehicle']?.toString() ??
            ride['vehicleType']?.toString() ??
            'Not specified';

    final availableSeats =
        ride['availableSeats']?.toString() ?? 'Not specified';

    final message = booking['message']?.toString() ?? '';

    final statusColor = _getStatusColor(status);

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
              const Expanded(
                child: Text(
                  'Ride Booking Request',
                  style: TextStyle(
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
            'Booking ID: ${bookingId ?? '-'}',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 18),

          // Pickup and destination
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
            Icons.people_outline,
            'Passengers / Seats Requested',
            passengers,
          ),

          _buildInfoRow(
            Icons.directions_car_outlined,
            'Vehicle',
            vehicle,
          ),

          _buildInfoRow(
            Icons.event_seat_outlined,
            'Available Seats',
            availableSeats,
          ),

          _buildInfoRow(
            Icons.currency_rupee,
            'Price Per Seat',
            '₹$pricePerSeat',
          ),

          _buildInfoRow(
            Icons.payments_outlined,
            'Total Booking Amount',
            totalPrice,
          ),

          if (message.trim().isNotEmpty)
            _buildInfoRow(
              Icons.message_outlined,
              'Passenger Message',
              message,
            ),

          if (isPending && bookingId != null) ...[
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
        message = 'New pending ride booking requests will appear here.';
        break;
      case 'Accepted':
        message = 'Your accepted ride booking requests will appear here.';
        break;
      case 'Rejected':
        message = 'Your rejected ride booking requests will appear here.';
        break;
      case 'Cancelled':
        message = 'Cancelled ride booking requests will appear here.';
        break;
      default:
        message = 'Your ride booking requests will appear here.';
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
          'Ride Requests',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            RideBookingStore.bookings,
            RideStore.publishedRides,
          ]),
          builder: (context, child) {
            final filteredBookings = _getFilteredBookings();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 5, 16, 16),
                  child: Text(
                    'Manage your incoming ride booking requests.',
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
