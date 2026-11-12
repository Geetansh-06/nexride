
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/ride_store.dart';
import 'ride_published_screen.dart';

class ReviewRideScreen extends StatefulWidget {
  final Map<String, dynamic> rideDetails;
  final Map<String, dynamic> vehicleDetails;

  const ReviewRideScreen({
    super.key,
    required this.rideDetails,
    required this.vehicleDetails,
  });

  @override
  State<ReviewRideScreen> createState() => _ReviewRideScreenState();
}

class _ReviewRideScreenState extends State<ReviewRideScreen> {
  bool _isPublishing = false;

  Widget _detail(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  void _publishRide() {
    if (_isPublishing) return;

    setState(() {
      _isPublishing = true;
    });

    RideStore.addPublishedRide(
      rideDetails: widget.rideDetails,
      vehicleDetails: widget.vehicleDetails,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RidePublishedScreen(
          rideDetails: widget.rideDetails,
          vehicleDetails: widget.vehicleDetails,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ride = widget.rideDetails;
    final vehicle = widget.vehicleDetails;

    final int totalSeats =
    (vehicle['seatingCapacity'] as num).toInt();

    final int passengerSeats = totalSeats - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Review Your Ride'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Check your details',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Review your journey and vehicle information before publishing.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              _section('Journey Details', [
                _detail('Starting point', ride['from']),
                _detail('Destination', ride['to']),
                _detail('Journey date', ride['date']),
                _detail('Departure time', ride['time']),
                _detail('Available seats', ride['availableSeats']),
                _detail('Price per seat', '₹${ride['price']}'),
              ]),

              const SizedBox(height: 18),

              _section('Vehicle Details', [
                _detail('Brand', vehicle['brand']),
                _detail('Model', vehicle['model']),
                _detail('Registration', vehicle['registration']),
                _detail('Colour', vehicle['colour']),
                _detail('Vehicle type', vehicle['vehicleType']),
                _detail('Total seating capacity', '$totalSeats seats'),
                _detail('Passenger capacity', '$passengerSeats seats'),
              ]),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
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
                        'Please make sure all journey and vehicle information is correct before publishing.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isPublishing ? null : _publishRide,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isPublishing
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Publish Ride',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
