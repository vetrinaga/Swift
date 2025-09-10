import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../widgets/search_filters.dart';
import '../widgets/vehicle_list.dart';
import '../widgets/map_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize search with current location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().initializeSearch();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Vehicles'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by location, car model, or brand',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: _showFilters,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (value) {
                    context.read<SearchProvider>().searchVehicles(query: value);
                  },
                ),
              ),
              
              // Tab bar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.list),
                    text: 'List',
                  ),
                  Tab(
                    icon: Icon(Icons.map),
                    text: 'Map',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Active filters
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (searchProvider.activeFilters.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: searchProvider.activeFilters.length,
                  itemBuilder: (context, index) {
                    final filter = searchProvider.activeFilters[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(filter),
                        onDeleted: () {
                          searchProvider.removeFilter(filter);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          // Tab view
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                VehicleList(),
                MapView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<SearchProvider>().refreshSearch();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SearchFilters(),
    );
  }
}
