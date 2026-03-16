import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home/home_screen.dart';
import 'categories/categories_screen.dart';
import 'chat/chat_screen.dart';
import '../src/profile/profile_screen.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  static const routeName = '/navigation';

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
   
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: FontAwesomeIcons.house,
              activeIcon: FontAwesomeIcons.house,
              label: 'Home',
              index: 0,
            ),
            _buildNavItem(
              icon: FontAwesomeIcons.layerGroup,
              activeIcon: FontAwesomeIcons.layerGroup,
              label: 'Categories',
              index: 1,
            ),
            // Space for FAB
            _buildNavItem(
              icon: FontAwesomeIcons.message,
              activeIcon: FontAwesomeIcons.solidMessage,
              label: 'Chat',
              index: 2,
            ),
            _buildNavItem(
              icon: FontAwesomeIcons.user,
              activeIcon: FontAwesomeIcons.solidUser,
              label: 'Profile',
              index: 3,

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
