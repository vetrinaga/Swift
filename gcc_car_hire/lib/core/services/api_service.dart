import 'package:dio/dio.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import '../models/booking_model.dart';
import '../models/license_verification_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.gccrentals.com/v1/")
abstract class ApiService {
  factory ApiService({Dio? dio}) {
    dio ??= Dio();
    
    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
    
    // Add auth interceptor
    dio.interceptors.add(AuthInterceptor());
    
    return _ApiService(dio);
  }

  // Authentication endpoints
  @POST("/auth/register")
  Future<ApiResponse<UserModel>> register(@Body() Map<String, dynamic> userData);

  @POST("/auth/login")
  Future<ApiResponse<AuthResponse>> login(@Body() Map<String, dynamic> credentials);

  @POST("/auth/refresh")
  Future<ApiResponse<AuthResponse>> refreshToken(@Body() Map<String, dynamic> refreshData);

  @POST("/auth/logout")
  Future<ApiResponse<void>> logout();

  @POST("/auth/verify-license")
  Future<ApiResponse<LicenseVerificationResult>> verifyLicense(
    @Body() Map<String, dynamic> licenseData,
  );

  // User endpoints
  @GET("/users/profile")
  Future<ApiResponse<UserModel>> getUserProfile();

  @PUT("/users/profile")
  Future<ApiResponse<UserModel>> updateUserProfile(@Body() Map<String, dynamic> userData);

  // Vehicle endpoints
  @GET("/vehicles/search")
  Future<ApiResponse<List<VehicleModel>>> searchVehicles(@Queries() Map<String, dynamic> searchParams);

  @GET("/vehicles/{id}")
  Future<ApiResponse<VehicleModel>> getVehicleDetails(@Path("id") String vehicleId);

  @GET("/vehicles/{id}/availability")
  Future<ApiResponse<AvailabilityResponse>> getVehicleAvailability(
    @Path("id") String vehicleId,
    @Query("startDate") String startDate,
    @Query("endDate") String endDate,
  );

  // Booking endpoints
  @POST("/bookings")
  Future<ApiResponse<BookingModel>> createBooking(@Body() Map<String, dynamic> bookingData);

  @GET("/bookings")
  Future<ApiResponse<List<BookingModel>>> getUserBookings();

  @GET("/bookings/{id}")
  Future<ApiResponse<BookingModel>> getBookingDetails(@Path("id") String bookingId);

  @PUT("/bookings/{id}/cancel")
  Future<ApiResponse<BookingModel>> cancelBooking(@Path("id") String bookingId);

  // Payment endpoints
  @POST("/payments/process")
  Future<ApiResponse<PaymentResult>> processPayment(@Body() Map<String, dynamic> paymentData);

  @GET("/payments/methods")
  Future<ApiResponse<List<PaymentMethod>>> getPaymentMethods();

  @POST("/payments/methods")
  Future<ApiResponse<PaymentMethod>> addPaymentMethod(@Body() Map<String, dynamic> methodData);
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token to headers if available
    final token = StorageService().getAuthToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Add GCC region header for geo-targeting compliance
    options.headers['X-Region'] = 'GCC';
    options.headers['Content-Type'] = 'application/json';
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle token refresh or redirect to login
      _handleUnauthorized();
    }
    super.onError(err, handler);
  }

  void _handleUnauthorized() {
    // Implement token refresh logic or redirect to login
    StorageService().clearAuthTokens();
  }
}

// Response Models
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: UserModel.fromJson(json['user']),
    );
  }
}

class LicenseVerificationResult {
  final bool isValid;
  final String status;
  final Map<String, dynamic>? extractedData;
  final String? rejectionReason;

  LicenseVerificationResult({
    required this.isValid,
    required this.status,
    this.extractedData,
    this.rejectionReason,
  });

  factory LicenseVerificationResult.fromJson(Map<String, dynamic> json) {
    return LicenseVerificationResult(
      isValid: json['isValid'],
      status: json['status'],
      extractedData: json['extractedData'],
      rejectionReason: json['rejectionReason'],
    );
  }
}

class AvailabilityResponse {
  final bool isAvailable;
  final List<String> blockedDates;
  final double? pricePerDay;

  AvailabilityResponse({
    required this.isAvailable,
    required this.blockedDates,
    this.pricePerDay,
  });

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponse(
      isAvailable: json['isAvailable'],
      blockedDates: List<String>.from(json['blockedDates'] ?? []),
      pricePerDay: json['pricePerDay']?.toDouble(),
    );
  }
}

class PaymentResult {
  final bool success;
  final String transactionId;
  final String status;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    required this.transactionId,
    required this.status,
    this.errorMessage,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      success: json['success'],
      transactionId: json['transactionId'],
      status: json['status'],
      errorMessage: json['errorMessage'],
    );
  }
}

class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final String brand;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.brand,
    required this.isDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'],
      last4: json['last4'],
      brand: json['brand'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}
