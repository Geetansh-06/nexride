
import 'package:flutter/foundation.dart';

class RideStore {
  RideStore._();

  static final ValueNotifier<List<Map<String, dynamic>>> publishedRides =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  static void addPublishedRide({
    required Map<String, dynamic> rideDetails,
    required Map<String, dynamic> vehicleDetails,
  }) {
    final offeredSeats =
        int.tryParse(rideDetails['availableSeats']?.toString() ?? '') ?? 0;

    final vehicle = Map<String, dynamic>.from(vehicleDetails);

    final ride = {
      'id': DateTime.now().microsecondsSinceEpoch,
      'category': 1,
      'title': 'Published Ride',
      'route': '${rideDetails['from']} → ${rideDetails['to']}',
      'date': rideDetails['date']?.toString() ?? '-',
      'time': rideDetails['time']?.toString() ?? '-',
      'person': 'Your ride',
      'status': 'Pending',
      'isActive': true,
      'isManuallyActive': true,
      'amount': '₹${rideDetails['price']} / seat',
      'availableSeats': offeredSeats,
      'totalSeatsOffered': offeredSeats,

      // Vehicle details
      'vehicleId': vehicle['id'],
      'vehicleDetails': vehicle,
      'vehicle': '${vehicle['brand']} ${vehicle['model']}',
      'brand': vehicle['brand'],
      'model': vehicle['model'],
      'registration': vehicle['registration'],
      'colour': vehicle['colour'],
      'vehicleType': vehicle['vehicleType'],
      'seatingCapacity': vehicle['seatingCapacity'],

      // Journey details
      'from': rideDetails['from']?.toString() ?? '-',
      'to': rideDetails['to']?.toString() ?? '-',
      'price': rideDetails['price']?.toString() ?? '-',
    };

    publishedRides.value = [...publishedRides.value, ride];
  }

  // Published ride ki details update karega.
  static bool updatePublishedRide({
    required int rideId,
    required Map<String, dynamic> rideDetails,
  }) {
    final index = publishedRides.value.indexWhere(
          (ride) => ride['id'] == rideId,
    );

    if (index == -1) return false;

    final updatedRides =
    List<Map<String, dynamic>>.from(publishedRides.value);

    final ride = updatedRides[index];

    final currentAvailableSeats =
        int.tryParse(ride['availableSeats']?.toString() ?? '') ?? 0;

    final oldTotalSeats = int.tryParse(
      ride['totalSeatsOffered']?.toString() ?? '',
    ) ??
        currentAvailableSeats;

    // Already accepted bookings ki seats.
    final bookedSeats = oldTotalSeats - currentAvailableSeats;

    // Form se aane wali new total offered seats.
    final newTotalSeats = int.tryParse(
      rideDetails['availableSeats']?.toString() ?? '',
    );

    if (newTotalSeats == null || newTotalSeats <= 0) {
      return false;
    }

    // Booked seats se kam total seats allow nahi hongi.
    if (newTotalSeats < bookedSeats) {
      return false;
    }

    final newAvailableSeats = newTotalSeats - bookedSeats;

    final from = rideDetails['from']?.toString() ?? ride['from'];
    final to = rideDetails['to']?.toString() ?? ride['to'];
    final date = rideDetails['date']?.toString() ?? ride['date'];
    final time = rideDetails['time']?.toString() ?? ride['time'];
    final price = rideDetails['price']?.toString() ?? ride['price'];

    final manuallyActive =
        ride['isManuallyActive'] ?? ride['isActive'] ?? true;

    updatedRides[index] = {
      ...ride,
      'from': from,
      'to': to,
      'route': '$from → $to',
      'date': date,
      'time': time,
      'price': price,
      'amount': '₹$price / seat',
      'totalSeatsOffered': newTotalSeats,
      'availableSeats': newAvailableSeats,
      'isActive': newAvailableSeats > 0 && manuallyActive == true,
    };

    publishedRides.value = updatedRides;
    return true;
  }

  static bool updateRideActiveStatus({
    required int rideId,
    required bool isActive,
  }) {
    final index = publishedRides.value.indexWhere(
          (ride) => ride['id'] == rideId,
    );

    if (index == -1) return false;

    final updatedRides =
    List<Map<String, dynamic>>.from(publishedRides.value);

    final ride = updatedRides[index];

    final availableSeats =
        int.tryParse(ride['availableSeats']?.toString() ?? '') ?? 0;

    updatedRides[index] = {
      ...ride,
      'isManuallyActive': isActive,
      'isActive': isActive && availableSeats > 0,
    };

    publishedRides.value = updatedRides;
    return true;
  }

  // Booking accept hone par available seats kam karega.
  static bool reserveSeats({
    required int rideId,
    required int seats,
  }) {
    final index = publishedRides.value.indexWhere(
          (ride) => ride['id'] == rideId,
    );

    if (index == -1 || seats <= 0) return false;

    final ride = publishedRides.value[index];

    final availableSeats =
        int.tryParse(ride['availableSeats']?.toString() ?? '') ?? 0;

    if (ride['isActive'] != true || availableSeats < seats) {
      return false;
    }

    final updatedRides =
    List<Map<String, dynamic>>.from(publishedRides.value);

    final remainingSeats = availableSeats - seats;

    updatedRides[index] = {
      ...ride,
      'availableSeats': remainingSeats,
      'isActive': remainingSeats > 0 &&
          (ride['isManuallyActive'] ?? true) == true,
    };

    publishedRides.value = updatedRides;
    return true;
  }

  // Accepted booking cancel hone par seats wapas add karega.
  static bool restoreSeats({
    required int rideId,
    required int seats,
  }) {
    final index = publishedRides.value.indexWhere(
          (ride) => ride['id'] == rideId,
    );

    if (index == -1 || seats <= 0) return false;

    final ride = publishedRides.value[index];

    final currentSeats =
        int.tryParse(ride['availableSeats']?.toString() ?? '') ?? 0;

    final totalSeats = int.tryParse(
      ride['totalSeatsOffered']?.toString() ?? '',
    ) ??
        (currentSeats + seats);

    final restoredSeats = (currentSeats + seats).clamp(0, totalSeats);

    final manuallyActive = ride['isManuallyActive'] ?? true;

    final updatedRides =
    List<Map<String, dynamic>>.from(publishedRides.value);

    updatedRides[index] = {
      ...ride,
      'availableSeats': restoredSeats,
      'isActive': restoredSeats > 0 && manuallyActive == true,
    };

    publishedRides.value = updatedRides;
    return true;
  }

  static bool deletePublishedRide(int rideId) {
    final exists = publishedRides.value.any(
          (ride) => ride['id'] == rideId,
    );

    if (!exists) return false;

    publishedRides.value = publishedRides.value
        .where((ride) => ride['id'] != rideId)
        .toList();

    return true;
  }
}
