import 'package:firebase_core/firebase_core.dart';
import 'package:home_needer/ui/business/business_landing_view.dart';
import 'package:home_needer/ui/index_view.dart';
import 'package:home_needer/ui/auth/login_view.dart';
import 'package:home_needer/ui/profile/profile_view.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_needer/ui/auth/registration_view.dart';
import 'package:home_needer/ui/initial_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Home Needer',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: TextTheme(
          // app bar title
          displayLarge: const TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),

          displayMedium:
              GoogleFonts.hind(fontSize: 24, fontWeight: FontWeight.bold),

          // headlines
          titleLarge:
              GoogleFonts.oswald(fontSize: 18, fontStyle: FontStyle.italic),
          // titleSmall: GoogleFonts.oswald(fontSize: 16),

          // bodies of text
          bodyMedium: GoogleFonts.merriweather(fontSize: 16),

          // validation messages for forms
          displaySmall: GoogleFonts.pacifico(fontSize: 14),
        ),
      ),
      initialRoute: 'initialView',
      routes: {
        "initialView": (context) => const InitialView(),
        "registrationView": (context) => const RegistrationView(),
        "loginView": (context) => const LoginView(),
        "indexView": (context) => const IndexView(),
        "profileView": (context) => const ProfileView(
              userId: '',
            ),
        "businessLandingView": (context) => BusinessLandingView(),
      },
    );
  }
}
