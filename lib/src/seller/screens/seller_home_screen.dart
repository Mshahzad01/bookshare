import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/cubit/seller_cubit.dart';
import '../home/cubit/seller_state.dart';
import '../home/screens/create_business_screen.dart';
import '../home/screens/seller_dashboard_screen.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Store',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SellerNoBusiness) {
            return const CreateBusinessScreen();
          } else if (state is SellerDashboardReady) {
            return const SellerDashboardScreen();
          } else if (state is SellerError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
