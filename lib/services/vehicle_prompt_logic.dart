import 'package:supabase_flutter/supabase_flutter.dart';

class VehiclePromptLogic {
  final _supabase = Supabase.instance.client;

  /// retorna TRUE se deve perguntar
  Future<bool> shouldAskForVehicle() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    // 1️⃣ já tem veículo?
    final vehicle = await _supabase
        .from('user_vehicle')
        .select('id')
        .eq('user_id', user.id)
        .maybeSingle();

    if (vehicle != null) return false;

    // 2️⃣ usuário pediu pra não perguntar mais?
    final prefs = await _supabase
        .from('user_preferences')
        .select('skip_vehicle_prompt')
        .eq('user_id', user.id)
        .maybeSingle();

    if (prefs != null && prefs['skip_vehicle_prompt'] == true) {
      return false;
    }

    return true;
  }

  /// marca para não perguntar mais
  Future<void> disablePrompt() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('user_preferences').upsert({
      'user_id': user.id,
      'skip_vehicle_prompt': true,
    });
  }
}
