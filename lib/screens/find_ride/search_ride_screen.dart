
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/ride_store.dart';
import 'ride_details/ride_details_screen.dart';

class SearchRideScreen extends StatefulWidget {
  final String pickup;
  final String destination;
  final DateTime journeyDate;
  final TimeOfDay journeyTime;
  final int passengerCount;

  const SearchRideScreen({
    super.key,
    required this.pickup,
    required this.destination,
    required this.journeyDate,
    required this.journeyTime,
    required this.passengerCount,
  });

  @override
  State<SearchRideScreen> createState() => _SearchRideScreenState();
}

class _SearchRideScreenState extends State<SearchRideScreen> {
  // Location matching: case-insensitive and whitespace-insensitive.
  String _normalizeLocation(String location) {
    return location.trim().toLowerCase();
  }

  // Ride ki date ko DateTime mein convert karega.
  DateTime? _parseRideDate(dynamic date) {
    if (date == null) return null;

    if (date is DateTime) {
      return DateTime(date.year, date.month, date.day);
    }

    final dateString = date.toString().trim();

    // ISO date format: yyyy-MM-dd
    final parsedDate = DateTime.tryParse(dateString);

    if (parsedDate != null) {
      return DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
      );
    }

    // Indian date format: dd/MM/yyyy
    final parts = dateString.split('/');

    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day != null && month != null && year != null) {
        final result = DateTime(year, month, day);

        if (result.year == year &&
            result.month == month &&
            result.day == day) {
          return result;
        }
      }
    }

    return null;
  }

  bool _isSameDate(dynamic rideDate) {
    final parsedDate = _parseRideDate(rideDate);

    if (parsedDate == null) return false;

    return parsedDate.year == widget.journeyDate.year &&
        parsedDate.month == widget.journeyDate.month &&
        parsedDate.day == widget.journeyDate.day;
  }

  // Ride ke saved time ko minutes mein convert karega.
  // Supports: 10:30 AM, 6:00 PM and 18:00.
  int? _parseRideTime(dynamic time) {
    if (time == null) return null;

    final timeString = time.toString().trim().toUpperCase();

    if (timeString.isEmpty || timeString == '-') {
      return null;
    }

    final amPmPattern = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
    );

    final amPmMatch = amPmPattern.firstMatch(timeString);

    if (amPmMatch != null) {
      int hour = int.parse(amPmMatch.group(1)!);
      final minute = int.parse(amPmMatch.group(2)!);
      final period = amPmMatch.group(3)!;

      if (hour < 1 || hour > 12 || minute > 59) {
        return null;
      }

      if (period == 'AM') {
        if (hour == 12) hour = 0;
      } else {
        if (hour != 12) hour += 12;
      }

      return hour * 60 + minute;
    }

    // 24-hour format: HH:mm
    final twentyFourHourPattern = RegExp(
      r'^(\d{1,2}):(\d{2})$',
    );

    final twentyFourHourMatch =
    twentyFourHourPattern.firstMatch(timeString);

    if (twentyFourHourMatch != null) {
      final hour = int.parse(twentyFourHourMatch.group(1)!);
      final minute = int.parse(twentyFourHourMatch.group(2)!);

      if (hour < 0 || hour > 23 || minute > 59) {
        return null;
      }

      return hour * 60 + minute;
    }

    return null;
  }

  // Selected time se 60 minutes ke andar wali rides match hongi.
  bool _isWithinTimeWindow(dynamic rideTime) {
    final rideMinutes = _parseRideTime(rideTime);

    if (rideMinutes == null) return false;

    final selectedMinutes =
        widget.journeyTime.hour * 60 + widget.journeyTime.minute;

    final difference = (rideMinutes - selectedMinutes).abs();

    return difference <= 60;
  }

  // Sirf matching active rides return hongi.
  List<Map<String, dynamic>> get _availableRides {
    final requestedPickup = _normalizeLocation(widget.pickup);
    final requestedDestination =
    _normalizeLocation(widget.destination);

    return RideStore.publishedRides.value.where((ride) {
      // 1. Ride active honi chahiye.
      if (ride['isActive'] != true) return false;

      // 2. Pickup aur destination match hone chahiye.
      final ridePickup =
      _normalizeLocation(ride['from']?.toString() ?? '');

      final rideDestination =
      _normalizeLocation(ride['to']?.toString() ?? '');

      if (ridePickup != requestedPickup ||
          rideDestination != requestedDestination) {
        return false;
      }

      // 3. Journey date match honi chahiye.
      if (!_isSameDate(ride['date'])) {
        return false;
      }

      // 4. Ride selected time se 60 minutes ke andar honi chahiye.
      if (!_isWithinTimeWindow(ride['time'])) {
        return false;
      }

      // 5. Available seats passenger count ke barabar
      // ya usse zyada honi chahiye.
      final availableSeats = int.tryParse(
        ride['availableSeats']?.toString() ?? '',
      ) ?? 0;

      if (availableSeats < widget.passengerCount ||
          availableSeats <= 0) {
        return false;
      }

      return true;
    }).map((ride) {
      // RideStore data ko card format mein convert karna.
      return {
        ...ride,
        'driver': (ride['person'] ?? 'NexRide Driver').toString(),
        'vehicle': (ride['vehicle'] ?? 'Vehicle').toString(),
        'vehicleType':
        (ride['vehicleType'] ?? 'Vehicle').toString(),
        'departure': (ride['time'] ?? '-').toString(),
        'seats': ride['availableSeats'] ?? 0,
        'price': ride['price'] ?? 0,
        'rating': 'New',
      };
    }).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _openRideDetails(Map<String, dynamic> ride) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RideDetailsScreen(
          ride: ride,
          pickup: widget.pickup,
          destination: widget.destination,
          journeyDate: widget.journeyDate,
          journeyTime: widget.journeyTime,
          passengerCount: widget.passengerCount,
        ),
      ),
    );
  }

  Widget _buildRouteHeader() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.radio_button_checked,
                color: AppColors.primaryLight,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.pickup,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              height: 22,
              width: 1,
              color: AppColors.border,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.primaryLight,
                size: 19,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.destination,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: AppColors.border,
            height: 25,
          ),
          Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              _buildInfo(
                Icons.calendar_today_outlined,
                _formatDate(widget.journeyDate),
              ),
              _buildInfo(
                Icons.access_time_rounded,
                widget.journeyTime.format(context),
              ),
              _buildInfo(
                Icons.people_outline_rounded,
                '${widget.passengerCount} passenger(s)',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor:
                AppColors.primary.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primaryLight,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride['driver'].toString(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ride['rating'].toString(),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '₹${ride['price']}',
                style: const TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car_outlined,
                  color: AppColors.primaryLight,
                  size: 23,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['vehicle'].toString(),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        ride['vehicleType'].toString(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  ride['departure'].toString(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.event_seat_outlined,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 7),
              Text(
                '${ride['seats']} seats available',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                '₹${ride['price']} per seat',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton(
              onPressed: () => _openRideDetails(ride),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryLight,
                side: const BorderSide(
                  color: AppColors.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('View Ride'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 40,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12),
          Text(
            'No Matching Rides Found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try another date or route, or check back later for available rides.',
            textAlign: TextAlign.center,
            style: TextStyle(
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
        title: const Text('Available Rides'),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: RideStore.publishedRides,
          builder: (context, child) {
            final rides = _availableRides;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRouteHeader(),
                  const SizedBox(height: 25),
                  const Text(
                    'Rides for your journey',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${rides.length} matching ride(s) found',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (rides.isEmpty)
                    _buildEmptyState()
                  else
                    ...rides.map(_buildRideCard),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
