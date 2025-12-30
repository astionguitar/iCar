import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleHomeScreen extends StatefulWidget {
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
  State<VehicleHomeScreen> createState() => _VehicleHomeScreenState();
}

class _VehicleHomeScreenState extends State<VehicleHomeScreen> {
  final supabase = Supabase.instance.client;
  bool loading = true;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final response = await supabase
        .from('v_maintenance_status')
        .select()
        .eq('vehicle_id', widget.vehicleId)
        .order('maintenance_type');

    setState(() {
      items = List<Map<String, dynamic>>.from(response);
      loading = false;
    });
  }

  Color statusColor(String status) {
    switch (status) {
      case 'ok':
        return Colors.green;
      case 'proxima':
        return Colors.orange;
      case 'atrasada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String statusText(String status) {
    switch (status) {
      case 'ok':
        return 'Em dia';
      case 'proxima':
        return 'Vence em breve';
      case 'atrasada':
        return 'Atrasada';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicleName),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔝 TOPO DO VEÍCULO
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.currentUsage.toStringAsFixed(0)} km',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // depois: atualizar km
                        },
                        child: const Text('Atualizar km'),
                      )
                    ],
                  ),
                ),

                // 📋 LISTA DE MANUTENÇÕES
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final status = item['status'] as String;

                      return ListTile(
                        title: Text(item['maintenance_type']),
                        subtitle: Text(statusText(status)),
                        leading: Icon(
                          Icons.build,
                          color: statusColor(status),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            debugPrint(
                                'Registrar ${item['maintenance_type']}');
                          },
                          child: const Text('Registrar'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
