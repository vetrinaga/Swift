import 'package:flutter/foundation.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  BookingProvider({
    required ApiService apiService,
  }) : _apiService = apiService;

  // Getters
  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<BookingModel> get activeBookings => _bookings
      .where((booking) => booking.status == BookingStatus.active)
      .toList();

  List<BookingModel> get upcomingBookings => _bookings
      .where((booking) => 
          booking.status == BookingStatus.confirmed || 
          booking.status == BookingStatus.pending)
      .toList();

  List<BookingModel> get pastBookings => _bookings
      .where((booking) => 
          booking.status == BookingStatus.completed || 
          booking.status == BookingStatus.cancelled)
      .toList();

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadBookings() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.getUserBookings();

      if (response.success && response.data != null) {
        _bookings = response.data!;
        _bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        _setError(response.error ?? 'Failed to load bookings');
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createBooking({
    required String vehicleId,
    required DateTime startDate,
    required DateTime endDate,
    required Map<String, double> pickupLocation,
    required Map<String, double> returnLocation,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final bookingData = {
        'vehicleId': vehicleId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'pickupLocation': pickupLocation,
        'returnLocation': returnLocation,
      };

      final response = await _apiService.createBooking(bookingData);

      if (response.success && response.data != null) {
        _bookings.insert(0, response.data!);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Failed to create booking');
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.cancelBooking(bookingId);

      if (response.success && response.data != null) {
        final index = _bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          _bookings[index] = response.data!;
          notifyListeners();
        }
        return true;
      } else {
        _setError(response.error ?? 'Failed to cancel booking');
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<BookingModel?> getBookingDetails(String bookingId) async {
    try {
      final response = await _apiService.getBookingDetails(bookingId);

      if (response.success && response.data != null) {
        return response.data;
      } else {
        _setError(response.error ?? 'Failed to load booking details');
        return null;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return null;
    }
  }
}
