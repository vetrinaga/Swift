import 'package:json_annotation/json_annotation.dart';
import 'vehicle_model.dart';
import 'user_model.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  final String id;
  final String customerId;
  final String vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final LocationModel pickupLocation;
  final LocationModel returnLocation;
  final double totalAmount;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final VehicleModel? vehicle;
  final UserModel? customer;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.customerId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.returnLocation,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.vehicle,
    this.customer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  Duration get duration => endDate.difference(startDate);
  int get durationInDays => duration.inDays + 1;
  bool get isActive => status == BookingStatus.active;
  bool get canCancel => status == BookingStatus.pending || status == BookingStatus.confirmed;
}

enum BookingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('paid')
  paid,
  @JsonValue('refunded')
  refunded,
  @JsonValue('failed')
  failed,
}
