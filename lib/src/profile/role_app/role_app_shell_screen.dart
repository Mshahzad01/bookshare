import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/profile_role_cubit.dart';

class RoleAppShellScreen extends StatelessWidget {
  final UserRole initialRole;

  const RoleAppShellScreen({
    super.key,
    required this.initialRole,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileRoleCubit()..setRole(initialRole),
      child: const _RoleAppScaffold(),
    );
  }
}

class _RoleAppScaffold extends StatelessWidget {
  const _RoleAppScaffold();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileRoleCubit, ProfileRoleState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${_titleFromRole(state.selectedRole)} App',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          drawer: _RoleDrawer(state: state),
          body: _RoleAppBody(state: state),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.appNavIndex,
            onTap: context.read<ProfileRoleCubit>().setAppNavIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey[500],
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  String _titleFromRole(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
      case UserRole.driver:
        return 'Driver';
    }
  }
}

class _RoleDrawer extends StatelessWidget {
  final ProfileRoleState state;

  const _RoleDrawer({required this.state});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Role Switcher',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
            accountEmail: Text(
              'Switch between Buyer, Seller, Driver',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            currentAccountPicture: CircleAvatar(
              child: FaIcon(
                _iconFromRole(state.selectedRole),
                size: 20,
              ),
            ),
          ),
          _DrawerRoleTile(
            title: 'Buyer App',
            icon: FontAwesomeIcons.cartShopping,
            selected: state.selectedRole == UserRole.buyer,
            onTap: () {
              context.read<ProfileRoleCubit>().setRole(UserRole.buyer);
              Navigator.pop(context);
            },
          ),
          _DrawerRoleTile(
            title: 'Seller App',
            icon: FontAwesomeIcons.store,
            selected: state.selectedRole == UserRole.seller,
            onTap: () {
              context.read<ProfileRoleCubit>().setRole(UserRole.seller);
              Navigator.pop(context);
            },
          ),
          _DrawerRoleTile(
            title: 'Driver App',
            icon: FontAwesomeIcons.truckFast,
            selected: state.selectedRole == UserRole.driver,
            onTap: () {
              context.read<ProfileRoleCubit>().setRole(UserRole.driver);
              Navigator.pop(context);
            },
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Back to Main App',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  IconData _iconFromRole(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return FontAwesomeIcons.cartShopping;
      case UserRole.seller:
        return FontAwesomeIcons.store;
      case UserRole.driver:
        return FontAwesomeIcons.truckFast;
    }
  }
}

class _DrawerRoleTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerRoleTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(
        icon,
        size: 18,
        color: selected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      trailing: selected ? const Icon(Icons.check_circle, size: 18) : null,
      onTap: onTap,
    );
  }
}

class _RoleAppBody extends StatelessWidget {
  final ProfileRoleState state;

  const _RoleAppBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final tabs = <String>['Home', 'Orders', 'Chat', 'Profile'];
    final section = tabs[state.appNavIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              _iconFromRole(state.selectedRole),
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              '${_titleFromRole(state.selectedRole)} $section',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Bottom navigation and drawer switching are now controlled by Cubit.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _titleFromRole(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
      case UserRole.driver:
        return 'Driver';
    }
  }

  IconData _iconFromRole(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return FontAwesomeIcons.cartShopping;
      case UserRole.seller:
        return FontAwesomeIcons.store;
      case UserRole.driver:
        return FontAwesomeIcons.truckFast;
    }
  }
}
