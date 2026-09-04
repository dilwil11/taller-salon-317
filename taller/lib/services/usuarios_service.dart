import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase.dart';
import '../models/usuario_model.dart';

class UsuariosService {
  final SupabaseClient _supabase = SupabaseConfig.cliente;

  Future<UsuarioModel?> obtenerUsuarioActual() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final res = await _supabase
        .from('perfiles_usuarios')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (res == null) return null;
    return UsuarioModel.fromMap(res);
  }
}