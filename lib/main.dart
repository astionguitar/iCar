import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gsazqvzgppfadxwmrsts.supabase.co',
    anonKey: 'sb_publishable_lJHqXK3d2jcVofu9OPcUcw_hrzRxuFf',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iCar',
      theme: ThemeData(
        primaryColor: const Color(0xFF2F55D4),
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
        useMaterial3: true,
      ),

      // ✅ VISITANTE REAL
      home: const HomeScreen(),

      // ❌ NÃO COLOQUE '/'
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

