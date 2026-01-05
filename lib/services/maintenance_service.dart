import 'package:supabase_flutter/supabase_flutter.dart';

class MaintenanceService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getByVehicle(String vehicleId) async {
    final response = await _client
        .from('maintenance_history')
        .select('*, maintenance_types(name)')
        .eq('vehicle_id', vehicleId)
        .order('service_date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addMaintenance({
    required String vehicleId,
    required String title,
    String? description,
    required int km,
    required String maintenanceTypeId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('maintenance_history').insert({
      'user_id': user.id,
      'vehicle_id': vehicleId,
      'title': title,
      'description': description,
      'usage_at_service': km,
      'maintenance_type_id': maintenanceTypeId,
    });
  }

  Future<void> deleteMaintenance(String id) async {
    await _client
        .from('maintenance_history')
        .delete()
        .eq('id', id);
  }
}
