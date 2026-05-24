import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/models/converted_file.dart';
import 'package:nodyslexia/modules/file_to_text/file_to_text_viewmodel.dart';
import 'package:nodyslexia/modules/reading/reading_viewmodel.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/data/remote_database.dart';
import 'package:nodyslexia/utils/ocr_service.dart';
import 'package:nodyslexia/utils/tts_service.dart';
import 'data/repository_manager.dart';
import 'modules/editing/editing_screen.dart';
import 'modules/editing/editing_viewmodel.dart';
import 'modules/file_to_text/file_to_text_screen.dart';
import 'modules/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'modules/reading/reading_screen.dart';
import 'modules/testing_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  TtsService();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
      create: (context) => RepoManager(
          onlineDatabase: TestRemoteDatabase(),
          database: TestLocalDatabase())
    ),
      ChangeNotifierProvider(
      create: (context) => TextStyleSettings()
      ),
      ChangeNotifierProvider<LocalDatabase>(
          create: (context) => TestLocalDatabase()
      ),
    ],
    child: const TestNokodoApp()));
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
            fontSize: 52,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700]
          ),
          displayLarge: GoogleFonts.rowdies(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700],
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 30,
            color: Colors.grey[700]
          ),
          bodyMedium: GoogleFonts.poppins(
              fontSize: 22,
              color: Colors.grey[800]
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[800]
          ),
        ),
        tabBarTheme: TabBarThemeData(

        ),
      ),
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: const LoginScreen(),
    );
  }
}

class TestNokodoApp extends StatelessWidget {
  const TestNokodoApp({super.key});

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
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700]
          ),
          displayLarge: GoogleFonts.rowdies(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700],
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
          bodyLarge: GoogleFonts.poppins(
              fontSize: 30,
              color: Colors.grey[700]
          ),
          bodyMedium: GoogleFonts.poppins(
              fontSize: 22,
              color: Colors.grey[800]
          ),
          bodySmall: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[800]
          ),
        ),
        tabBarTheme: TabBarThemeData(

        ),
      ),
      debugShowCheckedModeBanner: true, // Removes the debug banner
      home: ChangeNotifierProvider(
        create: (context) => FileToTextViewModel(
            ocrService: MockOCRService(),
            localDatabase: context.read<LocalDatabase>()
        ),
        child: FileToTextScreen(),
      )
    );
  }
}