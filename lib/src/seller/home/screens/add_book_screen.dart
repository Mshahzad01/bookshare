import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/seller_cubit.dart';
import '../cubit/seller_state.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _customCategoryController = TextEditingController();

  final List<String> _conditions = ['New', 'Like New', 'Good', 'Fair', 'Poor'];
  String? _selectedCondition;

  final List<String> _categories = [
    'Class 1 to 8',
    '9th Class',
    '10th Class',
    'FSc/ICS 1st Year',
    'FSc/ICS 2nd Year',
    'BS / University',
    'Other'
  ];
  String? _selectedCategory;

  bool _isDonation = false;
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 images allowed.')),
      );
      return;
    }
    
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          for (var img in images) {
            if (_selectedImages.length < 5) {
              _selectedImages.add(File(img.path));
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error computing images: $e')));
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submit() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectedCondition == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_selectedCategory == 'Other' && _customCategoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please specify a custom category')),
      );
      return;
    }

    double finalPrice = 0.0;
    if (!_isDonation) {
      final parsedPrice = double.tryParse(_priceController.text);
      if (parsedPrice == null || parsedPrice <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid price')),
        );
        return;
      }
      finalPrice = parsedPrice;
    }

    final finalCategory = _selectedCategory == 'Other'
        ? _customCategoryController.text.trim()
        : _selectedCategory!;

    final success = await context.read<SellerCubit>().postBook(
          title: _titleController.text.trim(),
          author: _authorController.text.trim().isEmpty ? 'Unknown' : _authorController.text.trim(),
          description: _descController.text.trim(),
          condition: _selectedCondition!,
          category: finalCategory,
          price: finalPrice,
          isDonation: _isDonation,
          imageFiles: _selectedImages,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is! SellerDashboardReady) {
            return const Center(child: CircularProgressIndicator());
          }

          final isStudent = state.business.businessType == 'Student';
          final isPosting = state.isUploadingBook;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Horizontal Image Picker
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length < 5 ? _selectedImages.length + 1 : 5,
                    itemBuilder: (context, index) {
                      if (index == _selectedImages.length) {
                        return GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined, size: 32, color: Colors.grey[500]),
                                const SizedBox(height: 4),
                                Text('Add\n(Max 5)', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12), textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        );
                      }
                      return Stack(
                        children: [
                          Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: FileImage(_selectedImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 16,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (_selectedImages.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Add up to 5 images.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ),
                const SizedBox(height: 24),

                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Book Title *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: 'Author (Optional)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  items: _conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _selectedCondition = val),
                  decoration: InputDecoration(
                    labelText: 'Condition *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val),
                  decoration: InputDecoration(
                    labelText: 'Category *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                if (_selectedCategory == 'Other') ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _customCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Specify Custom Category *',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                if (isStudent) ...[
                  SwitchListTile(
                    title: Text('Donate this book', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text('Price will be set to 0', style: GoogleFonts.poppins(fontSize: 12)),
                    value: _isDonation,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) {
                      setState(() {
                        _isDonation = val;
                        if (val) _priceController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                if (!_isDonation)
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price (Rs) *',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: isPosting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: isPosting
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                      : Text('Post Book', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
