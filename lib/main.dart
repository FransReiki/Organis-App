import 'package:flutter/material.dart';
import 'package:organis_app/screens/register_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // ⬅️ WAJIB
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ⬅️ WAJIB

  await Supabase.initialize(
    url: 'https://rwgikjhguosmuwfdvsyo.supabase.co', // ⬅️ GANTI
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ3Z2lramhndW9zbXV3ZmR2c3lvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMzI3MzksImV4cCI6MjA4ODcwODczOX0._DqJBUIhbflbWKFRNn1RP7hn2L0LrP5rmkNfWELdZbc', // ⬅️ GANTI
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), //ganti login
    );
  }
}
