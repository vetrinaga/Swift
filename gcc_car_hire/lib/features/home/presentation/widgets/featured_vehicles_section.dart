import 'package:flutter/material.dart';

class FeaturedVehiclesSection extends StatelessWidget {
  const FeaturedVehiclesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for featured vehicles
    final featuredVehicles = [
      _MockVehicle(
        id: '1',
        name: 'Toyota Camry 2023',
        category: 'Sedan',
        price: 120,
        rating: 4.8,
        imageUrl: '',
        features: ['Automatic', 'AC', 'GPS'],
      ),
      _MockVehicle(
        id: '2',
        name: 'BMW X5 2023',
        category: 'SUV',
        price: 280,
        rating: 4.9,
        imageUrl: '',
        features: ['Automatic', 'Leather', 'Premium'],
      ),
      _MockVehicle(
        id: '3',
        name: 'Nissan Altima 2023',
        category: 'Sedan',
        price: 95,
        rating: 4.6,
        imageUrl: '',
        features: ['Automatic', 'AC', 'Bluetooth'],
      ),
    ];

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredVehicles.length,
        itemBuilder: (context, index) {
          return _buildVehicleCard(context, featuredVehicles[index]);
        },
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, _MockVehicle vehicle) {
    final theme = Theme.of(context);
    
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Icon(
                Icons.directions_car,
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Name and Category
                  Text(
                    vehicle.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    vehicle.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating and Features
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vehicle.rating.toString(),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          vehicle.features.join(' • '),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Price and Book Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AED ${vehicle.price}',
                            style: theme.textTheme.titleLarge?.copyWith(
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
                          // TODO: Navigate to vehicle details
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Book'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockVehicle {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final List<String> features;

  _MockVehicle({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.features,
  });
}
