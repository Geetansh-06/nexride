
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/driver_service_store.dart';

class MyPublishedDriverServicesScreen extends StatefulWidget {
  const MyPublishedDriverServicesScreen({super.key});

  @override
  State<MyPublishedDriverServicesScreen> createState() =>
      _MyPublishedDriverServicesScreenState();
}

class _MyPublishedDriverServicesScreenState
    extends State<MyPublishedDriverServicesScreen> {

  // Edit an existing driver service
  Future<void> _editService(
      Map<String, dynamic> service,
      ) async {
    final Map<String, dynamic>? updatedDetails =
    await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return _EditDriverServiceSheet(service: service);
      },
    );

    if (updatedDetails == null || !mounted) return;

    final success = DriverServiceStore.updatePublishedService(
      serviceId: service['id'] as int,
      driverDetails: updatedDetails,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Driver service updated successfully.'
              : 'Service could not be updated.',
        ),
      ),
    );
  }

  // Activate or deactivate service
  Future<void> _toggleService(
      Map<String, dynamic> service,
      ) async {
    final bool currentStatus = service['isActive'] == true;
    final bool newStatus = !currentStatus;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          newStatus ? 'Activate Service?' : 'Deactivate Service?',
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          newStatus
              ? 'This driver service will become active again.'
              : 'Customers will no longer see this service as active.',
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              newStatus ? 'Activate' : 'Deactivate',
              style: const TextStyle(
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = DriverServiceStore.updateServiceActiveStatus(
      serviceId: service['id'] as int,
      isActive: newStatus,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Service ${newStatus ? 'activated' : 'deactivated'} successfully.'
              : 'Service could not be updated.',
        ),
      ),
    );
  }

  // Delete service
  Future<void> _deleteService(
      Map<String, dynamic> service,
      ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'Delete Service?',
          style: TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this published driver service? This action cannot be undone.',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = DriverServiceStore.deletePublishedService(
      service['id'] as int,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Driver service deleted successfully.'
              : 'Service could not be deleted.',
        ),
      ),
    );
  }

  // Show service details
  void _showServiceDetails(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 42,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Driver Service Details',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _detailRow('City', service['city']),
                  _detailRow('Area', service['area']),
                  _detailRow('Service Type', service['serviceType']),
                  _detailRow('Experience', service['experience']),
                  _detailRow('Availability', service['availability']),
                  _detailRow('Price', service['price']),
                  _detailRow('Price Type', service['priceType']),
                  _detailRow('Licence Type', service['licenceType']),
                  _detailRow(
                    'Status',
                    service['isActive'] == true
                        ? 'Active'
                        : 'Inactive',
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
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

  // Service card
  Widget _buildServiceCard(Map<String, dynamic> service) {
    final bool isActive = service['isActive'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: AppColors.primaryLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Driver Service',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isActive ? Colors.green : Colors.orange)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          _infoLine(
            Icons.location_on_outlined,
            '${service['city']} · ${service['area']}',
          ),
          const SizedBox(height: 9),
          _infoLine(
            Icons.work_outline,
            '${service['experience']} experience',
          ),
          const SizedBox(height: 9),
          _infoLine(
            Icons.currency_rupee,
            service['amount']?.toString() ?? '-',
          ),
          const SizedBox(height: 16),
          const Divider(
            color: AppColors.border,
            height: 1,
          ),
          const SizedBox(height: 12),

          // First row: Details and Edit
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showServiceDetails(service),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Details'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editService(service),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 17,
                  ),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: const BorderSide(
                      color: AppColors.primaryLight,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          // Second row: Activate/Deactivate and Delete
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _toggleService(service),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                    isActive ? Colors.orange : Colors.green,
                    side: BorderSide(
                      color: isActive ? Colors.orange : Colors.green,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isActive ? 'Deactivate' : 'Activate',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _deleteService(service),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 17,
                  ),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(
                      color: AppColors.error,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoLine(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
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
            Icon(
              Icons.badge_outlined,
              size: 55,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 15),
            const Text(
              'No Published Services Yet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Your driver services will appear here after you publish them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
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
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
        title: const Text(
          'My Published Services',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: DriverServiceStore.publishedServices,
          builder: (context, child) {
            final services =
            DriverServiceStore.publishedServices.value.reversed.toList();

            final activeCount = services
                .where((service) => service['isActive'] == true)
                .length;

            if (services.isEmpty) {
              return _buildEmptyState();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
              children: [
                Text(
                  '${services.length} Published ${services.length == 1 ? 'Service' : 'Services'}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$activeCount Active · ${services.length - activeCount} Inactive',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                ...services.map(_buildServiceCard),
              ],
            );
          },
        ),
      ),
    );
  }
}

// --------------------------------------------------
// EDIT DRIVER SERVICE BOTTOM SHEET
// --------------------------------------------------

class _EditDriverServiceSheet extends StatefulWidget {
  final Map<String, dynamic> service;

  const _EditDriverServiceSheet({
    required this.service,
  });

  @override
  State<_EditDriverServiceSheet> createState() =>
      _EditDriverServiceSheetState();
}

class _EditDriverServiceSheetState
    extends State<_EditDriverServiceSheet> {

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _cityController;
  late final TextEditingController _areaController;
  late final TextEditingController _serviceTypeController;
  late final TextEditingController _experienceController;
  late final TextEditingController _availabilityController;
  late final TextEditingController _priceController;
  late final TextEditingController _priceTypeController;
  late final TextEditingController _licenceTypeController;

  @override
  void initState() {
    super.initState();

    final service = widget.service;

    _cityController =
        TextEditingController(text: service['city']?.toString() ?? '');
    _areaController =
        TextEditingController(text: service['area']?.toString() ?? '');
    _serviceTypeController =
        TextEditingController(text: service['serviceType']?.toString() ?? '');
    _experienceController =
        TextEditingController(text: service['experience']?.toString() ?? '');
    _availabilityController =
        TextEditingController(text: service['availability']?.toString() ?? '');
    _priceController =
        TextEditingController(text: service['price']?.toString() ?? '');
    _priceTypeController =
        TextEditingController(text: service['priceType']?.toString() ?? '');
    _licenceTypeController =
        TextEditingController(text: service['licenceType']?.toString() ?? '');
  }

  @override
  void dispose() {
    _cityController.dispose();
    _areaController.dispose();
    _serviceTypeController.dispose();
    _experienceController.dispose();
    _availabilityController.dispose();
    _priceController.dispose();
    _priceTypeController.dispose();
    _licenceTypeController.dispose();

    super.dispose();
  }

  // Save edited service details
  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      {
        'city': _cityController.text.trim(),
        'area': _areaController.text.trim(),
        'serviceType': _serviceTypeController.text.trim(),
        'experience': _experienceController.text.trim(),
        'availability': _availabilityController.text.trim(),
        'price': _priceController.text.trim(),
        'priceType': _priceTypeController.text.trim(),
        'licenceType': _licenceTypeController.text.trim(),
      },
    );
  }

  // Common text field
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: hint ?? 'Enter $label',
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryLight,
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Edit Driver Service',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Update your published service information.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 22),

              _buildTextField(
                label: 'City',
                controller: _cityController,
              ),
              _buildTextField(
                label: 'Area',
                controller: _areaController,
              ),
              _buildTextField(
                label: 'Service Type',
                controller: _serviceTypeController,
              ),
              _buildTextField(
                label: 'Experience',
                controller: _experienceController,
              ),
              _buildTextField(
                label: 'Availability',
                controller: _availabilityController,
              ),
              _buildTextField(
                label: 'Price',
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                label: 'Price Type',
                controller: _priceTypeController,
              ),
              _buildTextField(
                label: 'Licence Type',
                controller: _licenceTypeController,
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
