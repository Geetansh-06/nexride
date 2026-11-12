
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/vehicle_store.dart';
import '../profile/my_vehicles_screen.dart';

class DriverRequirementsScreen extends StatefulWidget {
  final Map<String, dynamic> tripDetails;

  const DriverRequirementsScreen({
    super.key,
    required this.tripDetails,
  });

  @override
  State<DriverRequirementsScreen> createState() =>
      _DriverRequirementsScreenState();
}

class _DriverRequirementsScreenState
    extends State<DriverRequirementsScreen> {
  final TextEditingController passengersController =
  TextEditingController(text: '4');

  final TextEditingController notesController =
  TextEditingController();

  Map<String, dynamic>? selectedVehicle;

  String? vehicleType;
  String? transmission;
  String? experience;
  String? driverTransmission;

  bool get isMyCar =>
      widget.tripDetails['serviceType'] == 'my_car';

  @override
  void dispose() {
    passengersController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _openMyVehicles() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyVehiclesScreen(),
      ),
    );

    if (!mounted) return;

    final vehicles = VehicleStore.vehicles.value;

    if (vehicles.isNotEmpty) {
      setState(() {
        if (selectedVehicle == null) {
          selectedVehicle = Map<String, dynamic>.from(
            vehicles.last,
          );
        } else {
          final updatedVehicle = vehicles.firstWhere(
                (vehicle) =>
            vehicle['id'] == selectedVehicle!['id'],
            orElse: () => {},
          );

          if (updatedVehicle.isNotEmpty) {
            selectedVehicle = Map<String, dynamic>.from(
              updatedVehicle,
            );
          }
        }

        vehicleType =
            selectedVehicle?['vehicleType']?.toString();
      });
    }
  }

  void _selectVehicle(Map<String, dynamic> vehicle) {
    setState(() {
      selectedVehicle = Map<String, dynamic>.from(vehicle);
      vehicleType = vehicle['vehicleType']?.toString();
    });
  }

  Widget _buildHeading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: AppColors.card,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.primaryLight,
              ),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryLight,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSavedVehicleCard(
      Map<String, dynamic> vehicle,
      ) {
    final bool isSelected =
        selectedVehicle?['id'] == vehicle['id'];

    final brand = vehicle['brand']?.toString() ?? '';
    final model = vehicle['model']?.toString() ?? '';

    return GestureDetector(
      onTap: () => _selectVehicle(vehicle),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.10)
              : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.directions_car_outlined,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$brand $model'.trim(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${vehicle['vehicleType'] ?? '-'} · ${vehicle['registration'] ?? '-'}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Colour: ${vehicle['colour'] ?? '-'} · Seats: ${vehicle['seatingCapacity'] ?? '-'}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.primaryLight
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyCarVehicleSelector() {
    return AnimatedBuilder(
      animation: VehicleStore.vehicles,
      builder: (context, child) {
        final vehicles = VehicleStore.vehicles.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Select Your Car'),

            if (vehicles.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      color: AppColors.textSecondary,
                      size: 35,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No saved vehicles found.',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Add your car to continue with this booking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildAddVehicleButton(),
                  ],
                ),
              )
            else ...[
              ...vehicles.map(_buildSavedVehicleCard),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openMyVehicles,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Another Vehicle'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: const BorderSide(
                      color: AppColors.primaryLight,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAddVehicleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _openMyVehicles,
        icon: const Icon(Icons.add),
        label: const Text('Add Vehicle'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _continue() {
    if (isMyCar && selectedVehicle == null) {
      _showMessage('Please select your car.');
      return;
    }

    if (!isMyCar &&
        (vehicleType == null || vehicleType!.isEmpty)) {
      _showMessage('Please select a vehicle type.');
      return;
    }

    if (!isMyCar &&
        (passengersController.text.trim().isEmpty ||
            int.tryParse(passengersController.text.trim()) == null ||
            int.parse(passengersController.text.trim()) < 1)) {
      _showMessage('Please enter a valid passenger count.');
      return;
    }

    if (isMyCar && transmission == null) {
      _showMessage('Please select your car transmission.');
      return;
    }

    if (experience == null || driverTransmission == null) {
      _showMessage('Please complete driver requirements.');
      return;
    }

    final Map<String, dynamic> requirements = {
      'serviceType': widget.tripDetails['serviceType'],
      'vehicleType': isMyCar
          ? selectedVehicle!['vehicleType']
          : vehicleType,
      'vehicleBrand': isMyCar
          ? selectedVehicle!['brand']
          : null,
      'vehicleModel': isMyCar
          ? selectedVehicle!['model']
          : null,
      'vehicleId': isMyCar
          ? selectedVehicle!['id']
          : null,
      'vehicleRegistration': isMyCar
          ? selectedVehicle!['registration']
          : null,
      'vehicleColour': isMyCar
          ? selectedVehicle!['colour']
          : null,
      'vehicleSeatingCapacity': isMyCar
          ? selectedVehicle!['seatingCapacity']
          : null,
      'vehicleDetails': isMyCar
          ? Map<String, dynamic>.from(selectedVehicle!)
          : null,
      'passengers': isMyCar
          ? null
          : passengersController.text.trim(),
      'vehicleTransmission': transmission,
      'driverExperience': experience,
      'driverTransmission': driverTransmission,
      'additionalNotes': notesController.text.trim(),
    };

    final Map<String, dynamic> completeDetails = {
      ...widget.tripDetails,
      ...requirements,
    };

    Navigator.pop(context, completeDetails);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
          'Vehicle & Driver Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeading(
                      isMyCar
                          ? 'Tell us about your car'
                          : 'Choose your vehicle',
                      isMyCar
                          ? 'Select your saved car and set your driver preferences.'
                          : 'Select the vehicle you need with a driver.',
                    ),

                    const SizedBox(height: 24),

                    _buildSectionCard(
                      title: 'Vehicle Details',
                      children: [
                        if (isMyCar) ...[
                          _buildMyCarVehicleSelector(),
                          const SizedBox(height: 18),
                          _buildDropdown(
                            label: 'Car Transmission',
                            hint: 'Select transmission',
                            value: transmission,
                            items: [
                              'Manual',
                              'Automatic',
                            ],
                            onChanged: (value) {
                              setState(() {
                                transmission = value;
                              });
                            },
                          ),
                        ] else ...[
                          _buildDropdown(
                            label: 'Vehicle Category',
                            hint: 'Select vehicle category',
                            value: vehicleType,
                            items: [
                              'Hatchback',
                              'Sedan',
                              'SUV',
                              'MUV',
                              'Luxury',
                            ],
                            onChanged: (value) {
                              setState(() {
                                vehicleType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 18),
                          _buildTextField(
                            label: 'Number of Passengers',
                            hint: 'Enter passenger count',
                            controller: passengersController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSectionCard(
                      title: 'Driver Requirements',
                      children: [
                        _buildDropdown(
                          label: 'Driving Experience',
                          hint: 'Minimum experience required',
                          value: experience,
                          items: [
                            '1+ years',
                            '2+ years',
                            '5+ years',
                            '10+ years',
                          ],
                          onChanged: (value) {
                            setState(() {
                              experience = value;
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        _buildDropdown(
                          label: 'Driver Transmission Preference',
                          hint: 'Select preference',
                          value: driverTransmission,
                          items: [
                            'Manual',
                            'Automatic',
                            'Both',
                          ],
                          onChanged: (value) {
                            setState(() {
                              driverTransmission = value;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildTextField(
                      label: 'Additional Requirements (Optional)',
                      hint: 'Any other instructions for the driver...',
                      controller: notesController,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20, 12, 20, 20,
              ),
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
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
