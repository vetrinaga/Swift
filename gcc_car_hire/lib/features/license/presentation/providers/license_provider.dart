import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

import '../../../../core/services/api_service.dart';

class LicenseProvider extends ChangeNotifier {
  final ApiService _apiService;
  final TextRecognizer _textRecognizer = TextRecognizer();

  bool _isLoading = false;
  String? _errorMessage;
  String? _ocrResult;
  bool _isVerified = false;

  LicenseProvider({required ApiService apiService}) : _apiService = apiService;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get ocrResult => _ocrResult;
  bool get isVerified => _isVerified;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setOcrResult(String? result) {
    _ocrResult = result;
    notifyListeners();
  }

  void _setVerified(bool verified) {
    _isVerified = verified;
    notifyListeners();
  }

  Future<void> processLicenseImage(File imageFile) async {
    _setLoading(true);
    _setError(null);

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isNotEmpty) {
        _setOcrResult(recognizedText.text);
      } else {
        _setError('No text found in the image. Please ensure the license is clearly visible.');
      }
    } catch (e) {
      _setError('Failed to process image: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> submitLicenseVerification({
    required String licenseNumber,
    required File licenseImage,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // First, process the image to get OCR text if not already done
      if (_ocrResult == null) {
        await processLicenseImage(licenseImage);
      }

      // Submit to backend for verification
      final response = await _apiService.verifyLicense({
        'licenseNumber': licenseNumber,
        'licenseImagePath': licenseImage.path,
        'ocrText': _ocrResult,
      });

      if (response.success && response.data != null) {
        _setVerified(response.data!.isValid);
        
        if (!response.data!.isValid) {
          _setError(response.data!.message ?? 'License verification failed');
        }
        
        return response.data!.isValid;
      } else {
        _setError(response.error ?? 'Verification failed');
        return false;
      }
    } catch (e) {
      _setError('Network error: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearOcrResult() {
    _setOcrResult(null);
    _setError(null);
  }

  void clearAll() {
    _setOcrResult(null);
    _setError(null);
    _setVerified(false);
    _setLoading(false);
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }
}
