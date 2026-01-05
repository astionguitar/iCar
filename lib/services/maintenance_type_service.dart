import 'package:supabase_flutter/supabase_flutter.dart';

class MaintenanceTypeService {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAll() async {
    final response = await _client
        .from('maintenance_types')
        .select()
        .order('name');

    return List<Map<String, dynamic>>.from(response);
  }
}
