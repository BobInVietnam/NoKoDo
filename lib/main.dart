import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/models/converted_file.dart';
import 'package:nodyslexia/modules/file_to_text/file_to_text_viewmodel.dart';
import 'package:nodyslexia/modules/library/library_screen.dart';
import 'package:nodyslexia/modules/library/library_viewmodel.dart';
import 'package:nodyslexia/modules/reading/editable_reading_viewmodel.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/data/remote_database.dart';
import 'package:nodyslexia/utils/audio_recorder.dart';
import 'package:nodyslexia/utils/ocr_service.dart';
import 'package:nodyslexia/utils/tts_service.dart';
import 'package:nodyslexia/utils/url_provider.dart';
import 'package:nodyslexia/utils/usage_time_tracker.dart';
import 'data/repository_manager.dart';
import 'modules/file_to_text/file_to_text_screen.dart';
import 'modules/login/login_screen.dart';
import 'modules/login/login_viewmodel.dart';
import 'modules/testing_screen.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UrlProvider();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => RepoManager(
            onlineDatabase: LocalhostRemoteDatabase(),
            database: TestLocalDatabase())
      ),
      ChangeNotifierProvider<LocalDatabase>(
        create: (context) => TestLocalDatabase()
      ),
      ChangeNotifierProvider(
        create: (context) => NokodoSettings(context.read<LocalDatabase>())
      ),
      ChangeNotifierProvider(
        create: (context) => UsageTimeTracker(repoManager: context.read<RepoManager>())
      ),
      ChangeNotifierProvider<TtsService>(
        create: (context) => TtsService(settings: context.read<NokodoSettings>()),
      ),
      ChangeNotifierProvider<AudioRecorder>(
          create: (context) => AudioRecorder() )
      ],
    child: const NokodoApp())
  );
}

class NokodoApp extends StatelessWidget {
  const NokodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nokodo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,dynamicSchemeVariant: DynamicSchemeVariant.fidelity),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.paytoneOne(
            fontSize: 52,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700]
          ),
          displayLarge: GoogleFonts.paytoneOne(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700],
          ),
          displayMedium: TextStyle(
            fontFamily: "VniAvo",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700]
          ),
          bodyLarge: TextStyle(
              fontFamily: "VniAvo",
              fontSize: 28,
              color: Colors.grey[800]
          ),
          bodyMedium: TextStyle(
            fontFamily: "VniAvo",
            fontSize: 24,
            color: Colors.grey[900]
          ),
          bodySmall: TextStyle(
              fontFamily: "VniAvo",
              fontSize: 16,
              color: Colors.grey[900]
          ),
        ),
        tabBarTheme: TabBarThemeData(

        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "VniAvo"
            )
          )
        )  ,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[700],
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "VniAvo"
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: ChangeNotifierProvider(
          create: (context) => LoginViewModel(
            repoManager: context.read<RepoManager>(),
            textSettings: context.read<NokodoSettings>(),
            usageTimeTracker: context.read<UsageTimeTracker>(),
          ),
          child: const LoginScreen()
      )
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
      home: AScreen()
      // home: ChangeNotifierProvider(
      //   create: (context) => FileToTextViewModel(
      //       ocrService: MockOCRService(),
      //       localDatabase: context.read<LocalDatabase>()
      //   ),
      //   child: FileToTextScreen(),
      // )
      // home: ChangeNotifierProvider(create: (context) =>
      //     LibraryViewModel(localDatabase: context.read<LocalDatabase>()),
      //     child: LibraryScreen()
      // )
    );
  }
}