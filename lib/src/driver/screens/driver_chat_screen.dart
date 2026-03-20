
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverChatScreen extends StatelessWidget {
  const DriverChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Driver Chat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Driver Chat Screen\nCommunicate regarding deliveries',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }
}
