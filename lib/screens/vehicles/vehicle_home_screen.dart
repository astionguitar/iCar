import 'package:flutter/material.dart';
import '../../services/user_vehicle_service.dart';

class VehicleHomeScreen extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const VehicleHomeScreen({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    final vehicleService = UserVehicleService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu veículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ano: ${vehicle['year']}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              'KM atual: ${vehicle['current_km']} km',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Atualizar KM
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final controller = TextEditingController();

                  final result = await showDialog<int>(
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
                                int.tryParse(controller.text),
                              );
                            },
                            child: const Text('Salvar'),
                          ),
                        ],
                      );
                    },
                  );

                  if (result != null) {
                    await vehicleService.updateCurrentKm(
                      vehicleId: vehicle['id'],
                      newKm: result,
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Atualizar KM'),
              ),
            ),

            const Spacer(),

            // ❌ Remover veículo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  await vehicleService.deleteVehicle(vehicle['id']);
                  Navigator.pop(context);
                },
                child: const Text('Remover veículo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
