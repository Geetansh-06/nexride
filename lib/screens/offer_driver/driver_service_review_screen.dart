
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'driver_service_published_screen.dart';

class DriverServiceReviewScreen extends StatefulWidget {
  final Map<String, dynamic> driverDetails;

  const DriverServiceReviewScreen({
    super.key,
    required this.driverDetails,
  });

  @override
  State<DriverServiceReviewScreen> createState() =>
      _DriverServiceReviewScreenState();
}

class _DriverServiceReviewScreenState
    extends State<DriverServiceReviewScreen> {

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> details,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(15),
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
          const SizedBox(height: 15),
          ...details.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item['label']!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      item['value']!,
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
          }),
        ],
      ),
    );
  }

  String _value(String key) {
    final value = widget.driverDetails[key];

    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  void _publishService() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DriverServicePublishedScreen(
          driverDetails: widget.driverDetails,
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
        title: const Text('Review Driver Service'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review your details',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Check all your information before publishing your driver service.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 25),

              _buildSection(
                title: 'Service Information',
                details: [
                  {'label': 'City', 'value': _value('city')},
                  {'label': 'Service Area', 'value': _value('area')},
                  {
                    'label': 'Driving Experience',
                    'value': '${_value('experience')} years',
                  },
                  {
                    'label': 'Service Type',
                    'value': _value('serviceType'),
                  },
                  {
                    'label': 'Availability',
                    'value': _value('availability'),
                  },
                  {
                    'label': 'Expected Charges',
                    'value': '₹${_value('price')}',
                  },
                  {
                    'label': 'Charge Type',
                    'value': _value('priceType'),
                  },
                ],
              ),

              _buildSection(
                title: 'Driving Credentials',
                details: [
                  {
                    'label': 'Licence Number',
                    'value': _value('licenceNumber'),
                  },
                  {
                    'label': 'Licence Type',
                    'value': _value('licenceType'),
                  },
                  {
                    'label': 'Licence Validity',
                    'value': _value('licenceValidity'),
                  },
                ],
              ),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(13),
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
                        'Please make sure your information is correct. Your licence details may be verified before your service becomes available.',
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
                  onPressed: _publishService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Publish Driver Service',
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
    );
  }
}
