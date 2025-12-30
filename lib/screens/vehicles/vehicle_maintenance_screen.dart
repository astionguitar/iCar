import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleMaintenanceScreen extends StatefulWidget {
  final String vehicleId;
  final double currentUsage;

  const VehicleMaintenanceScreen({
    super.key,
    required this.vehicleId,
    required this.currentUsage,
  });

  @override
  State<VehicleMaintenanceScreen> createState() =>
      _VehicleMaintenanceScreenState();
}

class _VehicleMaintenanceScreenState extends State<VehicleMaintenanceScreen> {
  final _supabase = Supabase.instance.client;
  bool _loading = true;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _supabase
        .from('v_maintenance_status')
        .select()
        .eq('vehicle_id', widget.vehicleId)
        .order('maintenance_type');

    setState(() {
      _items = List<Map<String, dynamic>>.from(data);
      _loading = false;
    });
  }

  Color _statusColor(String status) {
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

  String _statusText(String status) {
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

  Future<void> _registerMaintenance(String type) async {
    await _supabase.rpc(
      'register_maintenance',
      params: {
        'p_vehicle_id': widget.vehicleId,
        'p_maintenance_type': type,
        'p_service_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'p_service_usage': widget.currentUsage,
      },
    );

    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manutenções')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final item = _items[i];
                final status = item['status'];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading:
                        Icon(Icons.build, color: _statusColor(status)),
                    title: Text(item['maintenance_type']),
                    subtitle: Text(_statusText(status)),
                    trailing: ElevatedButton(
                      onPressed: () =>
                          _registerMaintenance(item['maintenance_type']),
                      child: const Text('Registrar'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
