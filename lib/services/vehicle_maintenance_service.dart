import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleMaintenanceService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getMaintenances(String userVehicleId) async {
    final data = await _client
        .from('vehicle_maintenance')
        .select()
        .eq('user_vehicle_id', userVehicleId)
        .order('service_date', ascending: false)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> createMaintenance({
    required String userVehicleId,
    required String title,
    String? description,
    required int kmAtService,
    required DateTime serviceDate,
  }) async {
    await _client.from('vehicle_maintenance').insert({
      'user_vehicle_id': userVehicleId,
      'title': title,
      'description': (description?.trim().isEmpty ?? true) ? null : description,
      'km_at_service': kmAtService,
      'service_date': serviceDate.toIso8601String().substring(0, 10),
    });
  }

  Future<void> updateMaintenance({
    required String id,
    required String title,
    String? description,
    required int kmAtService,
    required DateTime serviceDate,
  }) async {
    await _client.from('vehicle_maintenance').update({
      'title': title,
      'description': (description?.trim().isEmpty ?? true) ? null : description,
      'km_at_service': kmAtService,
      'service_date': serviceDate.toIso8601String().substring(0, 10),
    }).eq('id', id);
  }

  Future<void> deleteMaintenance(String id) async {
    await _client.from('vehicle_maintenance').delete().eq('id', id);
  }
}
