import 'package:flutter/material.dart';
import '../../services/vehicle_service.dart';

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});

  @override
  State<MyVehicleScreen> createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
  final _service = VehicleService();
  late Future<Map<String, dynamic>?> _vehicleFuture;

  @override
  void initState() {
    super.initState();
    _vehicleFuture = _service.getMainVehicle();
  }

  void _reload() {
    setState(() {
      _vehicleFuture = _service.getMainVehicle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _vehicleFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Meu veículo')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final vehicle = snapshot.data;
        if (vehicle == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Meu veículo')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/vehicle');
                },
                child: const Text('Cadastrar veículo'),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${vehicle['brand']} ${vehicle['model']}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ano: ${vehicle['year']}'),
                const SizedBox(height: 8),
                Text(
                  'KM atual: ${vehicle['current_usage']} ${vehicle['usage_unit']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    final controller = TextEditingController();

                    final result = await showDialog<num>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Atualizar KM'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Novo KM',
                            ),
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
                                  num.tryParse(controller.text),
                                );
                              },
                              child: const Text('Salvar'),
                            ),
                          ],
                        );
                      },
                    );

                    if (result != null) {
                      await _service.updateCurrentUsage(
                        vehicleId: vehicle['id'],
                        newUsage: result,
                      );

                      _reload();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('KM atualizado com sucesso'),
                        ),
                      );
                    }
                  },
                  child: const Text('Atualizar KM'),
                ),

                const Spacer(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    await VehicleService()
                        .updateCurrentUsage(
                          vehicleId: vehicle['id'],
                          newUsage: 0,
                        );
                  },
                  child: const Text('Remover veículo'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
