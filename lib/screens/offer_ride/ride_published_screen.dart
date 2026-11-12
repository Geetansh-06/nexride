
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class RidePublishedScreen extends StatefulWidget {
  final Map<String, dynamic> rideDetails;
  final Map<String, dynamic> vehicleDetails;

  const RidePublishedScreen({
    super.key,
    required this.rideDetails,
    required this.vehicleDetails,
  });

  @override
  State<RidePublishedScreen> createState() =>
      _RidePublishedScreenState();
}

class _RidePublishedScreenState extends State<RidePublishedScreen> {
  @override
  Widget build(BuildContext context) {
    final ride = widget.rideDetails;
    final vehicle = widget.vehicleDetails;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 75,
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Ride Published!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Your ride has been published successfully in this demo flow.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Ride Summary',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          const Icon(
                            Icons.trip_origin,
                            color: AppColors.primaryLight,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ride['from']?.toString() ?? '-',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primaryLight,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ride['to']?.toString() ?? '-',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(
                        color: AppColors.border,
                        height: 28,
                      ),

                      _summaryRow(
                        'Journey Date',
                        ride['date']?.toString() ?? '-',
                      ),

                      _summaryRow(
                        'Departure Time',
                        ride['time']?.toString() ?? '-',
                      ),

                      _summaryRow(
                        'Available Seats',
                        ride['availableSeats']?.toString() ?? '-',
                      ),

                      _summaryRow(
                        'Price Per Seat',
                        '₹${ride['price'] ?? '-'}',
                      ),

                      const Divider(
                        color: AppColors.border,
                        height: 28,
                      ),

                      const Text(
                        'Vehicle Details',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _summaryRow(
                        'Vehicle',
                        '${vehicle['brand'] ?? ''} ${vehicle['model'] ?? ''}'.trim().isEmpty
                            ? '-'
                            : '${vehicle['brand'] ?? ''} ${vehicle['model'] ?? ''}'.trim(),
                      ),

                      _summaryRow(
                        'Vehicle Type',
                        vehicle['vehicleType']?.toString() ?? '-',
                      ),

                      _summaryRow(
                        'Vehicle Colour',
                        vehicle['colour']?.toString() ?? '-',
                      ),

                      _summaryRow(
                        'Registration Number',
                        vehicle['registration']?.toString() ?? '-',
                      ),

                      _summaryRow(
                        'Seating Capacity',
                        vehicle['seatingCapacity']?.toString() ?? '-',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                            (route) => route.isFirst,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
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
          Flexible(
            child: Text(
              value,
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
}
