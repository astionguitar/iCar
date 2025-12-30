import 'package:supabase_flutter/supabase_flutter.dart';

class UserVehicleService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchUserVehicle(String userId) async {
    return await _supabase
        .from('user_vehicle')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
  }

  Future<void> upsertVehicle({
    required String userId,
    required String brandId,
    required String modelId,
    required int year,
    required int currentKm,
  }) async {
    await _supabase.from('user_vehicle').upsert({
      'user_id': userId,
      'brand_id': brandId,
      'model_id': modelId,
      'year': year,
      'current_km': currentKm,
    });
  }

  /// 🚨 ISSO AQUI É O QUE ESTAVA FALTANDO
  Future<void> deleteVehicle(String userId) async {
    await _supabase
        .from('user_vehicle')
        .delete()
        .eq('user_id', userId);
  }
}
