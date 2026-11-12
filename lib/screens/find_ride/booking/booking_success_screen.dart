
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BookingSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> ride;
  final String pickup;
  final String destination;
  final DateTime journeyDate;
  final int passengerCount;
  final int totalPrice;
  final String message;

  const BookingSuccessScreen({
    super.key,
    required this.ride,
    required this.pickup,
    required this.destination,
    required this.journeyDate,
    required this.passengerCount,
    required this.totalPrice,
    required this.message,
  });

  @override
  State<BookingSuccessScreen> createState() =>
      _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final String driverName =
        widget.ride['driverName']?.toString() ?? 'Driver';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Booking Status'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 95,
                width: 95,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 48,
                  color: AppColors.warning,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Request Submitted!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your demo booking request has been submitted. The driver needs to accept it before your booking can be confirmed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'REQUEST STATUS',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'PENDING',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(
                      color: AppColors.border,
                      height: 28,
                    ),

                    _detailRow('Driver', driverName),
                    _detailRow('From', widget.pickup),
                    _detailRow('To', widget.destination),
                    _detailRow(
                      'Passengers',
                      '${widget.passengerCount}',
                    ),
                    _detailRow(
                      'Total estimate',
                      '₹${widget.totalPrice}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                  );
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
