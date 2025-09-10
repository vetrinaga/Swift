import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  final String id;
  final String ownerId;
  final String make;
  final String model;
  final int year;
  final String licensePlate;
  final TransmissionType transmission;
  final FuelType fuelType;
  final VehicleCategory category;
  final double dailyRate;
  final LocationModel location;
  final VehicleStatus status;
  final List<String> features;
  final List<String> images;
  final String? description;
  final int seats;
  final int doors;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleModel({
    required this.id,
    required this.ownerId,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.transmission,
    required this.fuelType,
    required this.category,
    required this.dailyRate,
    required this.location,
    required this.status,
    required this.features,
    required this.images,
    this.description,
    required this.seats,
    required this.doors,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => _$VehicleModelFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  String get displayName => '$make $model ($year)';
  String get mainImage => images.isNotEmpty ? images.first : '';
  bool get isAvailable => status == VehicleStatus.available;
}

@JsonSerializable()
class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? country;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}

enum TransmissionType {
  @JsonValue('automatic')
  automatic,
  @JsonValue('manual')
  manual,
}

enum FuelType {
  @JsonValue('petrol')
  petrol,
  @JsonValue('diesel')
  diesel,
  @JsonValue('electric')
  electric,
  @JsonValue('hybrid')
  hybrid,
}

enum VehicleCategory {
  @JsonValue('economy')
  economy,
  @JsonValue('compact')
  compact,
  @JsonValue('suv')
  suv,
  @JsonValue('luxury')
  luxury,
  @JsonValue('sports')
  sports,
}

enum VehicleStatus {
  @JsonValue('available')
  available,
  @JsonValue('rented')
  rented,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('inactive')
  inactive,
}
