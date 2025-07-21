import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NokodoApp());
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
        primarySwatch: Colors.teal, // You can choose your app's theme color
        // Example of setting a default font for the whole app if desired:
        // textTheme: GoogleFonts.latoTextTheme(
        //   Theme.of(context).textTheme,
        // ),
      ),
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: const LoginScreen(),
    );
  }
}
