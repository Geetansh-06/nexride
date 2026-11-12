import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'driver_service_review_screen.dart';

class DrivingInformationScreen extends StatefulWidget {
  final Map<String, dynamic> driverDetails;

  const DrivingInformationScreen({
    super.key,
    required this.driverDetails,
  });

  @override
  State<DrivingInformationScreen> createState() =>
      _DrivingInformationScreenState();
}

class _DrivingInformationScreenState
    extends State<DrivingInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _licenceController = TextEditingController();

  String _licenceType = 'LMV';
  DateTime? _validityDate;

  final List<String> _licenceTypes = [
    'LMV',
    'Transport',
    'Both',
  ];

  Future<void> _selectValidityDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime(2045),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _validityDate = selectedDate;
      });
    }
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;

    if (_validityDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select licence validity date.'),
        ),
      );
      return;
    }

    final drivingDetails = {
      ...widget.driverDetails,
      'licenceNumber': _licenceController.text.trim(),
      'licenceType': _licenceType,
      'licenceValidity':
      '${_validityDate!.day}/${_validityDate!.month}/${_validityDate!.year}',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverServiceReviewScreen(
          driverDetails: drivingDetails,
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

  @override
  void dispose() {
    _licenceController.dispose();
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
        title: const Text('Driving Information'),
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
                  'Your driving credentials',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Provide your driving licence information to continue.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 25),

                _buildLabel('Driving Licence Number'),

                TextFormField(
                  controller: _licenceController,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your licence number',
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
                      return 'Please enter licence number';
                    }

                    if (value.trim().length < 8) {
                      return 'Please enter a valid licence number';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                _buildLabel('Licence Type'),

                DropdownButtonFormField<String>(
                  value: _licenceType,
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
                  ),
                  items: _licenceTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _licenceType = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                _buildLabel('Licence Validity Date'),

                InkWell(
                  onTap: _selectValidityDate,
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 17,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _validityDate == null
                                ? 'Select licence expiry date'
                                : '${_validityDate!.day}/${_validityDate!.month}/${_validityDate!.year}',
                            style: TextStyle(
                              color: _validityDate == null
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: AppColors.border,
                    ),
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
                          'Enter your licence details accurately. These details can be verified before your driver service becomes available.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
