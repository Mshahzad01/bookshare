import 'package:bookshare/src/buyer/home/screen/home_screen.dart';
import 'package:bookshare/screens/main_navigation_screen.dart';
import 'package:bookshare/screens/splash_screen.dart';
import 'package:bookshare/src/auth/login_screen.dart';
import 'package:bookshare/src/auth/signup_screen.dart';
import 'package:flutter/material.dart';

mixin MyRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashScreen(),
        );
      case MainNavigationScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainNavigationScreen(),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );

      case LoginScreen.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );

      case SignupScreen.route:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SignupScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
