import 'package:flutter/material.dart';

import '../../services/vehicle_maintenance_service.dart';
import 'vehicle_maintenance_form_screen.dart';

class VehicleMaintenanceScreen extends StatefulWidget {
  final String userVehicleId;
  final int currentKm;

  const VehicleMaintenanceScreen({
    super.key,
    required this.userVehicleId,
    required this.currentKm,
  });

  @override
  State<VehicleMaintenanceScreen> createState() =>
      _VehicleMaintenanceScreenState();
}

class _VehicleMaintenanceScreenState extends State<VehicleMaintenanceScreen> {
  final _service = VehicleMaintenanceService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = _service.getMaintenances(widget.userVehicleId);
    setState(() {});
  }

  Future<void> _openCreate() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleMaintenanceFormScreen(
          userVehicleId: widget.userVehicleId,
          currentKm: widget.currentKm,
        ),
      ),
    );

    if (ok == true) _reload();
  }

  Future<void> _openEdit(Map<String, dynamic> maintenance) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleMaintenanceFormScreen(
          userVehicleId: widget.userVehicleId,
          currentKm: widget.currentKm,
          existing: maintenance,
        ),
      ),
    );

    if (ok == true) _reload();
  }

  Future<void> _confirmAndDelete(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir manutenção?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _service.deleteMaintenance(id);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Manutenção excluída')));
    _reload();
  }

  String _formatDate(dynamic value) {
    if (value == null) return '';
    final s = value.toString();
    return s.length >= 10 ? s.substring(0, 10) : s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manutenções')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text('Nenhuma manutenção registrada'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final item = data[i];

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _openEdit(item),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (item['title'] ?? '').toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'KM: ${item['km_at_service']} • ${_formatDate(item['service_date'])}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ✏️ EDITAR
                    IconButton(
                      tooltip: 'Editar',
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openEdit(item),
                    ),

                    // 🗑️ EXCLUIR (com confirmação)
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmAndDelete(item['id'].toString()),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
