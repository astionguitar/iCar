import 'package:flutter/material.dart';
import '../../services/vehicle_service.dart';
import 'vehicle_maintenance_screen.dart';

class VehicleHomeScreen extends StatefulWidget {
  const VehicleHomeScreen({super.key});

  @override
  State<VehicleHomeScreen> createState() => _VehicleHomeScreenState();
}

class _VehicleHomeScreenState extends State<VehicleHomeScreen> {
  late Future<Map<String, dynamic>?> _vehicleFuture;
  final VehicleService _service = VehicleService();

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  void _loadVehicle() {
    _vehicleFuture = _service.getMainVehicle();
  }

  void _openUpdateKmDialog(Map<String, dynamic> vehicle) {
    final controller = TextEditingController(
      text: vehicle['current_usage'].toString(),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atualizar KM'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'KM atual',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final value = double.tryParse(controller.text);
              if (value == null) return;

              await _service.updateCurrentUsage(
                vehicleId: vehicle['id'],
                newUsage: value,
              );

              Navigator.pop(context);

              setState(() {
                _loadVehicle();
              });
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
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

        if (!snapshot.hasData || snapshot.data == null) {
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

        final vehicle = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text('${vehicle['brand']} ${vehicle['model']}'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle['current_usage']} ${vehicle['usage_unit']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () => _openUpdateKmDialog(vehicle),
                  icon: const Icon(Icons.edit),
                  label: const Text('Atualizar KM'),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VehicleMaintenanceScreen(
                          vehicleId: vehicle['id'],
                          currentUsage:
                              (vehicle['current_usage'] as num).toDouble(),
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
      },
    );
  }
}
