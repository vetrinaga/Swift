import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/vehicle_model.dart';
import '../providers/search_provider.dart';

class SearchFilters extends StatefulWidget {
  const SearchFilters({super.key});

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  RangeValues _priceRange = const RangeValues(0, 1000);
  double _minRating = 0;
  Set<VehicleCategory> _selectedCategories = {};
  Set<TransmissionType> _selectedTransmissions = {};
  Set<FuelType> _selectedFuelTypes = {};
  Set<String> _selectedFeatures = {};

  final List<String> _availableFeatures = [
    'Air Conditioning',
    'GPS Navigation',
    'Bluetooth',
    'USB Charging',
    'Leather Seats',
    'Sunroof',
    'Backup Camera',
    'Parking Sensors',
    'Cruise Control',
    'Heated Seats',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  void _loadCurrentFilters() {
    final searchProvider = context.read<SearchProvider>();
    final filters = searchProvider.filters;

    if (filters.containsKey('minPrice') || filters.containsKey('maxPrice')) {
      _priceRange = RangeValues(
        filters['minPrice']?.toDouble() ?? 0,
        filters['maxPrice']?.toDouble() ?? 1000,
      );
    }

    if (filters.containsKey('minRating')) {
      _minRating = filters['minRating'].toDouble();
    }

    if (filters.containsKey('category')) {
      _selectedCategories = Set.from(filters['category']);
    }

    if (filters.containsKey('transmission')) {
      _selectedTransmissions = Set.from(filters['transmission']);
    }

    if (filters.containsKey('fuelType')) {
      _selectedFuelTypes = Set.from(filters['fuelType']);
    }

    if (filters.containsKey('features')) {
      _selectedFeatures = Set.from(filters['features']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _clearAllFilters,
                child: const Text('Clear All'),
              ),
            ],
          ),
          
          const Divider(),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildSectionTitle('Price Range (AED per day)'),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels(
                      'AED ${_priceRange.start.round()}',
                      'AED ${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  Text(
                    'AED ${_priceRange.start.round()} - AED ${_priceRange.end.round()}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Rating
                  _buildSectionTitle('Minimum Rating'),
                  const SizedBox(height: 8),
                  Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: '${_minRating.toStringAsFixed(1)} stars',
                    onChanged: (value) {
                      setState(() {
                        _minRating = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Vehicle Category
                  _buildSectionTitle('Vehicle Category'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: VehicleCategory.values.map((category) {
                      return FilterChip(
                        label: Text(_getCategoryDisplayName(category)),
                        selected: _selectedCategories.contains(category),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategories.add(category);
                            } else {
                              _selectedCategories.remove(category);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Transmission
                  _buildSectionTitle('Transmission'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: TransmissionType.values.map((transmission) {
                      return FilterChip(
                        label: Text(_getTransmissionDisplayName(transmission)),
                        selected: _selectedTransmissions.contains(transmission),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTransmissions.add(transmission);
                            } else {
                              _selectedTransmissions.remove(transmission);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Fuel Type
                  _buildSectionTitle('Fuel Type'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: FuelType.values.map((fuelType) {
                      return FilterChip(
                        label: Text(_getFuelTypeDisplayName(fuelType)),
                        selected: _selectedFuelTypes.contains(fuelType),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFuelTypes.add(fuelType);
                            } else {
                              _selectedFuelTypes.remove(fuelType);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Features
                  _buildSectionTitle('Features'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableFeatures.map((feature) {
                      return FilterChip(
                        label: Text(feature),
                        selected: _selectedFeatures.contains(feature),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFeatures.add(feature);
                            } else {
                              _selectedFeatures.remove(feature);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Apply Filters Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _getCategoryDisplayName(VehicleCategory category) {
    switch (category) {
      case VehicleCategory.economy:
        return 'Economy';
      case VehicleCategory.compact:
        return 'Compact';
      case VehicleCategory.suv:
        return 'SUV';
      case VehicleCategory.luxury:
        return 'Luxury';
      case VehicleCategory.sports:
        return 'Sports';
    }
  }

  String _getTransmissionDisplayName(TransmissionType transmission) {
    switch (transmission) {
      case TransmissionType.automatic:
        return 'Automatic';
      case TransmissionType.manual:
        return 'Manual';
    }
  }

  String _getFuelTypeDisplayName(FuelType fuelType) {
    switch (fuelType) {
      case FuelType.petrol:
        return 'Petrol';
      case FuelType.diesel:
        return 'Diesel';
      case FuelType.electric:
        return 'Electric';
      case FuelType.hybrid:
        return 'Hybrid';
    }
  }

  void _applyFilters() {
    final searchProvider = context.read<SearchProvider>();
    
    // Apply price range
    if (_priceRange.start > 0 || _priceRange.end < 1000) {
      searchProvider.applyFilter('minPrice', _priceRange.start);
      searchProvider.applyFilter('maxPrice', _priceRange.end);
    }
    
    // Apply rating
    if (_minRating > 0) {
      searchProvider.applyFilter('minRating', _minRating);
    }
    
    // Apply categories
    if (_selectedCategories.isNotEmpty) {
      searchProvider.applyFilter('category', _selectedCategories.toList());
    }
    
    // Apply transmissions
    if (_selectedTransmissions.isNotEmpty) {
      searchProvider.applyFilter('transmission', _selectedTransmissions.toList());
    }
    
    // Apply fuel types
    if (_selectedFuelTypes.isNotEmpty) {
      searchProvider.applyFilter('fuelType', _selectedFuelTypes.toList());
    }
    
    // Apply features
    if (_selectedFeatures.isNotEmpty) {
      searchProvider.applyFilter('features', _selectedFeatures.toList());
    }
    
    Navigator.of(context).pop();
  }

  void _clearAllFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 1000);
      _minRating = 0;
      _selectedCategories.clear();
      _selectedTransmissions.clear();
      _selectedFuelTypes.clear();
      _selectedFeatures.clear();
    });
    
    context.read<SearchProvider>().clearFilters();
    Navigator.of(context).pop();
  }
}
