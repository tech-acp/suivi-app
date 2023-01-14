import 'package:supabase_flutter/supabase_flutter.dart';

export 'database/database.dart';
export 'storage/storage.dart';

const _kSupabaseUrl = 'https://svbtqggtspnhpbfbgswf.supabase.co';
const _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN2YnRxZ2d0c3BuaHBiZmJnc3dmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI1OTExMzUsImV4cCI6MTk4ODE2NzEzNX0.eFHDCee0EIhj2l7Z0lwDi84ALB631pcasSoO9MQLbRg';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        anonKey: _kSupabaseAnonKey,
      );
}
