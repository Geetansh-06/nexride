
import 'package:flutter/foundation.dart';

class DriverBookingStore {
  static final ValueNotifier<List<Map<String, dynamic>>> bookings =
  ValueNotifier<List<Map<String, dynamic>>>([]);

  static int _bookingCounter = 1;

  // Add New Booking
  static String addBooking(Map<String, dynamic> bookingDetails) {
    final String bookingId =
        'NXR-DRV-${DateTime.now().millisecondsSinceEpoch}-$_bookingCounter';

    _bookingCounter++;

    final Map<String, dynamic> booking = {
      'bookingId': bookingId,
      'status': 'Pending',
      'createdAt': DateTime.now(),
      'bookingDetails': Map<String, dynamic>.from(bookingDetails),
    };

    bookings.value = [...bookings.value, booking];

    return bookingId;
  }

  // Update Pending Booking Status
  static bool _updateBookingStatus(
      String bookingId,
      String newStatus,
      ) {
    final int bookingIndex = bookings.value.indexWhere(
          (booking) => booking['bookingId'] == bookingId,
    );

    // Booking not found
    if (bookingIndex == -1) {
      return false;
    }

    final Map<String, dynamic> booking = bookings.value[bookingIndex];

    // Only Pending bookings can be updated through this method
    if (booking['status'] != 'Pending') {
      return false;
    }

    final List<Map<String, dynamic>> updatedBookings =
    List<Map<String, dynamic>>.from(bookings.value);

    updatedBookings[bookingIndex] = {
      ...booking,
      'status': newStatus,
    };

    bookings.value = updatedBookings;

    return true;
  }

  // Complete Accepted Booking
  static bool completeBooking(String bookingId) {
    final int bookingIndex = bookings.value.indexWhere(
          (booking) => booking['bookingId'] == bookingId,
    );

    // Booking not found
    if (bookingIndex == -1) {
      return false;
    }

    final Map<String, dynamic> booking = bookings.value[bookingIndex];

    // Only Accepted bookings can be completed
    if (booking['status'] != 'Accepted') {
      return false;
    }

    final List<Map<String, dynamic>> updatedBookings =
    List<Map<String, dynamic>>.from(bookings.value);

    updatedBookings[bookingIndex] = {
      ...booking,
      'status': 'Completed',
      'completedAt': DateTime.now(),
    };

    bookings.value = updatedBookings;

    return true;
  }

  // Cancel Booking
  static bool cancelBooking(String bookingId) {
    return _updateBookingStatus(bookingId, 'Cancelled');
  }

  // Accept Booking
  static bool acceptBooking(String bookingId) {
    return _updateBookingStatus(bookingId, 'Accepted');
  }

  // Reject Booking
  static bool rejectBooking(String bookingId) {
    return _updateBookingStatus(bookingId, 'Rejected');
  }
}
