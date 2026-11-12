
import 'package:flutter/foundation.dart';

class DriverServiceStore {
  DriverServiceStore._();

  static final ValueNotifier<List<Map<String, dynamic>>>
  publishedServices =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  // Publish a new driver service
  static void addPublishedService({
    required Map<String, dynamic> driverDetails,
  }) {
    final service = {
      'id': DateTime.now().microsecondsSinceEpoch,
      'category': 3,
      'title': 'Driver Service',
      'route':
      'Driver Service · ${driverDetails['city'] ?? '-'}',
      'date': 'Not specified',
      'time': 'Flexible',
      'person': 'Your driver service',

      // Existing activity status
      'status': 'Pending',

      // Service management status
      'isActive': true,

      'amount':
      '₹${driverDetails['price'] ?? '-'} / ${driverDetails['priceType'] ?? '-'}',
      'city': driverDetails['city']?.toString() ?? '-',
      'area': driverDetails['area']?.toString() ?? '-',
      'experience':
      driverDetails['experience']?.toString() ?? '-',
      'serviceType':
      driverDetails['serviceType']?.toString() ?? '-',
      'availability':
      driverDetails['availability']?.toString() ?? '-',
      'price': driverDetails['price']?.toString() ?? '-',
      'priceType':
      driverDetails['priceType']?.toString() ?? '-',
      'licenceType':
      driverDetails['licenceType']?.toString() ?? '-',
    };

    publishedServices.value = [
      ...publishedServices.value,
      service,
    ];
  }

  // Update an existing published driver service
  static bool updatePublishedService({
    required int serviceId,
    required Map<String, dynamic> driverDetails,
  }) {
    final index = publishedServices.value.indexWhere(
          (service) => service['id'] == serviceId,
    );

    if (index == -1) return false;

    final updatedServices =
    List<Map<String, dynamic>>.from(publishedServices.value);

    final existingService = updatedServices[index];

    updatedServices[index] = {
      ...existingService,

      // Update editable service information
      'route':
      'Driver Service · ${driverDetails['city'] ?? '-'}',
      'amount':
      '₹${driverDetails['price'] ?? '-'} / ${driverDetails['priceType'] ?? '-'}',
      'city': driverDetails['city']?.toString() ?? '-',
      'area': driverDetails['area']?.toString() ?? '-',
      'experience':
      driverDetails['experience']?.toString() ?? '-',
      'serviceType':
      driverDetails['serviceType']?.toString() ?? '-',
      'availability':
      driverDetails['availability']?.toString() ?? '-',
      'price': driverDetails['price']?.toString() ?? '-',
      'priceType':
      driverDetails['priceType']?.toString() ?? '-',
      'licenceType':
      driverDetails['licenceType']?.toString() ?? '-',
    };

    publishedServices.value = updatedServices;

    return true;
  }

  // Activate or deactivate a published service
  static bool updateServiceActiveStatus({
    required int serviceId,
    required bool isActive,
  }) {
    final index = publishedServices.value.indexWhere(
          (service) => service['id'] == serviceId,
    );

    if (index == -1) return false;

    final updatedServices =
    List<Map<String, dynamic>>.from(publishedServices.value);

    updatedServices[index] = {
      ...updatedServices[index],
      'isActive': isActive,
    };

    publishedServices.value = updatedServices;

    return true;
  }

  // Delete a published service
  static bool deletePublishedService(int serviceId) {
    final existingLength = publishedServices.value.length;

    final updatedServices = publishedServices.value
        .where((service) => service['id'] != serviceId)
        .toList();

    if (updatedServices.length == existingLength) {
      return false;
    }

    publishedServices.value = updatedServices;

    return true;
  }
}
