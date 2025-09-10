import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'edit_profile_screen.dart';
import '../../license/presentation/screens/license_verification_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please log in to view your profile',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Log In'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                ProfileHeader(user: user),
                
                const SizedBox(height: 24),
                
                // Account Section
                _buildSection(
                  context,
                  'Account',
                  [
                    ProfileMenuItem(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      subtitle: 'Update your details',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.credit_card,
                      title: 'Payment Methods',
                      subtitle: 'Manage your cards',
                      onTap: () {
                        // TODO: Navigate to payment methods
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.drive_eta,
                      title: 'Driver\'s License',
                      subtitle: user.licenseVerified 
                          ? 'Verified' 
                          : 'Verification required',
                      trailing: user.licenseVerified
                          ? Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 20,
                            )
                          : Icon(
                              Icons.warning,
                              color: Colors.orange,
                              size: 20,
                            ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LicenseVerificationScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bookings Section
                _buildSection(
                  context,
                  'Bookings',
                  [
                    ProfileMenuItem(
                      icon: Icons.bookmark_outline,
                      title: 'My Bookings',
                      subtitle: 'View all your rentals',
                      onTap: () => context.go('/bookings'),
                    ),
                    ProfileMenuItem(
                      icon: Icons.favorite_outline,
                      title: 'Favorites',
                      subtitle: 'Your saved vehicles',
                      onTap: () {
                        // TODO: Navigate to favorites
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.history,
                      title: 'Rental History',
                      subtitle: 'Past bookings and receipts',
                      onTap: () {
                        // TODO: Navigate to rental history
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Support Section
                _buildSection(
                  context,
                  'Support',
                  [
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      subtitle: 'FAQs and support',
                      onTap: () {
                        // TODO: Navigate to help center
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.chat_outline,
                      title: 'Contact Us',
                      subtitle: 'Get in touch',
                      onTap: () {
                        // TODO: Navigate to contact
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.star_outline,
                      title: 'Rate App',
                      subtitle: 'Share your feedback',
                      onTap: () {
                        // TODO: Open app store rating
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Legal Section
                _buildSection(
                  context,
                  'Legal',
                  [
                    ProfileMenuItem(
                      icon: Icons.privacy_tip_outline,
                      title: 'Privacy Policy',
                      onTap: () {
                        // TODO: Navigate to privacy policy
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      onTap: () {
                        // TODO: Navigate to terms
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'Version 1.0.0',
                      onTap: () {
                        // TODO: Show about dialog
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _showLogoutDialog,
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<ProfileMenuItem> items,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Card(
          child: Column(
            children: items
                .map((item) => Column(
                      children: [
                        item,
                        if (item != items.last)
                          Divider(
                            height: 1,
                            indent: 56,
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              await context.read<AuthProvider>().logout();
              
              if (mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
