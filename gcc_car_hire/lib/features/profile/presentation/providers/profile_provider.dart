import 'package:flutter/foundation.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileProvider({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.getUserProfile();

      if (response.success && response.data != null) {
        _setUser(response.data);
        // Cache user data locally
        await _storageService.saveUserData('current_user', response.data!.toJson());
      } else {
        _setError(response.error ?? 'Failed to load profile');
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      
      // Try to load cached user data
      final cachedUserData = _storageService.getUserData<Map<String, dynamic>>('current_user');
      if (cachedUserData != null) {
        _setUser(UserModel.fromJson(cachedUserData));
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? dateOfBirth,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final updateData = <String, dynamic>{};
      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;
      if (phone != null) updateData['phone'] = phone;
      if (dateOfBirth != null) updateData['dateOfBirth'] = dateOfBirth.toIso8601String();

      final response = await _apiService.updateUserProfile(updateData);

      if (response.success && response.data != null) {
        _setUser(response.data);
        // Update cached data
        await _storageService.saveUserData('current_user', response.data!.toJson());
        return true;
      } else {
        _setError(response.error ?? 'Failed to update profile');
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadProfileImage(String imagePath) async {
    _setLoading(true);
    _setError(null);

    try {
      // TODO: Implement image upload to backend
      // For now, simulate success
      await Future.delayed(const Duration(seconds: 2));
      
      if (_user != null) {
        _setUser(_user!.copyWith(
          profileImageUrl: 'https://example.com/profile_image.jpg',
        ));
      }
      
      return true;
    } catch (e) {
      _setError('Failed to upload image: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyLicense({
    required String licenseNumber,
    required String licenseImagePath,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.verifyLicense({
        'licenseNumber': licenseNumber,
        'licenseImagePath': licenseImagePath,
      });

      if (response.success && response.data != null) {
        if (_user != null) {
          _setUser(_user!.copyWith(
            licenseNumber: licenseNumber,
            licenseVerified: response.data!.isValid,
          ));
          
          // Update cached data
          await _storageService.saveUserData('current_user', _user!.toJson());
        }
        return response.data!.isValid;
      } else {
        _setError(response.error ?? 'License verification failed');
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearProfile() {
    _setUser(null);
    _setError(null);
  }
}
