import 'package:supabase_flutter/supabase_flutter.dart';

class UserVehicleService {
  final _client = Supabase.instance.client;

  Future<void> upsertVehicle({
    required String userId,
    required String brandId,
    required String modelId,
    required int year,
    required int currentKm,
  }) async {
    await _client.from('user_vehicle').upsert(
      {
        'user_id': userId,
        'brand_id': brandId,
        'model_id': modelId,
        'year': year,
        'current_km': currentKm,
      },
      onConflict: 'user_id', // 🔥 AQUI ESTÁ A CHAVE
    );
  }

  Future<Map<String, dynamic>?> getVehicleByUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final res = await _client
        .from('user_vehicle')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    return res;
  }
}
