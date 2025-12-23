import 'package:supabase_flutter/supabase_flutter.dart';

class WorkshopReviewService {
  final _client = Supabase.instance.client;

  Future<void> upsertReview({
    required int workshopId,
    required String userId,
    required int rating,
    String? comment,
  }) async {
    final response = await _client
        .from('workshop_reviews')
        .upsert(
          {
            'workshop_id': workshopId,
            'user_id': userId,
            'rating': rating,
            'comment': comment,
          },
          onConflict: 'workshop_id,user_id',
        )
        .select();

    if (response.isEmpty) {
      throw Exception('Erro ao salvar avaliação');
    }
  }

  Future<List<Map<String, dynamic>>> fetchReviews(
    int workshopId,
  ) async {
    final response = await _client
        .from('workshop_reviews')
        .select(
          'rating, comment, created_at, user_id',
        )
        .eq('workshop_id', workshopId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> fetchRatingSummary(
    int workshopId,
  ) async {
    return await _client
        .from('workshop_rating_summary')
        .select()
        .eq('workshop_id', workshopId)
        .maybeSingle();
  }
}
