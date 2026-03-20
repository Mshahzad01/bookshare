import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cart/cubit/cart_cubit.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final PageController _imageController = PageController();

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final images = book.imageUrls.isNotEmpty ? book.imageUrls : [book.imageUrl];

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Slider
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _imageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final url = images[index];
                      return Container(
                        color: Colors.grey.shade200,
                        child: url.startsWith('http') 
                          ? Image.network(url, fit: BoxFit.cover)
                          : Image.asset('assets/images/book_placeholder.jpg', fit: BoxFit.cover),
                      );
                    },
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _imageController,
                          count: images.length,
                          effect: CustomizableEffect(
                            activeDotDecoration: DotDecoration(
                              width: 24,
                              height: 8,
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            dotDecoration: DotDecoration(
                              width: 8,
                              height: 8,
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        Expanded(
                          child: Text(
                            book.title,
                            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (book.isDonation)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(16)),
                            child: Text('FREE', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                          )
                        else
                          Text(
                            'Rs. ${book.price?.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                          ),
                     ]
                   ),
                   const SizedBox(height: 8),
                   Text('By ${book.author}', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700)),
                   const SizedBox(height: 16),
                   
                   Row(
                     children: [
                       _buildInfoChip(Icons.category, book.category),
                       const SizedBox(width: 8),
                       _buildInfoChip(Icons.verified, book.condition),
                     ],
                   ),
                   const SizedBox(height: 16),
                   
                   Row(
                     children: [
                       Icon(Icons.storefront, color: Colors.grey.shade600),
                       const SizedBox(width: 8),
                       Text('Seller: ${book.sellerName}', style: GoogleFonts.poppins(fontSize: 14)),
                     ],
                   ),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       Icon(Icons.location_on, color: Colors.grey.shade600),
                       const SizedBox(width: 8),
                       Text(book.location.isNotEmpty ? book.location : 'Online / Unknown', style: GoogleFonts.poppins(fontSize: 14)),
                     ],
                   ),
                   const SizedBox(height: 24),
                   
                   Text('Description', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 8),
                   Text(book.description, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade800, height: 1.5)),
                ]
              )
            )
          ]
        )
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10, offset: const Offset(0, -5)
              )
            ]
          ),
          child: ElevatedButton(
            onPressed: () {
               context.read<CartCubit>().addToCart(book);
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('${book.title} added to cart!'), behavior: SnackBarBehavior.floating),
               );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Add to Cart', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        )
      )
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade800)),
        ],
      ),
    );
  }
}
