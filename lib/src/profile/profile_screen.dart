import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../cubits/profile/profile_cubit.dart';
import '../../cubits/profile/profile_state.dart';
import 'cubit/profile_role_cubit.dart';
import 'role_switch_splash_screen.dart';
import 'component/role_switcher.dart';
import 'screens/edit_profile_screen.dart';
import '../buyer/orders/screens/my_orders_screen.dart';
import '../buyer/orders/screens/my_orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileRoleCubit _roleCubit;

  @override
  void initState() {
    super.initState();
    _roleCubit = ProfileRoleCubit();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    _roleCubit.close();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser;

  Widget _buildMenuTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FaIcon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  void _openRoleApp(BuildContext context, UserRole role) {
    if (role == UserRole.buyer) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoleSwitchSplashScreen(targetRole: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _roleCubit,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is ProfileLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  const SizedBox(height: 20),

                  Card(
                    elevation: 0,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    margin: .symmetric(horizontal: 16),
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.grey[200]),
                    //   borderRadius: BorderRadius.circular(16),
                    // ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 29,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            backgroundImage:
                                (state.user.avatarUrl != null &&
                                    state.user.avatarUrl!.isNotEmpty)
                                ? (state.user.avatarUrl!.startsWith('http')
                                          ? NetworkImage(state.user.avatarUrl!)
                                          : AssetImage(state.user.avatarUrl!))
                                      as ImageProvider
                                : null,
                            child:
                                (state.user.avatarUrl == null ||
                                    state.user.avatarUrl!.isEmpty)
                                ? Icon(
                                    Icons.person,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  )
                                : null,
                          ),
                          title: Text(
                            state.user.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            user?.email ?? 'user@example.com',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                          ),
                          trailing: Icon(
                            CupertinoIcons.chevron_right,
                            color: Colors.grey[500],
                            size: 20,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditProfileScreen(user: state.user),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Role Switcher
                        BlocBuilder<ProfileRoleCubit, ProfileRoleState>(
                          builder: (_, roleState) {
                            return RoleSwitcher(
                              currentRole: roleState.selectedRole,
                              onRoleChanged: (role) {
                                _roleCubit.setRole(role);
                                if (role == UserRole.seller ||
                                    role == UserRole.driver) {
                                  _openRoleApp(context, role);
                                  Future.delayed(
                                    const Duration(milliseconds: 500),
                                    () {
                                      if (mounted) {
                                        _roleCubit.setRole(UserRole.buyer);
                                      }
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Expand the rest to take up screen real estate cleanly
                  Expanded(child: _buildBuyerTab(context)),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBuyerTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'General',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        _buildMenuTile(context, 'My Orders', FontAwesomeIcons.cartShopping, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
          );
        }),

        _buildMenuTile(context, 'My Wallet', FontAwesomeIcons.wallet, () {}),

        _buildMenuTile(context, 'Settings', FontAwesomeIcons.gear, () {}),
        _buildMenuTile(
          context,
          'Help & Support',
          FontAwesomeIcons.circleQuestion,
          () {},
        ),
        _buildMenuTile(
          context,
          'Logout',
          FontAwesomeIcons.rightFromBracket,
          () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Logout',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                content: Text(
                  'Are you sure you want to logout?',
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: GoogleFonts.poppins()),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Logout',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
