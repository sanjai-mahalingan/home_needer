import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_needer/ui/initial_view.dart';

void main() {
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
              fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),

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
      },
    );
  }
}
