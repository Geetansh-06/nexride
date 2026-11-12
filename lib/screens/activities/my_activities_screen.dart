
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/ride_store.dart';
import '../../services/ride_booking_store.dart';
import '../../services/driver_service_store.dart';
import '../../services/driver_booking_store.dart';
import '../hire_driver/driver_booking_details_screen.dart';

class MyActivitiesScreen extends StatefulWidget {
  const MyActivitiesScreen({super.key});

  @override
  State<MyActivitiesScreen> createState() => _MyActivitiesScreenState();
}

class _MyActivitiesScreenState extends State<MyActivitiesScreen> {
  int selectedCategory = 0;
  String selectedStatus = 'All';

  final List<String> categories = [
    'Ride Bookings',
    'Published Rides',
    'Driver Bookings',
    'Driver Jobs',
  ];

  // Booking categories aur published services ke filters alag hain.
  List<String> get visibleStatuses {
    if (selectedCategory == 1 || selectedCategory == 3) {
      return ['All', 'Active', 'Inactive'];
    }

    return [
      'All',
      'Pending',
      'Accepted',
      'Rejected',
      'Completed',
      'Cancelled',
    ];
  }

  String _formatBookingDate(dynamic value) {
    if (value is DateTime) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];

      return '${value.day.toString().padLeft(2, '0')} '
          '${months[value.month - 1]} ${value.year}';
    }

    return value?.toString() ?? 'Not provided';
  }

  String _formatBookingTime(dynamic value) {
    if (value is TimeOfDay) {
      final int hour =
      value.hourOfPeriod == 0 ? 12 : value.hourOfPeriod;

      final String minute =
      value.minute.toString().padLeft(2, '0');

      final String period =
      value.period == DayPeriod.am ? 'AM' : 'PM';

      return '$hour:$minute $period';
    }

    return value?.toString() ?? 'Not provided';
  }

  // Real Ride Bookings.
  List<Map<String, dynamic>> get rideBookings {
    return RideBookingStore.bookings.value.map((booking) {
      final ride =
          booking['ride'] as Map<String, dynamic>? ?? {};

      final String pickup =
          booking['pickup']?.toString() ?? 'Not provided';

      final String destination =
          booking['destination']?.toString() ?? 'Not provided';

      final String driverName =
          ride['driver']?.toString() ??
              ride['driverName']?.toString() ??
              ride['person']?.toString() ??
              'Ride Provider';

      return {
        'category': 0,
        'title': 'Ride Booking',
        'route': '$pickup → $destination',
        'date': _formatBookingDate(booking['journeyDate']),
        'time': _formatBookingTime(booking['journeyTime']),
        'person': driverName,
        'status': booking['status']?.toString() ?? 'Pending',
        'amount': '₹${booking['totalPrice'] ?? 0}',
        'passengerCount': booking['passengerCount'] ?? 0,
        'bookingId': booking['id']?.toString() ?? '',
        'booking': booking,
        'ride': ride,
      };
    }).toList();
  }

  // Real Driver Bookings.
  List<Map<String, dynamic>> get driverBookings {
    return DriverBookingStore.bookings.value.map((booking) {
      final details =
          booking['bookingDetails'] as Map<String, dynamic>? ?? {};

      final String pickup =
          details['pickup']?.toString() ?? 'Not provided';

      final String destination =
          details['destination']?.toString() ?? 'Not provided';

      final String serviceName =
      details['serviceType'] == 'my_car'
          ? 'Driver for My Car'
          : 'Driver with Vehicle';

      return {
        'category': 2,
        'title': 'Driver Booking',
        'route': '$pickup → $destination',
        'date': _formatBookingDate(details['journeyDate']),
        'time': _formatBookingTime(details['journeyTime']),
        'person': serviceName,
        'status': booking['status']?.toString() ?? 'Pending',
        'amount': 'Not quoted',
        'bookingId': booking['bookingId']?.toString() ?? '',
        'serviceType': details['serviceType'],
        'tripType': details['tripType'],
        'booking': booking,
      };
    }).toList();
  }

  // Published Rides: status is controlled by isActive.
  List<Map<String, dynamic>> get publishedRides {
    return RideStore.publishedRides.value.map((ride) {
      return {
        ...ride,
        'category': 1,
        'status': ride['isActive'] == true ? 'Active' : 'Inactive',
      };
    }).toList();
  }

  // Driver Jobs: status is controlled by isActive.
  List<Map<String, dynamic>> get driverJobs {
    return DriverServiceStore.publishedServices.value.map((service) {
      return {
        ...service,
        'category': 3,
        'status': service['isActive'] == true ? 'Active' : 'Inactive',
      };
    }).toList();
  }

  // All real activities from the four stores.
  List<Map<String, dynamic>> get allActivities {
    return [
      ...rideBookings,
      ...publishedRides,
      ...driverBookings,
      ...driverJobs,
    ];
  }

  List<Map<String, dynamic>> get filteredActivities {
    return allActivities.where((activity) {
      final matchesCategory =
          activity['category'] == selectedCategory;

      final matchesStatus =
          selectedStatus == 'All' ||
              activity['status'] == selectedStatus;

      return matchesCategory && matchesStatus;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.warning;

      case 'Accepted':
      case 'Completed':
      case 'Active':
        return AppColors.success;

      case 'Rejected':
      case 'Cancelled':
        return AppColors.error;

      case 'Inactive':
        return AppColors.textSecondary;

      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
        const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
                selectedStatus = 'All';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
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
                      : AppColors.border,
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
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

  Widget _buildStatusSelector() {
    final statuses = visibleStatuses;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (context, index) =>
        const SizedBox(width: 8),
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
                horizontal: 14,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryLight
                      : AppColors.textSecondary,
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

  void _openDriverBookingDetails(
      Map<String, dynamic> activity,
      ) {
    final booking = activity['booking'];

    if (booking is! Map<String, dynamic>) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverBookingDetailsScreen(
          booking: booking,
        ),
      ),
    );
  }

  // Cancel ride booking confirmation.
  Future<void> _confirmCancelBooking(
      Map<String, dynamic> activity,
      ) async {
    final booking = activity['booking'];

    if (booking is! Map<String, dynamic>) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text(
            'Cancel Booking?',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'Are you sure you want to cancel this ride booking?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Keep Booking'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Cancel Booking'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final bookingId =
    int.tryParse(booking['id']?.toString() ?? '');

    if (bookingId == null) return;

    final success = RideBookingStore.cancelBooking(bookingId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Ride booking cancelled successfully.'
              : 'Unable to cancel this booking.',
        ),
        backgroundColor:
        success ? AppColors.success : AppColors.error,
      ),
    );
  }

  Widget _buildActivityCard(
      Map<String, dynamic> activity,
      ) {
    final status = activity['status'] as String? ?? 'Pending';
    final statusColor = _statusColor(status);
    final category = activity['category'];

    final bool isRealRideBooking =
        category == 0 && activity['booking'] != null;

    final bool canCancelRideBooking =
        isRealRideBooking &&
            (status == 'Pending' || status == 'Accepted');

    return GestureDetector(
      onTap: category == 2 && activity['booking'] != null
          ? () => _openDriverBookingDetails(activity)
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    activity['title']?.toString() ?? '-',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(
                  Icons.trip_origin,
                  color: AppColors.primaryLight,
                  size: 17,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    activity['route']?.toString() ?? '-',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 13),

            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  color: AppColors.textSecondary,
                  size: 17,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    activity['person']?.toString() ?? '-',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 9),
                Text(
                  activity['date']?.toString() ?? '-',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.access_time,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  activity['time']?.toString() ?? '-',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Divider(
              color: AppColors.border,
              height: 25,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amount',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  activity['amount']?.toString() ?? '-',
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Ride Booking details.
            if (isRealRideBooking) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.border),
              const SizedBox(height: 5),

              _extraDetail(
                'Booking ID',
                activity['bookingId']?.toString() ?? '-',
              ),

              _extraDetail(
                'Passengers',
                activity['passengerCount']?.toString() ?? '-',
              ),

              if (canCancelRideBooking) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _confirmCancelBooking(activity),
                    icon: const Icon(Icons.close, size: 17),
                    label: const Text('Cancel Booking'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],

            // Published Ride details.
            if (category == 1) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.border),
              const SizedBox(height: 5),

              _extraDetail(
                'Vehicle',
                activity['vehicle']?.toString() ?? '-',
              ),

              _extraDetail(
                'Registration',
                activity['registration']?.toString() ?? '-',
              ),

              _extraDetail(
                'Available seats',
                activity['availableSeats']?.toString() ?? '-',
              ),
            ],

            // Driver Booking details.
            if (category == 2 && activity['bookingId'] != null) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.border),
              const SizedBox(height: 5),

              _extraDetail(
                'Booking ID',
                activity['bookingId'].toString(),
              ),

              _extraDetail(
                'Service Type',
                activity['person']?.toString() ?? '-',
              ),

              _extraDetail(
                'Trip Type',
                activity['tripType']?.toString() ?? '-',
              ),

              const SizedBox(height: 8),

              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View Booking Details',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primaryLight,
                    size: 12,
                  ),
                ],
              ),
            ],

            // Published Driver Service details.
            if (category == 3 &&
                activity['serviceType'] != null) ...[
              const SizedBox(height: 12),
              const Divider(color: AppColors.border),
              const SizedBox(height: 5),

              _extraDetail(
                'City',
                activity['city']?.toString() ?? '-',
              ),

              _extraDetail(
                'Service Area',
                activity['area']?.toString() ?? '-',
              ),

              _extraDetail(
                'Service Type',
                activity['serviceType']?.toString() ?? '-',
              ),

              _extraDetail(
                'Availability',
                activity['availability']?.toString() ?? '-',
              ),

              _extraDetail(
                'Experience',
                '${activity['experience'] ?? '-'} years',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _extraDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;

    switch (selectedCategory) {
      case 0:
        message = 'Your ride bookings will appear here.';
        break;

      case 1:
        message = 'Your published rides will appear here.';
        break;

      case 2:
        message = 'Your driver bookings will appear here.';
        break;

      case 3:
        message = 'Your driver services will appear here.';
        break;

      default:
        message = 'No activities available.';
    }

    if (selectedStatus != 'All') {
      message = 'No $selectedStatus activities found in this category.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_note_outlined,
            color: AppColors.textSecondary,
            size: 45,
          ),
          const SizedBox(height: 13),
          const Text(
            'No activities found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Activities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 18),
              child: Text(
                'Manage your rides and bookings in one place.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCategorySelector(),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildStatusSelector(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  RideStore.publishedRides,
                  RideBookingStore.bookings,
                  DriverServiceStore.publishedServices,
                  DriverBookingStore.bookings,
                ]),
                builder: (context, child) {
                  final filtered = filteredActivities;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your Activities',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${filtered.length} found',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 13),

                      Expanded(
                        child: filtered.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: _buildEmptyState(),
                        )
                            : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            20, 0, 20, 20,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _buildActivityCard(
                              filtered[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
