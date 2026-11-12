
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../services/ride_store.dart';
import '../../../services/ride_booking_store.dart';
import 'booking_success_screen.dart';

class BookingRequestScreen extends StatefulWidget {
  final Map<String, dynamic> ride;
  final String pickup;
  final String destination;
  final DateTime journeyDate;
  final TimeOfDay journeyTime;
  final int passengerCount;

  const BookingRequestScreen({
    super.key,
    required this.ride,
    required this.pickup,
    required this.destination,
    required this.journeyDate,
    required this.journeyTime,
    required this.passengerCount,
  });

  @override
  State<BookingRequestScreen> createState() =>
      _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  final TextEditingController _messageController =
  TextEditingController();

  bool _isSubmitting = false;

  int get _pricePerSeat {
    return int.tryParse(
      widget.ride['price'].toString().replaceAll(
        RegExp(r'[^0-9]'),
        '',
      ),
    ) ??
        0;
  }

  int get _totalPrice => _pricePerSeat * widget.passengerCount;

  int get _availableSeats {
    return int.tryParse(
      (widget.ride['seats'] ??
          widget.ride['availableSeats'] ??
          0)
          .toString(),
    ) ??
        0;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isPublishedRideActive() {
    final rideId = widget.ride['id'];

    // Sample rides have no ID, so they are not checked against RideStore.
    if (rideId == null) return true;

    final matchingRides = RideStore.publishedRides.value.where(
          (ride) => ride['id'] == rideId,
    );

    if (matchingRides.isEmpty) return false;

    return matchingRides.first['isActive'] == true;
  }

  Future<void> _sendRequest() async {
    if (_isSubmitting) return;

    if (!_isPublishedRideActive()) {
      _showMessage(
        'This ride is no longer available. Please search again.',
      );
      return;
    }

    if (widget.passengerCount > _availableSeats) {
      _showMessage(
        'Not enough seats available for your passengers.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Temporary demo delay. Backend API will replace this later.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    // Save booking request in the temporary booking store.
    RideBookingStore.addBooking(
      ride: widget.ride,
      pickup: widget.pickup,
      destination: widget.destination,
      journeyDate: widget.journeyDate,
      journeyTime: widget.journeyTime,
      passengerCount: widget.passengerCount,
      totalPrice: _totalPrice,
      message: _messageController.text.trim(),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSuccessScreen(
          ride: widget.ride,
          pickup: widget.pickup,
          destination: widget.destination,
          journeyDate: widget.journeyDate,
          passengerCount: widget.passengerCount,
          totalPrice: _totalPrice,
          message: _messageController.text.trim(),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
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
    final String driverName =
        widget.ride['driverName']?.toString() ??
            widget.ride['driver']?.toString() ??
            widget.ride['person']?.toString() ??
            'Driver';

    final String vehicleName =
        widget.ride['vehicle']?.toString() ?? 'Vehicle';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Request'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm your ride details',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Review your details before sending the request.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 22),

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
                    const Text(
                      'SELECTED RIDE',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      driverName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      vehicleName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Divider(
                      color: AppColors.border,
                      height: 28,
                    ),
                    _buildInfoRow('Pickup', widget.pickup),
                    _buildInfoRow('Destination', widget.destination),
                    _buildInfoRow(
                      'Journey Date',
                      '${widget.journeyDate.day}/${widget.journeyDate.month}/${widget.journeyDate.year}',
                    ),
                    _buildInfoRow(
                      'Journey Time',
                      widget.journeyTime.format(context),
                    ),
                    _buildInfoRow(
                      'Passengers',
                      '${widget.passengerCount}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Message to Driver',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write a message (optional)',
                ),
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Price per passenger',
                      '₹$_pricePerSeat',
                    ),
                    _buildInfoRow(
                      'Number of passengers',
                      '${widget.passengerCount}',
                    ),
                    const Divider(color: AppColors.border),
                    _buildInfoRow(
                      'Estimated total',
                      '₹$_totalPrice',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryLight,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your booking will remain pending until the driver accepts your request. This is an estimated amount.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _sendRequest,
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Send Booking Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
