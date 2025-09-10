import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../providers/license_provider.dart';
import '../widgets/license_camera_widget.dart';
import '../widgets/license_info_card.dart';

class LicenseVerificationScreen extends StatefulWidget {
  const LicenseVerificationScreen({super.key});

  @override
  State<LicenseVerificationScreen> createState() => _LicenseVerificationScreenState();
}

class _LicenseVerificationScreenState extends State<LicenseVerificationScreen> {
  final _licenseNumberController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _licenseNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Verification'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Consumer<LicenseProvider>(
        builder: (context, licenseProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                const LicenseInfoCard(),
                
                const SizedBox(height: 24),
                
                // Manual License Number Input
                Text(
                  'License Number',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _licenseNumberController,
                  decoration: InputDecoration(
                    hintText: 'Enter your license number',
                    prefixIcon: const Icon(Icons.drive_eta),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                
                const SizedBox(height: 24),
                
                // Camera Section
                Text(
                  'License Photo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                
                if (_selectedImage != null) ...[
                  // Show selected image
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // OCR Results
                  if (licenseProvider.ocrResult != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Text Detected',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            licenseProvider.ocrResult!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _retakePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Retake'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: licenseProvider.isLoading ? null : _processLicense,
                          icon: licenseProvider.isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.text_fields),
                          label: const Text('Scan Text'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Camera Widget
                  LicenseCameraWidget(
                    onImageCaptured: (File image) {
                      setState(() {
                        _selectedImage = image;
                      });
                    },
                    onImageSelected: (File image) {
                      setState(() {
                        _selectedImage = image;
                      });
                    },
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: licenseProvider.isLoading || 
                               _licenseNumberController.text.isEmpty ||
                               _selectedImage == null
                        ? null
                        : _submitVerification,
                    child: licenseProvider.isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Verifying...'),
                            ],
                          )
                        : const Text('Submit for Verification'),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Error Message
                if (licenseProvider.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            licenseProvider.errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _retakePhoto() {
    setState(() {
      _selectedImage = null;
    });
    context.read<LicenseProvider>().clearOcrResult();
  }

  Future<void> _processLicense() async {
    if (_selectedImage == null) return;
    
    await context.read<LicenseProvider>().processLicenseImage(_selectedImage!);
  }

  Future<void> _submitVerification() async {
    if (_selectedImage == null || _licenseNumberController.text.isEmpty) {
      return;
    }

    final success = await context.read<LicenseProvider>().submitLicenseVerification(
      licenseNumber: _licenseNumberController.text.trim(),
      licenseImage: _selectedImage!,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('License submitted for verification'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
