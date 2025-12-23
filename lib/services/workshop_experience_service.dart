import 'package:supabase_flutter/supabase_flutter.dart';

class WorkshopExperienceService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTags(int workshopId) async {
    final response = await _client
        .from('workshop_experience_tags')
        .select('tag, user_id')
        .eq('workshop_id', workshopId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addTag({
    required int workshopId,
    required String tag,
    required String userId,
  }) async {
    await _client.from('workshop_experience_tags').insert({
      'workshop_id': workshopId,
      'user_id': userId,
      'tag': tag,
    });
  }

  Future<void> removeTag({
    required int workshopId,
    required String tag,
    required String userId,
  }) async {
    await _client
        .from('workshop_experience_tags')
        .delete()
        .eq('workshop_id', workshopId)
        .eq('user_id', userId)
        .eq('tag', tag);
  }
}
