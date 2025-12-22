import 'package:flutter/material.dart';
import 'package:icar/screens/auth/login_screen.dart';
import 'package:icar/screens/home/home_screen.dart';
import 'package:icar/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SUPABASE — URL + ANON KEY (publishable)
  const supabaseUrl = 'https://gsazqvzgppfadxwmrsts.supabase.co';
  const supabaseAnonKey ='sb_publishable_lJHqXK3d2jcVofu9OPcUcw_hrzRxuFf';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iCar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: SupabaseService().authStateChanges,
      builder: (context, snapshot) {
        // Enquanto verifica sessão
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Sessão atual
        final session = snapshot.data?.session;

        // Usuário logado
        if (session != null) {
          return const HomeScreen();
        }

        // Usuário não logado
        return const LoginScreen();
      },
    );
  }
}
