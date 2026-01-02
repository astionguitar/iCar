import 'package:flutter/material.dart';
import '../../services/vehicle_service.dart';
import 'vehicle_maintenance_screen.dart';

class VehicleHomeScreen extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const VehicleHomeScreen({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    final vehicleService = VehicleService();

    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle['model'] ?? 'Veículo'),
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
              'KM atual: ${vehicle['current_usage']} km',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // 🔥 BOTÃO MANUTENÇÕES
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VehicleMaintenanceScreen(
                        vehicle: vehicle,
                      ),
                    ),
                  );
                },
                child: const Text('Manutenções'),
              ),
            ),

            const SizedBox(height: 16),

            // ❌ REMOVER VEÍCULO
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
