import 'package:icar/models/workshop.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkshopService {
  final _client = Supabase.instance.client;

  Future<List<Workshop>> getActiveWorkshops() async {
    final response = await _client
        .from('workshops')
        .select()
        .eq('is_active', true)
        .order('is_premium', ascending: false);

    return (response as List)
        .map((e) => Workshop.fromMap(e))
        .toList();
  }

  Future<List<Workshop>> getByCategory(String category) async {
    final response = await _client
        .from('workshops')
        .select()
        .eq('is_active', true)
        .ilike('type', '%$category%');

    return (response as List)
        .map((e) => Workshop.fromMap(e))
        .toList();
  }
}
