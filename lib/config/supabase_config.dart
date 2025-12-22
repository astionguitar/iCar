import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://gsazqvzgppfadxwmrsts.supabase.co';
  static const String anonKey = 'sb_publishable_lJHqXK3d2jcVofu9OPcUcw_hrzRxuFf';

  static SupabaseClient get client => Supabase.instance.client;
}
