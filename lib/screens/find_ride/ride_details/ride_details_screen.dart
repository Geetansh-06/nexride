
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../booking/booking_request_screen.dart';

class RideDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ride;
  final String pickup;
  final String destination;
  final DateTime journeyDate;
  final TimeOfDay journeyTime;
  final int passengerCount;

  const RideDetailsScreen({
    super.key,
    required this.ride,
    required this.pickup,
    required this.destination,
    required this.journeyDate,
    required this.journeyTime,
    required this.passengerCount,
  });

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  void _openBookingRequest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingRequestScreen(
          ride: widget.ride,
          pickup: widget.pickup,
          destination: widget.destination,
          journeyDate: widget.journeyDate,
          journeyTime: widget.journeyTime,
          passengerCount: widget.passengerCount,
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample aur published rides dono ke keys support hongi.
    final String driverName =
        widget.ride['driverName']?.toString() ??
            widget.ride['driver']?.toString() ??
            widget.ride['person']?.toString() ??
            'Driver';

    final String vehicle =
        widget.ride['vehicle']?.toString() ?? 'Vehicle';

    final String vehicleType =
        widget.ride['vehicleType']?.toString() ?? 'Car';

    final String departure =
        widget.ride['departure']?.toString() ??
            widget.ride['time']?.toString() ??
            'Not specified';

    final String seats =
        widget.ride['seats']?.toString() ??
            widget.ride['availableSeats']?.toString() ??
            'Not specified';

    final String price =
        '₹${widget.ride['price'] ?? 'Not specified'}';

    final String rating =
        widget.ride['rating']?.toString() ?? 'New';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR JOURNEY',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.radio_button_checked,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.pickup,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        height: 30,
                        width: 2,
                        color: AppColors.border,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.destination,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Driver Information',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
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
                        const CircleAvatar(
                          radius: 27,
                          backgroundColor: AppColors.surface,
                          child: Icon(
                            Icons.person,
                            color: AppColors.primaryLight,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driverName,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.warning,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    rating,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: AppColors.border,
                      height: 28,
                    ),
                    _detailRow('Vehicle', vehicle),
                    _detailRow('Vehicle type', vehicleType),
                    _detailRow('Departure time', departure),
                    _detailRow('Available seats', seats),
                    _detailRow('Price per seat', price),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Your Booking',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _detailRow(
                      'Journey date',
                      '${widget.journeyDate.day}/${widget.journeyDate.month}/${widget.journeyDate.year}',
                    ),
                    _detailRow(
                      'Journey time',
                      widget.journeyTime.format(context),
                    ),
                    _detailRow(
                      'Passengers',
                      '${widget.passengerCount}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openBookingRequest,
                  child: const Text('Request to Book'),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'Booking will be confirmed after driver approval.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
