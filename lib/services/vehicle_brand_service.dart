import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleBrandService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchBrands() async {
    final response = await _supabase
        .from('vehicle_brands')
        .select()
        .order('name');

    return List<Map<String, dynamic>>.from(response);
  }
}
