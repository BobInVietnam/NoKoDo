import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/utils/repository_manager.dart';
import 'modules/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
      create: (context) => RepoManager()
    ),
      ChangeNotifierProvider(
      create: (context) => TextStyleSettings()
      )
    ],
    child: const NokodoApp()));
}

class NokodoApp extends StatelessWidget {
  const NokodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring the entire app uses the Galindo font as a base could be done here,
    // or applied specifically where needed. For the title, we'll apply it directly.
    return MaterialApp(
      title: 'Nokodo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,dynamicSchemeVariant: DynamicSchemeVariant.fidelity),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.galindo(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700]
          ),
          displayLarge: GoogleFonts.rowdies(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700],
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[800]
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          )
        ),
        tabBarTheme: TabBarThemeData(

        ),
      ),
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: const LoginScreen(),
    );
  }
}
