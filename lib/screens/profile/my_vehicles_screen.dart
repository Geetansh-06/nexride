import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/vehicle_store.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  final List<String> _vehicleTypes = [
    'Hatchback',
    'Sedan',
    'SUV',
    'MUV',
  ];

  Future<void> _openVehicleForm({
    Map<String, dynamic>? vehicle,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return _VehicleFormSheet(
          vehicle: vehicle,
          vehicleTypes: _vehicleTypes,
        );
      },
    );

    if (!mounted || result != true) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          vehicle == null
              ? 'Vehicle added successfully.'
              : 'Vehicle updated successfully.',
        ),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  Future<void> _deleteVehicle(Map<String, dynamic> vehicle) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text(
            'Delete Vehicle?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this vehicle?',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    VehicleStore.deleteVehicle(vehicle['id'].toString());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vehicle deleted successfully.'),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    final brand = vehicle['brand'] ?? '';
    final model = vehicle['model'] ?? '';
    final registration = vehicle['registration'] ?? '';
    final colour = vehicle['colour'] ?? '';
    final vehicleType = vehicle['vehicleType'] ?? '';
    final seatingCapacity = vehicle['seatingCapacity'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(17),
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
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(13),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      registration,
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                color: AppColors.surface,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.textSecondary,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _openVehicleForm(vehicle: vehicle);
                  } else if (value == 'delete') {
                    _deleteVehicle(vehicle);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: AppColors.textPrimary,
                          size: 19,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                          size: 19,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 17),

          const Divider(color: AppColors.border),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _vehicleInfo(
                  Icons.category_outlined,
                  'Category',
                  vehicleType,
                ),
              ),
              Expanded(
                child: _vehicleInfo(
                  Icons.palette_outlined,
                  'Colour',
                  colour,
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          _vehicleInfo(
            Icons.event_seat_outlined,
            'Total Seating Capacity',
            '$seatingCapacity Seats',
          ),

          const SizedBox(height: 5),

          Text(
            'Passenger seats: ${seatingCapacity is num ? seatingCapacity.toInt() - 1 : 0}',
            style: const TextStyle(
              color: AppColors.primaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleInfo(
      IconData icon,
      String label,
      String value,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 95,
              width: 95,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car_outlined,
                size: 48,
                color: AppColors.primaryLight,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'No Vehicles Added Yet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 9),

            const Text(
              'Add your vehicle details to manage your vehicles in one place.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () => _openVehicleForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Vehicle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
          'My Vehicles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _openVehicleForm(),
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.primaryLight,
              size: 27,
            ),
            tooltip: 'Add Vehicle',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: VehicleStore.vehicles,
          builder: (context, vehicles, child) {
            if (vehicles.isEmpty) {
              return _buildEmptyState();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
              children: [
                Text(
                  '${vehicles.length} ${vehicles.length == 1 ? 'Vehicle' : 'Vehicles'} Added',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                ...vehicles.map(_buildVehicleCard),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Add / Edit Vehicle Form

class _VehicleFormSheet extends StatefulWidget {
  final Map<String, dynamic>? vehicle;
  final List<String> vehicleTypes;

  const _VehicleFormSheet({
    this.vehicle,
    required this.vehicleTypes,
  });

  @override
  State<_VehicleFormSheet> createState() => _VehicleFormSheetState();
}

class _VehicleFormSheetState extends State<_VehicleFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _registrationController;
  late final TextEditingController _colourController;

  String? _selectedVehicleType;
  late int _seatingCapacity;

  bool get _isEditing => widget.vehicle != null;

  @override
  void initState() {
    super.initState();

    final vehicle = widget.vehicle;

    _brandController = TextEditingController(
      text: vehicle?['brand']?.toString() ?? '',
    );

    _modelController = TextEditingController(
      text: vehicle?['model']?.toString() ?? '',
    );

    _registrationController = TextEditingController(
      text: vehicle?['registration']?.toString() ?? '',
    );

    _colourController = TextEditingController(
      text: vehicle?['colour']?.toString() ?? '',
    );

    _selectedVehicleType = vehicle?['vehicleType']?.toString();

    _seatingCapacity =
        (vehicle?['seatingCapacity'] as num?)?.toInt() ?? 5;
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _registrationController.dispose();
    _colourController.dispose();
    super.dispose();
  }

  String? _validateRegistration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter registration number';
    }

    final registration = value.trim().toUpperCase();

    final alreadyExists = VehicleStore.vehicles.value.any((vehicle) {
      final sameRegistration =
          vehicle['registration'].toString().toUpperCase() ==
              registration;

      final isCurrentVehicle =
          vehicle['id'] == widget.vehicle?['id'];

      return sameRegistration && !isCurrentVehicle;
    });

    if (alreadyExists) {
      return 'This vehicle is already added';
    }

    return null;
  }

  void _saveVehicle() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedVehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select vehicle type.'),
        ),
      );
      return;
    }

    final vehicleDetails = <String, dynamic>{
      'brand': _brandController.text.trim(),
      'model': _modelController.text.trim(),
      'registration':
      _registrationController.text.trim().toUpperCase(),
      'colour': _colourController.text.trim(),
      'vehicleType': _selectedVehicleType,
      'seatingCapacity': _seatingCapacity,
    };

    if (_isEditing) {
      VehicleStore.updateVehicle(
        widget.vehicle!['id'].toString(),
        vehicleDetails,
      );
    } else {
      VehicleStore.addVehicle(vehicleDetails);
    }

    Navigator.pop(context, true);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.words,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          textCapitalization: textCapitalization,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
          validator: validator ??
                  (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.primaryLight,
            ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
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
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seatButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryLight,
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isEditing ? 'Edit Vehicle' : 'Add New Vehicle',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Enter your vehicle information below.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildTextField(
                    controller: _brandController,
                    label: 'Vehicle Brand',
                    hint: 'e.g. Maruti Suzuki',
                    icon: Icons.directions_car_outlined,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _modelController,
                    label: 'Vehicle Model',
                    hint: 'e.g. Swift',
                    icon: Icons.car_repair_rounded,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _registrationController,
                    label: 'Registration Number',
                    hint: 'e.g. UP80 AB 1234',
                    icon: Icons.confirmation_number_outlined,
                    textCapitalization: TextCapitalization.characters,
                    validator: _validateRegistration,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _colourController,
                    label: 'Vehicle Colour',
                    hint: 'e.g. White',
                    icon: Icons.palette_outlined,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Vehicle Type',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _selectedVehicleType,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.card,
                      prefixIcon: const Icon(
                        Icons.category_outlined,
                        color: AppColors.primaryLight,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                    ),
                    hint: const Text(
                      'Select vehicle type',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    items: widget.vehicleTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVehicleType = value;
                      });
                    },
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Seating Capacity',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total seats including driver seat',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 13),

                        Row(
                          children: [
                            _seatButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (_seatingCapacity > 2) {
                                  setState(() {
                                    _seatingCapacity--;
                                  });
                                }
                              },
                            ),

                            const SizedBox(width: 20),

                            Text(
                              '$_seatingCapacity Seats',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 20),

                            _seatButton(
                              icon: Icons.add,
                              onTap: () {
                                if (_seatingCapacity < 9) {
                                  setState(() {
                                    _seatingCapacity++;
                                  });
                                }
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Passenger seats available: ${_seatingCapacity - 1}',
                          style: const TextStyle(
                            color: AppColors.primaryLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saveVehicle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Text(
                        _isEditing ? 'Save Changes' : 'Add Vehicle',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}