import 'package:bookshare/firebase_options.dart';
import 'package:bookshare/src/constant/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Cubits
import 'cubits/auth/auth_cubit.dart';
import 'cubits/home/home_cubit.dart';
import 'cubits/books/books_cubit.dart';
import 'cubits/chat/chat_cubit.dart';
import 'cubits/profile/profile_cubit.dart';

// Screens
import 'screens/splash_screen.dart';
import 'src/auth/login_screen.dart';
import 'src/auth/signup_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'src/profile/my_listings_screen.dart';
import 'screens/add_book/add_book_screen.dart';
import 'screens/book/book_details_screen.dart';
import 'models/book.dart';

void main() async{

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const BookShareApp());
  
}

class BookShareApp extends StatelessWidget {
  const BookShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()..checkAuthStatus()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => BooksCubit()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: MaterialApp(
        title: 'Book Share',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7C3AED),
            brightness: Brightness.light,
            primary: const Color(0xFF7C3AED),
            secondary: const Color(0xFFEC4899),
            tertiary: const Color(0xFF06B6D4),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          cardTheme: CardThemeData(
            elevation: 4,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7C3AED),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        ),
          onGenerateRoute: MyRouter.generateRoute,
          initialRoute: SplashScreen.route,
     
      ),
    );
  }
}
