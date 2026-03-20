
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Driver Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Driver Profile Screen\nUpdate your driver info',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }
}
