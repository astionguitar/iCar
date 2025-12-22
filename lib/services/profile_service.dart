import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> getMyProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final res = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return res;
  }

  Future<void> upsertProfile({
    required String name,
    required String phone,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('profiles').upsert({
      'id': user.id,
      'name': name,
      'phone': phone,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
