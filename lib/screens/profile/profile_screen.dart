import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../vehicles/vehicle_setup_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user?.email ?? ''),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Alterar senha'),
            ),

            // 👇 OPÇÃO B — VEÍCULO
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Cadastrar / editar veículo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VehicleSetupScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
