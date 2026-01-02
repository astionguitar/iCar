import 'package:flutter/material.dart';
import '../../services/maintenance_service.dart';

class VehicleMaintenanceScreen extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  const VehicleMaintenanceScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<VehicleMaintenanceScreen> createState() =>
      _VehicleMaintenanceScreenState();
}

class _VehicleMaintenanceScreenState
    extends State<VehicleMaintenanceScreen> {
  final maintenanceService = MaintenanceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manutenções'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: maintenanceService.getByVehicle(widget.vehicle['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar manutenções'));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text('Nenhuma manutenção registrada'),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return ListTile(
                leading: const Icon(Icons.build),
                title: Text(
                  item['service_date'],
                ),
                subtitle: Text(
                  item['notes'] ?? '',
                ),
                trailing: item['service_value'] != null
                    ? Text('R\$ ${item['service_value']}')
                    : null,
              );
            },
          );
        },
      ),

      // ➕ FUTURO: adicionar manutenção
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // passo seguinte
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
