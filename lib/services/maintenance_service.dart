import 'package:supabase_flutter/supabase_flutter.dart';

class MaintenanceService {
  final _client = Supabase.instance.client;

  // 🔹 LISTAR manutenções do veículo
  Future<List<Map<String, dynamic>>> getByVehicle(String vehicleId) async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('maintenance_history')
        .select()
        .eq('vehicle_id', vehicleId)
        .order('service_date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // 🔹 ADICIONAR manutenção
  Future<void> addMaintenance({
    required String vehicleId,
    required String maintenanceId,
    required DateTime serviceDate,
    num? serviceValue,
    String? notes,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    await _client.from('maintenance_history').insert({
      'user_id': user.id,
      'vehicle_id': vehicleId,
      'maintenance_id': maintenanceId,
      'service_date': serviceDate.toIso8601String(),
      'service_value': serviceValue,
      'notes': notes,
    });
  }
}
