import 'package:flutter/material.dart';

import '../../services/user_vehicle_service.dart';
import 'vehicle_maintenance_screen.dart';

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});

  @override
  State<MyVehicleScreen> createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
  final _service = UserVehicleService();
  late Future<Map<String, dynamic>?> _vehicleFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _vehicleFuture = _service.getUserVehicle();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _vehicleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final vehicle = snapshot.data;

        /// 🚗 SEM VEÍCULO
        if (vehicle == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Meu veículo')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/vehicle')
                      .then((_) => _reload());
                },
                child: const Text('Cadastrar veículo'),
              ),
            ),
          );
        }

        final int currentKm = (vehicle['current_km'] ?? 0) as int;

        return Scaffold(
          appBar: AppBar(title: const Text('Meu veículo')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ano: ${vehicle['year']}'),
                const SizedBox(height: 8),

                Text(
                  'KM atual: $currentKm km',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔄 ATUALIZAR KM
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final controller = TextEditingController();

                      final result = await showDialog<int>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Atualizar KM'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: 'Novo KM'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  int.tryParse(controller.text),
                                );
                              },
                              child: const Text('Salvar'),
                            ),
                          ],
                        ),
                      );

                      if (result != null) {
                        await _service.updateCurrentKm(
                          vehicleId: vehicle['id'].toString(),
                          newKm: result,
                        );
                        _reload();
                      }
                    },
                    child: const Text('Atualizar KM'),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔧 MANUTENÇÕES
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VehicleMaintenanceScreen(
                            userVehicleId: vehicle['id'].toString(),
                            currentKm: currentKm,
                          ),
                        ),
                      );
                    },
                    child: const Text('Manutenções'),
                  ),
                ),

                const Spacer(),

                /// 🗑️ REMOVER VEÍCULO
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      await _service.deleteVehicle(vehicle['id'].toString());
                      _reload();
                    },
                    child: const Text('Remover veículo'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
