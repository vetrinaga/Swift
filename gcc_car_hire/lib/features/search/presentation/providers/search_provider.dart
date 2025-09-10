import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/models/vehicle_model.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService _apiService;
  final LocationService _locationService;

  List<VehicleModel> _vehicles = [];
  List<VehicleModel> _filteredVehicles = [];
  bool _isLoading = false;
  String? _errorMessage;
  Position? _currentLocation;
  Map<String, dynamic> _filters = {};
  List<String> _activeFilters = [];

  SearchProvider({
    required ApiService apiService,
    required LocationService locationService,
  }) : _apiService = apiService,
       _locationService = locationService;

  // Getters
  List<VehicleModel> get vehicles => _filteredVehicles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Position? get currentLocation => _currentLocation;
  Map<String, dynamic> get filters => _filters;
  List<String> get activeFilters => _activeFilters;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> initializeSearch() async {
    _setLoading(true);
    
    try {
      // Get current location
      _currentLocation = await _locationService.getCurrentLocation();
      _currentLocation ??= _locationService.getDefaultLocation();
      
      // Search vehicles near current location
      await searchVehicles();
    } catch (e) {
      _setError('Failed to initialize search: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchVehicles({
    String? query,
    Position? location,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final searchLocation = location ?? _currentLocation;
      if (searchLocation == null) {
        throw Exception('Location not available');
      }

      final searchParams = <String, dynamic>{
        'latitude': searchLocation.latitude,
        'longitude': searchLocation.longitude,
        'radius': 50, // 50km radius
        if (query != null && query.isNotEmpty) 'query': query,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        ..._filters,
      };

      final response = await _apiService.searchVehicles(searchParams);

      if (response.success && response.data != null) {
        _vehicles = response.data!;
        _applyFilters();
      } else {
        _setError(response.error ?? 'Search failed');
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void applyFilter(String key, dynamic value) {
    _filters[key] = value;
    _updateActiveFilters();
    _applyFilters();
    notifyListeners();
  }

  void removeFilter(String filterName) {
    // Remove filter based on display name
    _filters.removeWhere((key, value) => _getFilterDisplayName(key, value) == filterName);
    _updateActiveFilters();
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _filters.clear();
    _activeFilters.clear();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredVehicles = _vehicles.where((vehicle) {
      // Apply price range filter
      if (_filters.containsKey('minPrice') || _filters.containsKey('maxPrice')) {
        final minPrice = _filters['minPrice'] ?? 0.0;
        final maxPrice = _filters['maxPrice'] ?? double.infinity;
        if (vehicle.dailyRate < minPrice || vehicle.dailyRate > maxPrice) {
          return false;
        }
      }

      // Apply category filter
      if (_filters.containsKey('category')) {
        final categories = _filters['category'] as List<VehicleCategory>;
        if (!categories.contains(vehicle.category)) {
          return false;
        }
      }

      // Apply transmission filter
      if (_filters.containsKey('transmission')) {
        final transmissions = _filters['transmission'] as List<TransmissionType>;
        if (!transmissions.contains(vehicle.transmission)) {
          return false;
        }
      }

      // Apply fuel type filter
      if (_filters.containsKey('fuelType')) {
        final fuelTypes = _filters['fuelType'] as List<FuelType>;
        if (!fuelTypes.contains(vehicle.fuelType)) {
          return false;
        }
      }

      // Apply features filter
      if (_filters.containsKey('features')) {
        final requiredFeatures = _filters['features'] as List<String>;
        if (!requiredFeatures.every((feature) => vehicle.features.contains(feature))) {
          return false;
        }
      }

      // Apply rating filter
      if (_filters.containsKey('minRating')) {
        final minRating = _filters['minRating'] as double;
        if (vehicle.rating < minRating) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _updateActiveFilters() {
    _activeFilters = _filters.entries
        .map((entry) => _getFilterDisplayName(entry.key, entry.value))
        .toList();
  }

  String _getFilterDisplayName(String key, dynamic value) {
    switch (key) {
      case 'minPrice':
        return 'Min: AED $value';
      case 'maxPrice':
        return 'Max: AED $value';
      case 'category':
        final categories = value as List<VehicleCategory>;
        return categories.map((c) => c.name).join(', ');
      case 'transmission':
        final transmissions = value as List<TransmissionType>;
        return transmissions.map((t) => t.name).join(', ');
      case 'fuelType':
        final fuelTypes = value as List<FuelType>;
        return fuelTypes.map((f) => f.name).join(', ');
      case 'features':
        final features = value as List<String>;
        return features.join(', ');
      case 'minRating':
        return 'Rating: $value+';
      default:
        return '$key: $value';
    }
  }

  void sortVehicles(String sortBy) {
    switch (sortBy) {
      case 'price_low':
        _filteredVehicles.sort((a, b) => a.dailyRate.compareTo(b.dailyRate));
        break;
      case 'price_high':
        _filteredVehicles.sort((a, b) => b.dailyRate.compareTo(a.dailyRate));
        break;
      case 'rating':
        _filteredVehicles.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        if (_currentLocation != null) {
          _filteredVehicles.sort((a, b) {
            final distanceA = _locationService.calculateDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              a.location.latitude,
              a.location.longitude,
            );
            final distanceB = _locationService.calculateDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              b.location.latitude,
              b.location.longitude,
            );
            return distanceA.compareTo(distanceB);
          });
        }
        break;
      case 'newest':
        _filteredVehicles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    notifyListeners();
  }

  Future<void> refreshSearch() async {
    await searchVehicles();
  }

  double calculateDistance(VehicleModel vehicle) {
    if (_currentLocation == null) return 0.0;
    
    return _locationService.calculateDistance(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      vehicle.location.latitude,
      vehicle.location.longitude,
    ) / 1000; // Convert to kilometers
  }
}
