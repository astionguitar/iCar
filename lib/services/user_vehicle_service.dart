import 'package:supabase_flutter/supabase_flutter.dart';

class UserVehicleService {
  final _client = Supabase.instance.client;

  /// Retorna o veículo do usuário logado (1 por usuário)
  Future<Map<String, dynamic>?> getUserVehicle() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from('user_vehicle')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    return data;
  }

  /// Cria ou atualiza o veículo do usuário
  Future<void> upsertVehicle({
    required String brandId,
    required String modelId,
    required int year,
    required int currentKm,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('user_vehicle').upsert({
      'user_id': user.id,
      'brand_id': brandId,
      'model_id': modelId,
      'year': year,
      'current_km': currentKm,
    });
  }

  /// Atualiza apenas o KM
  Future<void> updateCurrentKm({
    required String vehicleId,
    required int newKm,
  }) async {
    await _client
        .from('user_vehicle')
        .update({'current_km': newKm})
        .eq('id', vehicleId);
  }

  /// Remove o veículo
  Future<void> deleteVehicle(String vehicleId) async {
    await _client
        .from('user_vehicle')
        .delete()
        .eq('id', vehicleId);
  }
}
