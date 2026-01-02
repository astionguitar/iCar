import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleService {
  final _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> getMainVehicle() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final res = await _client
        .from('vehicles')
        .select()
        .eq('user_id', user.id)
        .eq('is_main', true)
        .maybeSingle();

    return res;
  }

  Future<void> updateCurrentUsage({
    required String vehicleId,
    required num newUsage,
  }) async {
    await _client
        .from('vehicles')
        .update({'current_usage': newUsage})
        .eq('id', vehicleId);
  }
}
