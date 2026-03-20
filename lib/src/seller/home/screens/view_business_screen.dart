import 'dart:io';
import 'package:bookshare/src/services/cloudnary_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/seller_cubit.dart';
import '../cubit/seller_state.dart';

class ViewBusinessScreen extends StatefulWidget {
  const ViewBusinessScreen({super.key});

  @override
  State<ViewBusinessScreen> createState() => _ViewBusinessScreenState();
}

class _ViewBusinessScreenState extends State<ViewBusinessScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _selectedImage;
  String? _uploadedUrl;
  bool _isUploadingImage = false;
  bool _isSaving = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final state = context.read<SellerCubit>().state;
    if (state is SellerDashboardReady) {
      final business = state.business;
      _nameController.text = business.businessName;
      _addressController.text = business.businessAddress;
      _phoneController.text = business.phoneNumber;
      _uploadedUrl = business.logoUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isUploadingImage = true;
        });

        final cloudService = CloudinaryService();
        final url = await cloudService.uploadImage(_selectedImage!);

        if (mounted) {
          if (url != null) {
            setState(() {
              _uploadedUrl = url;
              _isUploadingImage = false;
            });
          } else {
            setState(() {
              _isUploadingImage = false;
              _selectedImage = null; // Revert
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload logo.')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
          _selectedImage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleUpdate() async {
    if (_nameController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (_isUploadingImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for the logo to finish uploading')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await context.read<SellerCubit>().updateBusinessDetails(
          businessName: _nameController.text.trim(),
          businessAddress: _addressController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          logoUrl: _uploadedUrl,
        );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Business Profile Updated!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating business profile.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Info', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _handleUpdate,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text('Save', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is! SellerDashboardReady) {
            return const Center(child: CircularProgressIndicator());
          }
          final business = state.business;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), width: 3),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            backgroundImage: _selectedImage != null && !_isUploadingImage
                                ? FileImage(_selectedImage!)
                                : (business.logoUrl != null && business.logoUrl!.isNotEmpty && !_isUploadingImage)
                                    ? (business.logoUrl!.startsWith('http')
                                        ? NetworkImage(business.logoUrl!)
                                        : AssetImage(business.logoUrl!)) as ImageProvider
                                    : null,
                            child: _isUploadingImage
                                ? const CircularProgressIndicator()
                                : (_selectedImage == null && (business.logoUrl == null || business.logoUrl!.isEmpty))
                                    ? Icon(Icons.storefront, size: 50, color: Colors.grey[400])
                                    : null,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Business Name',
                    prefixIcon: const Icon(Icons.business_center_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Business Address',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: business.businessType),
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Business Type',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
