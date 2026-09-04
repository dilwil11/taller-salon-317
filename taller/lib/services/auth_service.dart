import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase.dart';
import 'storage_service.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.cliente;
  final StorageService _storageService = StorageService();

  User? get usuarioActual => _supabase.auth.currentUser;

  Future<AuthResponse> registrar({
    required String email,
    required String password,
    required String nombre,
    String rol = 'aprendiz',
    File? imagenAvatar, // Opcional
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      String? avatarUrl;

      if (imagenAvatar != null) {
        avatarUrl = await _storageService.subirEvidencia(
          imagenAvatar,
          'avatar_${response.user!.id}.jpg',
        );
      }

      await _supabase.from('perfiles_usuarios').insert({
        'id': response.user!.id,
        'nombre': nombre,
        'rol': rol,
        'correo': email,
        'avatar_url': avatarUrl, // Puede ser null
      });
    }

    return response;
  }

  Future<AuthResponse> iniciarSesion({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> cerrarSesion() async {
    await _supabase.auth.signOut();
  }
}