import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});

  @override
  State<MyVehicleScreen> createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
  final _supabase = Supabase.instance.client;

  Map<String, dynamic>? vehicle;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  Future<void> _loadVehicle() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final res = await _supabase
        .from('user_vehicle')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    setState(() {
      vehicle = res;
      loading = false;
    });
  }

  Future<void> _removeVehicle() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase
        .from('user_vehicle')
        .delete()
        .eq('user_id', user.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veículo removido')),
      );
      Navigator.pop(context);
    }
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
                      Text(
                        'Ano: ${vehicle!['year']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'KM atual: ${vehicle!['current_km']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text('Remover veículo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: _removeVehicle,
                      ),
                    ],
                  ),
                ),
    );
  }
}
