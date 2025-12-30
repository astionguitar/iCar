import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/vehicles/vehicle_setup_screen.dart';
import 'screens/vehicles/my_vehicle_screen.dart';
import 'screens/vehicles/vehicle_home_screen.dart';
import 'screens/vehicles/vehicle_maintenance_screen.dart';

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

      // 🔒 fluxo NORMAL do app
      home: const HomeScreen(),

      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/vehicle': (_) => const VehicleSetupScreen(),
        '/my-vehicle': (_) => const MyVehicleScreen(),

        // 🧪 telas de TESTE (isoladas)
        '/vehicle-test': (_) => const VehicleHomeScreen(
              vehicleId: 'ced664a7-b9ee-40fd-b78f-65d6f15a026a',
              vehicleName: 'Ford Ka 2015',
              currentUsage: 10050,
            ),

        '/maintenance-test': (_) => const VehicleMaintenanceScreen(
              vehicleId: 'ced664a7-b9ee-40fd-b78f-65d6f15a026a',
              currentUsage: 10050,
            ),
      },
    );
  }
}
