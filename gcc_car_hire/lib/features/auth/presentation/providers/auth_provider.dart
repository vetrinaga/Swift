import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  AuthProvider({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService {
    _initializeAuth();
  }

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setUser(UserModel? user) {
    _currentUser = user;
    _isAuthenticated = user != null;
    notifyListeners();
  }

  Future<void> _initializeAuth() async {
    _setLoading(true);
    
    try {
      // Check if user has valid token
      final token = _storageService.getAuthToken();
      if (token != null) {
        // Validate token with backend
        final response = await _apiService.getUserProfile();
        if (response.success && response.data != null) {
          _setUser(response.data);
        } else {
          await _clearAuthData();
        }
      }
    } catch (e) {
      await _clearAuthData();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.login({
        'email': email,
        'password': password,
        'rememberMe': rememberMe,
      });

      if (response.success && response.data != null) {
        await _saveAuthData(response.data!);
        _setUser(response.data!.user);
        return true;
      } else {
        _setError(response.error ?? 'Login failed');
        return false;
      }
    } catch (e) {
      _setError('Network error. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.register({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'userType': 'customer',
      });

      if (response.success && response.data != null) {
        // Auto-login after successful registration
        return await login(email: email, password: password);
      } else {
        _setError(response.error ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Network error. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setError(null);

    try {
      // Sign out first to ensure account picker shows
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        // Send Firebase token to backend for verification and user creation
        final idToken = await userCredential.user!.getIdToken();
        
        final response = await _apiService.login({
          'provider': 'google',
          'idToken': idToken,
          'email': userCredential.user!.email,
          'firstName': userCredential.user!.displayName?.split(' ').first ?? '',
          'lastName': userCredential.user!.displayName?.split(' ').skip(1).join(' ') ?? '',
        });

        if (response.success && response.data != null) {
          await _saveAuthData(response.data!);
          _setUser(response.data!.user);
          return true;
        }
      }
      
      _setError('Google sign-in failed');
      return false;
    } catch (e) {
      _setError('Google sign-in error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithApple() async {
    _setLoading(true);
    _setError(null);

    try {
      // Apple Sign In implementation would go here
      // For now, show not implemented message
      _setError('Apple Sign In not yet implemented');
      return false;
    } catch (e) {
      _setError('Apple sign-in error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      // Call backend logout
      await _apiService.logout();
    } catch (e) {
      // Continue with local logout even if backend call fails
    }

    // Sign out from Firebase
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();

    // Clear local data
    await _clearAuthData();
    _setUser(null);
    _setLoading(false);
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = _storageService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiService.refreshToken({
        'refreshToken': refreshToken,
      });

      if (response.success && response.data != null) {
        await _saveAuthData(response.data!);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? dateOfBirth,
  }) async {
    if (_currentUser == null) return false;

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
        return true;
      } else {
        _setError(response.error ?? 'Profile update failed');
        return false;
      }
    } catch (e) {
      _setError('Network error. Please try again.');
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
        // Update user verification status
        if (_currentUser != null) {
          _setUser(_currentUser!.copyWith(
            licenseNumber: licenseNumber,
            licenseVerified: response.data!.isValid,
          ));
        }
        return response.data!.isValid;
      } else {
        _setError(response.error ?? 'License verification failed');
        return false;
      }
    } catch (e) {
      _setError('Network error. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _storageService.saveAuthToken(authResponse.accessToken);
    await _storageService.saveRefreshToken(authResponse.refreshToken);
    await _storageService.saveUserData('current_user', authResponse.user.toJson());
  }

  Future<void> _clearAuthData() async {
    await _storageService.clearAuthTokens();
    await _storageService.removeUserData('current_user');
  }
}
