import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'ride_store.dart';

class RideBookingStore {
  RideBookingStore._();

  static final ValueNotifier<List<Map<String, dynamic>>> bookings =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  // Add new booking request.
  static void addBooking({
    required Map<String, dynamic> ride,
    required String pickup,
    required String destination,
    required DateTime journeyDate,
    required TimeOfDay journeyTime,
    required int passengerCount,
    required int totalPrice,
    required String message,
  }) {
    final booking = {
      'id': DateTime.now().microsecondsSinceEpoch,
      'rideId': ride['id'],
      'ride': Map<String, dynamic>.from(ride),
      'pickup': pickup,
      'destination': destination,
      'journeyDate': journeyDate,
      'journeyTime': journeyTime,
      'passengerCount': passengerCount,
      'totalPrice': totalPrice,
      'message': message,
      'status': 'Pending',
      'createdAt': DateTime.now(),
    };

    bookings.value = [
      ...bookings.value,
      booking,
    ];
  }

  // Update booking status only when it is Pending.
  static bool updateBookingStatus({
    required int bookingId,
    required String status,
  }) {
    final index = bookings.value.indexWhere(
          (booking) =>
      booking['id'] == bookingId &&
          booking['status'] == 'Pending',
    );

    if (index == -1) return false;

    final updatedBookings =
    List<Map<String, dynamic>>.from(bookings.value);

    updatedBookings[index] = {
      ...updatedBookings[index],
      'status': status,
    };

    bookings.value = updatedBookings;
    return true;
  }

  // Accept booking request.
  static bool acceptBooking(int bookingId) {
    return updateBookingStatus(
      bookingId: bookingId,
      status: 'Accepted',
    );
  }

  // Reject booking request.
  static bool rejectBooking(int bookingId) {
    return updateBookingStatus(
      bookingId: bookingId,
      status: 'Rejected',
    );
  }

  // Cancel Pending or Accepted booking.
  static bool cancelBooking(int bookingId) {
    final index = bookings.value.indexWhere(
          (booking) => booking['id'] == bookingId,
    );

    if (index == -1) return false;

    final booking = bookings.value[index];
    final currentStatus = booking['status'];

    // Sirf Pending aur Accepted bookings cancel ho sakti hain.
    if (currentStatus != 'Pending' && currentStatus != 'Accepted') {
      return false;
    }

    // Accepted booking ki seats restore karo.
    if (currentStatus == 'Accepted') {
      final rideId = int.tryParse(booking['rideId']?.toString() ?? '');
      final passengerCount = int.tryParse(
        booking['passengerCount']?.toString() ?? '',
      ) ??
          0;

      if (rideId != null && passengerCount > 0) {
        RideStore.restoreSeats(
          rideId: rideId,
          seats: passengerCount,
        );
      }
    }

    final updatedBookings =
    List<Map<String, dynamic>>.from(bookings.value);

    updatedBookings[index] = {
      ...booking,
      'status': 'Cancelled',
    };

    bookings.value = updatedBookings;
    return true;
  }
}