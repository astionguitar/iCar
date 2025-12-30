import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/user_vehicle_service.dart';

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});

  @override
  State<MyVehicleScreen> createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
  final _service = UserVehicleService();
  Map<String, dynamic>? vehicle;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  Future<void> _loadVehicle() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final data = await _service.fetchUserVehicle(userId);

    setState(() {
      vehicle = data;
      loading = false;
    });
  }

  Future<void> _removeVehicle() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    await _service.deleteVehicle(userId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veículo removido')),
    );

    Navigator.pop(context); // VOLTA PRO PERFIL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu veículo')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : vehicle == null
              ? const Center(child: Text('Nenhum veículo cadastrado'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ano: ${vehicle!['year']}'),
                      const SizedBox(height: 8),
                      Text('KM atual: ${vehicle!['current_km']}'),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text('Remover veículo'),
                        onPressed: _removeVehicle,
                      ),
                    ],
                  ),
                ),
    );
  }
}
