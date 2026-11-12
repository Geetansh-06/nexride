import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/vehicle_store.dart';
import '../profile/my_vehicles_screen.dart';
import 'review_ride_screen.dart';

class SelectVehicleScreen extends StatefulWidget {
  final Map<String, dynamic> rideDetails;

  const SelectVehicleScreen({
    super.key,
    required this.rideDetails,
  });

  @override
  State<SelectVehicleScreen> createState() =>
      _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  String? _selectedVehicleId;

  Future<void> _addVehicle() async {
    final previousIds = VehicleStore.vehicles.value
        .map((vehicle) => vehicle['id'].toString())
        .toSet();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyVehiclesScreen(),
      ),
    );

    if (!mounted) return;

    final currentVehicles = VehicleStore.vehicles.value;

    final newlyAdded = currentVehicles.where(
          (vehicle) => !previousIds.contains(vehicle['id'].toString()),
    ).toList();

    setState(() {
      if (newlyAdded.isNotEmpty) {
        _selectedVehicleId = newlyAdded.last['id'].toString();
      }
    });
  }

  void _continue() {
    if (_selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a vehicle to continue.'),
        ),
      );
      return;
    }

    final matchingVehicles = VehicleStore.vehicles.value.where(
          (vehicle) => vehicle['id'].toString() == _selectedVehicleId,
    );

    if (matchingVehicles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selected vehicle is no longer available.'),
        ),
      );

      setState(() {
        _selectedVehicleId = null;
      });

      return;
    }

    final vehicleDetails =
    Map<String, dynamic>.from(matchingVehicles.first);

    final availableSeats =
    (widget.rideDetails['availableSeats'] as num).toInt();

    final seatingCapacity =
    (vehicleDetails['seatingCapacity'] as num).toInt();

    final passengerCapacity = seatingCapacity - 1;

    if (availableSeats > passengerCapacity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This vehicle can accommodate only '
                '$passengerCapacity passengers. Please update '
                'the available seats or select another vehicle.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewRideScreen(
          rideDetails: widget.rideDetails,
          vehicleDetails: vehicleDetails,
        ),
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    final vehicleId = vehicle['id'].toString();
    final isSelected = _selectedVehicleId == vehicleId;

    final brand = vehicle['brand'] ?? '';
    final model = vehicle['model'] ?? '';
    final registration = vehicle['registration'] ?? '';
    final colour = vehicle['colour'] ?? '';
    final type = vehicle['vehicleType'] ?? '';
    final seats = vehicle['seatingCapacity'] ?? 0;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedVehicleId = vehicleId;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.border,
            width: isSelected ? 1.7 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: AppColors.primaryLight,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$brand $model',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        registration,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected
                      ? AppColors.primaryLight
                      : AppColors.textSecondary,
                  size: 23,
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Divider(color: AppColors.border),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _vehicleInfo(
                    Icons.category_outlined,
                    type.toString(),
                  ),
                ),
                Expanded(
                  child: _vehicleInfo(
                    Icons.palette_outlined,
                    colour.toString(),
                  ),
                ),
                Expanded(
                  child: _vehicleInfo(
                    Icons.event_seat_outlined,
                    '$seats Seats',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryLight,
          size: 16,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car_outlined,
                color: AppColors.primaryLight,
                size: 45,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Saved Vehicles',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 9),

            const Text(
              'Add a vehicle to your profile first. '
                  'You can then select it for your ride.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: _addVehicle,
              icon: const Icon(Icons.add),
              label: const Text('Add Vehicle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Select Vehicle',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: VehicleStore.vehicles,
          builder: (context, vehicles, child) {
            if (vehicles.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    children: [
                      const Text(
                        'Choose Your Vehicle',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Select one of your saved vehicles for this journey.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 22),

                      ...vehicles.map(_buildVehicleCard),

                      const SizedBox(height: 5),

                      OutlinedButton.icon(
                        onPressed: _addVehicle,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Another Vehicle'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryLight,
                          side: const BorderSide(
                            color: AppColors.primaryLight,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}