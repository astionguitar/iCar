import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleModelService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchModelsByBrand(String brandId) async {
    final res = await _supabase
        .from('vehicle_models')
        .select('id, name')
        .eq('brand_id', brandId)
        .order('name');

    return List<Map<String, dynamic>>.from(res);
  }
}
