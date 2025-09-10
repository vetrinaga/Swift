import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/search/presentation/providers/search_provider.dart';
import '../../features/bookings/presentation/providers/booking_provider.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/license/presentation/providers/license_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    // Services
    Provider<ApiService>(
      create: (_) => ApiService(),
    ),
    Provider<StorageService>(
      create: (_) => StorageService(),
    ),
    Provider<LocationService>(
      create: (_) => LocationService(),
    ),
    
    // State Providers
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(
        apiService: context.read<ApiService>(),
        storageService: context.read<StorageService>(),
      ),
    ),
    ChangeNotifierProvider<SearchProvider>(
      create: (context) => SearchProvider(
        apiService: context.read<ApiService>(),
        locationService: context.read<LocationService>(),
      ),
    ),
    ChangeNotifierProvider<BookingProvider>(
      create: (context) => BookingProvider(
        apiService: context.read<ApiService>(),
      ),
    ),
    ChangeNotifierProvider<ProfileProvider>(
      create: (context) => ProfileProvider(
        apiService: context.read<ApiService>(),
        storageService: context.read<StorageService>(),
      ),
    ),
    ChangeNotifierProvider<LicenseProvider>(
      create: (context) => LicenseProvider(
        apiService: context.read<ApiService>(),
      ),
    ),
  ];
}
