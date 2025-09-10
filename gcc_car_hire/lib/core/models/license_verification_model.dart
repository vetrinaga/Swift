import 'package:json_annotation/json_annotation.dart';

part 'license_verification_model.g.dart';

@JsonSerializable()
class LicenseVerificationResult {
  final bool isValid;
  final String? message;
  final String? licenseNumber;
  final String? holderName;
  final DateTime? expiryDate;
  final String? licenseClass;
  final String? issuingAuthority;
  final double? confidenceScore;

  const LicenseVerificationResult({
    required this.isValid,
    this.message,
    this.licenseNumber,
    this.holderName,
    this.expiryDate,
    this.licenseClass,
    this.issuingAuthority,
    this.confidenceScore,
  });

  factory LicenseVerificationResult.fromJson(Map<String, dynamic> json) =>
      _$LicenseVerificationResultFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseVerificationResultToJson(this);

  LicenseVerificationResult copyWith({
    bool? isValid,
    String? message,
    String? licenseNumber,
    String? holderName,
    DateTime? expiryDate,
    String? licenseClass,
    String? issuingAuthority,
    double? confidenceScore,
  }) {
    return LicenseVerificationResult(
      isValid: isValid ?? this.isValid,
      message: message ?? this.message,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      holderName: holderName ?? this.holderName,
      expiryDate: expiryDate ?? this.expiryDate,
      licenseClass: licenseClass ?? this.licenseClass,
      issuingAuthority: issuingAuthority ?? this.issuingAuthority,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }

  @override
  String toString() {
    return 'LicenseVerificationResult(isValid: $isValid, message: $message, licenseNumber: $licenseNumber, holderName: $holderName, expiryDate: $expiryDate, licenseClass: $licenseClass, issuingAuthority: $issuingAuthority, confidenceScore: $confidenceScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LicenseVerificationResult &&
        other.isValid == isValid &&
        other.message == message &&
        other.licenseNumber == licenseNumber &&
        other.holderName == holderName &&
        other.expiryDate == expiryDate &&
        other.licenseClass == licenseClass &&
        other.issuingAuthority == issuingAuthority &&
        other.confidenceScore == confidenceScore;
  }

  @override
  int get hashCode {
    return isValid.hashCode ^
        message.hashCode ^
        licenseNumber.hashCode ^
        holderName.hashCode ^
        expiryDate.hashCode ^
        licenseClass.hashCode ^
        issuingAuthority.hashCode ^
        confidenceScore.hashCode;
  }
}
