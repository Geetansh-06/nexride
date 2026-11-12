import 'package:flutter/foundation.dart';

class VehicleStore {
  VehicleStore._();

  static final ValueNotifier<List<Map<String, dynamic>>> vehicles =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  // Add a new vehicle
  static void addVehicle(Map<String, dynamic> vehicle) {
    final newVehicle = Map<String, dynamic>.from(vehicle);

    newVehicle['id'] = DateTime.now().microsecondsSinceEpoch.toString();

    vehicles.value = [
      ...vehicles.value,
      newVehicle,
    ];
  }

  // Update an existing vehicle
  static void updateVehicle(
      String vehicleId,
      Map<String, dynamic> updatedVehicle,
      ) {
    vehicles.value = vehicles.value.map((vehicle) {
      if (vehicle['id'] == vehicleId) {
        return {
          ...vehicle,
          ...updatedVehicle,
          'id': vehicleId,
        };
      }

      return vehicle;
    }).toList();
  }

  // Delete a vehicle
  static void deleteVehicle(String vehicleId) {
    vehicles.value = vehicles.value
        .where((vehicle) => vehicle['id'] != vehicleId)
        .toList();
  }
}