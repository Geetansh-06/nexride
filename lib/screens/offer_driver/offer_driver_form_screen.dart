
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'driving_information_screen.dart';

class OfferDriverFormScreen extends StatefulWidget {
  const OfferDriverFormScreen({super.key});

  @override
  State<OfferDriverFormScreen> createState() =>
      _OfferDriverFormScreenState();
}

class _OfferDriverFormScreenState
    extends State<OfferDriverFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _experienceController = TextEditingController();
  final _priceController = TextEditingController();

  String _serviceType = 'Full Day';
  String _availability = 'Both';
  String _priceType = 'Per Day';

  final List<String> serviceTypes = [
    'Full Day',
    'Half Day',
    'Hourly',
    'Outstation',
  ];

  final List<String> availabilityOptions = [
    'Day',
    'Night',
    'Both',
  ];

  final List<String> priceTypes = [
    'Per Hour',
    'Per Day',
    'Per Trip',
  ];

  void _continue() {
    if (!_formKey.currentState!.validate()) return;

    final driverDetails = {
      'city': _cityController.text.trim(),
      'area': _areaController.text.trim(),
      'experience': _experienceController.text.trim(),
      'serviceType': _serviceType,
      'availability': _availability,
      'price': _priceController.text.trim(),
      'priceType': _priceType,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrivingInformationScreen(
          driverDetails: driverDetails,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
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
              vertical: 16,
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
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }

            if (keyboardType == TextInputType.number &&
                (int.tryParse(value.trim()) ?? 0) <= 0) {
              return 'Enter a valid amount';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
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
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
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
                color: AppColors.primary,
              ),
            ),
          ),
          iconEnabledColor: AppColors.primaryLight,
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

  @override
  void dispose() {
    _cityController.dispose();
    _areaController.dispose();
    _experienceController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text('Offer Driver Service'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Offer your driving service',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tell customers where and when you are available.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 25),

                _buildTextField(
                  label: 'City',
                  hint: 'e.g. Agra',
                  controller: _cityController,
                ),
                const SizedBox(height: 18),

                _buildTextField(
                  label: 'Preferred Service Area',
                  hint: 'e.g. Agra, Mathura, Delhi',
                  controller: _areaController,
                ),
                const SizedBox(height: 18),

                _buildTextField(
                  label: 'Driving Experience (Years)',
                  hint: 'e.g. 5',
                  controller: _experienceController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 18),

                _buildDropdown(
                  label: 'Service Type',
                  value: _serviceType,
                  items: serviceTypes,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _serviceType = value);
                    }
                  },
                ),
                const SizedBox(height: 18),

                _buildDropdown(
                  label: 'Availability',
                  value: _availability,
                  items: availabilityOptions,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _availability = value);
                    }
                  },
                ),
                const SizedBox(height: 18),

                _buildTextField(
                  label: 'Expected Charges',
                  hint: 'Enter amount in ₹',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 18),

                _buildDropdown(
                  label: 'Charge Type',
                  value: _priceType,
                  items: priceTypes,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _priceType = value);
                    }
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
