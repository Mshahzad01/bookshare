
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seller Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Seller Profile Screen\nUpdate your info',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }
}
