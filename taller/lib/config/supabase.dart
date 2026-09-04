import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://errejtfkuxogrjbtpvzk.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVycmVqdGZrdXhvZ3JqYnRwdnprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgxODc3NjcsImV4cCI6MjEwMzc2Mzc2N30.JZqp5khnvz3UUxcEDNLjMGEefIgQeyO9i_t5XqOETLc';

  static Future<void> inicializar() async {
      await Supabase.initialize(
        url: url,
        publishableKey: anonKey,
    );
  }

  static SupabaseClient get cliente => Supabase.instance.client;
}