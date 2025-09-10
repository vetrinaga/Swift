import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../../core/models/vehicle_model.dart';
import '../../../search/presentation/providers/search_provider.dart';

class VehicleMapWidget extends StatefulWidget {
  final List<VehicleModel> vehicles;
  final Function(VehicleModel)? onVehicleSelected;

  const VehicleMapWidget({
    super.key,
    required this.vehicles,
    this.onVehicleSelected,
  });

  @override
  State<VehicleMapWidget> createState() => _VehicleMapWidgetState();
}

class _VehicleMapWidgetState extends State<VehicleMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  VehicleModel? _selectedVehicle;

  // Default location (Dubai, UAE)
  static const LatLng _defaultLocation = LatLng(25.2048, 55.2708);

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  @override
  void didUpdateWidget(VehicleMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vehicles != widget.vehicles) {
      _createMarkers();
    }
  }

  void _createMarkers() {
    final markers = <Marker>{};
    
    for (int i = 0; i < widget.vehicles.length; i++) {
      final vehicle = widget.vehicles[i];
      
      // Use mock coordinates for demonstration
      // In real implementation, vehicles would have actual GPS coordinates
      final lat = _defaultLocation.latitude + (i * 0.01) - 0.05;
      final lng = _defaultLocation.longitude + (i * 0.01) - 0.05;
      
      markers.add(
        Marker(
          markerId: MarkerId(vehicle.id),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerColor(vehicle.category),
          ),
          infoWindow: InfoWindow(
            title: '${vehicle.make} ${vehicle.model}',
            snippet: '\$${vehicle.pricePerDay}/day',
            onTap: () => _onMarkerTapped(vehicle),
          ),
          onTap: () => _onMarkerTapped(vehicle),
        ),
      );
    }
    
    setState(() {
      _markers = markers;
    });
  }

  double _getMarkerColor(VehicleCategory category) {
    switch (category) {
      case VehicleCategory.economy:
        return BitmapDescriptor.hueGreen;
      case VehicleCategory.compact:
        return BitmapDescriptor.hueBlue;
      case VehicleCategory.midsize:
        return BitmapDescriptor.hueOrange;
      case VehicleCategory.fullsize:
        return BitmapDescriptor.hueRed;
      case VehicleCategory.luxury:
        return BitmapDescriptor.hueViolet;
      case VehicleCategory.suv:
        return BitmapDescriptor.hueYellow;
      case VehicleCategory.convertible:
        return BitmapDescriptor.hueCyan;
      case VehicleCategory.van:
        return BitmapDescriptor.hueMagenta;
    }
  }

  void _onMarkerTapped(VehicleModel vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
    });
    
    widget.onVehicleSelected?.call(vehicle);
    
    // Show bottom sheet with vehicle details
    _showVehicleBottomSheet(vehicle);
  }

  void _showVehicleBottomSheet(VehicleModel vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VehicleDetailsBottomSheet(vehicle: vehicle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          initialCameraPosition: const CameraPosition(
            target: _defaultLocation,
            zoom: 12.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onTap: (LatLng position) {
            // Clear selection when tapping on empty area
            setState(() {
              _selectedVehicle = null;
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class _VehicleDetailsBottomSheet extends StatelessWidget {
  final VehicleModel vehicle;

  const _VehicleDetailsBottomSheet({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Image
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: vehicle.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            vehicle.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderImage(theme),
                          ),
                        )
                      : _buildPlaceholderImage(theme),
                ),
                
                const SizedBox(height: 16),
                
                // Vehicle Details
                Text(
                  '${vehicle.make} ${vehicle.model}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vehicle.rating.toStringAsFixed(1),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${vehicle.location} • 0.5 km away',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Price and Book Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${vehicle.pricePerDay}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'per day',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: Navigate to booking screen
                      },
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Center(
      child: Icon(
        Icons.directions_car,
        size: 48,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
