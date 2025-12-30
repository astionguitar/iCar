import 'package:flutter/material.dart';
import 'vehicle_maintenance_screen.dart';

class VehicleHomeScreen extends StatelessWidget {
  final String vehicleId;
  final String vehicleName;
  final double currentUsage;

  const VehicleHomeScreen({
    super.key,
    required this.vehicleId,
    required this.vehicleName,
    required this.currentUsage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(vehicleName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${currentUsage.toStringAsFixed(0)} km',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VehicleMaintenanceScreen(
                      vehicleId: vehicleId,
                      currentUsage: currentUsage,
                    ),
                  ),
                );
              },
              child: const Text('Abrir Manutenções'),
            ),
          ],
        ),
      ),
    );
  }
}
