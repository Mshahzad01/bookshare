import 'package:bookshare/src/seller/seller_main_screen.dart';
import 'package:bookshare/src/driver/driver_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cubit/profile_role_cubit.dart';

class RoleSwitchSplashScreen extends StatefulWidget {
  final UserRole targetRole;

  const RoleSwitchSplashScreen({
    super.key,
    required this.targetRole,
  });

  @override
  State<RoleSwitchSplashScreen> createState() => _RoleSwitchSplashScreenState();
}

class _RoleSwitchSplashScreenState extends State<RoleSwitchSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        if (widget.targetRole == UserRole.seller) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SellerMainScreen()),
          );
        } else if (widget.targetRole == UserRole.driver) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DriverMainScreen()),
          );
        } else {
          // If switching back to buyer, pop to previous screen (profile)
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getRoleName() {
    switch (widget.targetRole) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
      case UserRole.driver:
        return 'Driver';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.targetRole == UserRole.seller
                        ? Icons.storefront
                        : Icons.local_shipping,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Switching to ${_getRoleName()}',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
