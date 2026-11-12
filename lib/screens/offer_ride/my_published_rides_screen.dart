
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/ride_store.dart';

class MyPublishedRidesScreen extends StatefulWidget {
  const MyPublishedRidesScreen({super.key});

  @override
  State<MyPublishedRidesScreen> createState() =>
      _MyPublishedRidesScreenState();
}

class _MyPublishedRidesScreenState
    extends State<MyPublishedRidesScreen> {
  int _getAvailableSeats(Map<String, dynamic> ride) {
    return int.tryParse(
      ride['availableSeats']?.toString() ?? '0',
    ) ??
        0;
  }

  int _getTotalSeats(Map<String, dynamic> ride) {
    return int.tryParse(
      ride['totalSeatsOffered']?.toString() ??
          ride['availableSeats']?.toString() ??
          '0',
    ) ??
        0;
  }

  bool _isRideFull(Map<String, dynamic> ride) {
    return _getAvailableSeats(ride) <= 0;
  }

  String _getRideStatus(Map<String, dynamic> ride) {
    if (_isRideFull(ride)) return 'Full';
    return ride['isActive'] == true ? 'Active' : 'Inactive';
  }

  Color _getStatusColor(Map<String, dynamic> ride) {
    if (_isRideFull(ride)) return Colors.redAccent;
    return ride['isActive'] == true ? Colors.green : Colors.orange;
  }

  Future<void> _editRide(Map<String, dynamic> ride) async {
    final bool? updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return _EditRideSheet(ride: ride);
      },
    );

    if (!mounted || updated != true) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ride updated successfully.'),
      ),
    );
  }

  Future<void> _toggleRide(Map<String, dynamic> ride) async {
    final bool currentStatus = ride['isActive'] == true;
    final bool newStatus = !currentStatus;

    if (newStatus && _isRideFull(ride)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No seats available. This ride cannot be activated.',
          ),
        ),
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          newStatus ? 'Activate Ride?' : 'Deactivate Ride?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          newStatus
              ? 'This ride will become active again and passengers will be able to find it.'
              : 'This ride will be marked as inactive and will no longer appear in ride searches.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              newStatus ? 'Activate' : 'Deactivate',
              style: const TextStyle(color: AppColors.primaryLight),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = RideStore.updateRideActiveStatus(
      rideId: ride['id'] as int,
      isActive: newStatus,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Ride ${newStatus ? 'activated' : 'deactivated'} successfully.'
              : 'Ride could not be updated.',
        ),
      ),
    );
  }

  Future<void> _deleteRide(Map<String, dynamic> ride) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'Delete Ride?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to delete this published ride? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
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
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = RideStore.deletePublishedRide(
      ride['id'] as int,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Ride deleted successfully.'
              : 'Ride could not be deleted.',
        ),
      ),
    );
  }

  void _showRideDetails(Map<String, dynamic> ride) {
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
                        color: AppColors.textSecondary.withValues(
                          alpha: 0.4,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Published Ride Details',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _detailRow('From', ride['from']),
                  _detailRow('To', ride['to']),
                  _detailRow('Journey Date', ride['date']),
                  _detailRow('Journey Time', ride['time']),
                  _detailRow('Vehicle', ride['vehicle']),
                  _detailRow('Vehicle Type', ride['vehicleType']),
                  _detailRow('Vehicle Colour', ride['colour']),
                  _detailRow('Registration', ride['registration']),
                  _detailRow('Seating Capacity', ride['seatingCapacity']),
                  _detailRow('Total Seats Offered', _getTotalSeats(ride)),
                  _detailRow('Available Seats', _getAvailableSeats(ride)),
                  _detailRow('Price', ride['amount']),
                  _detailRow('Status', _getRideStatus(ride)),
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

  Widget _buildRideCard(Map<String, dynamic> ride) {
    final bool isActive = ride['isActive'] == true;
    final bool isFull = _isRideFull(ride);
    final String status = _getRideStatus(ride);
    final Color statusColor = _getStatusColor(ride);

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
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.directions_car_outlined,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Published Ride',
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
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          _infoLine(
            Icons.route_outlined,
            ride['route']?.toString() ?? '-',
          ),
          const SizedBox(height: 9),
          _infoLine(
            Icons.calendar_today_outlined,
            '${ride['date']} · ${ride['time']}',
          ),
          const SizedBox(height: 9),
          _infoLine(
            Icons.directions_car_outlined,
            ride['vehicle']?.toString() ?? '-',
          ),
          const SizedBox(height: 9),
          _infoLine(
            Icons.event_seat_outlined,
            '${_getAvailableSeats(ride)} of ${_getTotalSeats(ride)} seats available',
          ),
          const SizedBox(height: 9),
          _infoLine(
            Icons.currency_rupee,
            ride['amount']?.toString() ?? '-',
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),

          // Existing action buttons.
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showRideDetails(ride),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Details'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: isFull ? null : () => _toggleRide(ride),
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
                    isFull
                        ? 'Full'
                        : isActive
                        ? 'Deactivate'
                        : 'Activate',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _deleteRide(ride),
                tooltip: 'Delete ride',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(
                    alpha: 0.10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // New Edit button.
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _editRide(ride),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Ride'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryLight,
                side: const BorderSide(
                  color: AppColors.primaryLight,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
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
              Icons.directions_car_outlined,
              size: 55,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 15),
            const Text(
              'No Published Rides Yet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Your published rides will appear here after you publish them.',
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
        title: const Text(
          'My Published Rides',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: RideStore.publishedRides,
          builder: (context, child) {
            final rides =
            RideStore.publishedRides.value.reversed.toList();

            final activeCount = rides
                .where(
                  (ride) =>
              ride['isActive'] == true &&
                  !_isRideFull(ride),
            )
                .length;

            final fullCount = rides.where(_isRideFull).length;

            final inactiveCount =
                rides.length - activeCount - fullCount;

            if (rides.isEmpty) {
              return _buildEmptyState();
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
              children: [
                Text(
                  '${rides.length} Published ${rides.length == 1 ? 'Ride' : 'Rides'}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$activeCount Active · $inactiveCount Inactive · $fullCount Full',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                ...rides.map(_buildRideCard),
              ],
            );
          },
        ),
      ),
    );
  }
}

// --------------------------------------------------
// EDIT RIDE FORM
// --------------------------------------------------

class _EditRideSheet extends StatefulWidget {
  final Map<String, dynamic> ride;

  const _EditRideSheet({
    required this.ride,
  });

  @override
  State<_EditRideSheet> createState() => _EditRideSheetState();
}

class _EditRideSheetState extends State<_EditRideSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _priceController;
  late final TextEditingController _seatsController;

  @override
  void initState() {
    super.initState();

    _fromController = TextEditingController(
      text: widget.ride['from']?.toString() ?? '',
    );

    _toController = TextEditingController(
      text: widget.ride['to']?.toString() ?? '',
    );

    _dateController = TextEditingController(
      text: widget.ride['date']?.toString() ?? '',
    );

    _timeController = TextEditingController(
      text: widget.ride['time']?.toString() ?? '',
    );

    _priceController = TextEditingController(
      text: widget.ride['price']?.toString() ?? '',
    );

    _seatsController = TextEditingController(
      text: widget.ride['totalSeatsOffered']?.toString() ??
          widget.ride['availableSeats']?.toString() ??
          '',
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final number = int.tryParse(value.trim());

    if (number == null || number <= 0) {
      return 'Enter a valid positive number';
    }

    return null;
  }

  void _saveRide() {
    if (!_formKey.currentState!.validate()) return;

    final rideId = widget.ride['id'];

    if (rideId is! int) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid ride ID.'),
        ),
      );
      return;
    }

    final newTotalSeats = int.parse(_seatsController.text.trim());

    final oldTotalSeats = int.tryParse(
      widget.ride['totalSeatsOffered']?.toString() ?? '',
    ) ??
        (int.tryParse(
          widget.ride['availableSeats']?.toString() ?? '0',
        ) ??
            0);

    final currentAvailableSeats = int.tryParse(
      widget.ride['availableSeats']?.toString() ?? '0',
    ) ??
        0;

    final bookedSeats = oldTotalSeats - currentAvailableSeats;

    if (newTotalSeats < bookedSeats) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You already have $bookedSeats booked seats. '
                'Total seats cannot be less than $bookedSeats.',
          ),
        ),
      );
      return;
    }

    final success = RideStore.updatePublishedRide(
      rideId: rideId,
      rideDetails: {
        'from': _fromController.text.trim(),
        'to': _toController.text.trim(),
        'date': _dateController.text.trim(),
        'time': _timeController.text.trim(),
        'price': _priceController.text.trim(),
        'availableSeats': newTotalSeats,
      },
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ride could not be updated.'),
        ),
      );
      return;
    }

    Navigator.pop(context, true);
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            validator: validator ?? _requiredValidator,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: AppColors.primaryLight,
                size: 20,
              ),
              filled: true,
              fillColor: AppColors.surface,
              hintText: label,
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
              ),
              errorStyle: const TextStyle(
                color: Colors.redAccent,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
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
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + bottomInset),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 42,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Edit Published Ride',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Update your journey information below.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 22),

                _buildField(
                  label: 'Pickup Location',
                  controller: _fromController,
                  icon: Icons.my_location,
                ),

                _buildField(
                  label: 'Destination',
                  controller: _toController,
                  icon: Icons.location_on_outlined,
                ),

                _buildField(
                  label: 'Journey Date',
                  controller: _dateController,
                  icon: Icons.calendar_today_outlined,
                ),

                _buildField(
                  label: 'Journey Time',
                  controller: _timeController,
                  icon: Icons.access_time,
                ),

                _buildField(
                  label: 'Price Per Seat (₹)',
                  controller: _priceController,
                  icon: Icons.currency_rupee,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter price';
                    }

                    final price = double.tryParse(value.trim());

                    if (price == null || price <= 0) {
                      return 'Enter a valid price';
                    }

                    return null;
                  },
                ),

                _buildField(
                  label: 'Total Seats Offered',
                  controller: _seatsController,
                  icon: Icons.event_seat_outlined,
                  keyboardType: TextInputType.number,
                  validator: _numberValidator,
                ),

                const SizedBox(height: 4),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveRide,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
