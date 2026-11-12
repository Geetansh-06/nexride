
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/driver_service_store.dart';

class DriverServicePublishedScreen extends StatefulWidget {
  final Map<String, dynamic> driverDetails;

  const DriverServicePublishedScreen({
    super.key,
    required this.driverDetails,
  });

  @override
  State<DriverServicePublishedScreen> createState() =>
      _DriverServicePublishedScreenState();
}

class _DriverServicePublishedScreenState
    extends State<DriverServicePublishedScreen> {

  @override
  void initState() {
    super.initState();

    DriverServiceStore.addPublishedService(
      driverDetails: widget.driverDetails,
    );
  }

  String _value(String key) {
    final value = widget.driverDetails[key];

    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  void _backToHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 55),

              Container(
                height: 105,
                width: 105,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryLight,
                  size: 65,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Driver Service Submitted!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your driver service details have been submitted in this demo flow.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

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
                      'Service Summary',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _summaryRow('City', _value('city')),
                    _summaryRow('Service Area', _value('area')),
                    _summaryRow('Service Type', _value('serviceType')),
                    _summaryRow('Availability', _value('availability')),
                    _summaryRow(
                      'Expected Charges',
                      '₹${_value('price')} / ${_value('priceType')}',
                    ),
                    _summaryRow(
                      'Driving Experience',
                      '${_value('experience')} years',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
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
                        'Demo mode: This information is temporarily available in the app memory. It has not been sent to a backend server or permanently saved.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.5,
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
                  onPressed: _backToHome,
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

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
