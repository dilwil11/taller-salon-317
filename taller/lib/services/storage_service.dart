import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase.dart';

class StorageService {
  final SupabaseClient _supabase = SupabaseConfig.cliente;

  Future<String?> subirEvidencia(File archivo, String nombreArchivo) async {
    try {
      final ruta = 'evidencias/${DateTime.now().millisecondsSinceEpoch}_$nombreArchivo';
      
      await _supabase.storage.from('evidencias_equipos').upload(
            ruta,
            archivo,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String urlPublica = _supabase.storage
          .from('evidencias_equipos')
          .getPublicUrl(ruta);

      return urlPublica;
    } catch (e) {
      return null;
    }
  }
}