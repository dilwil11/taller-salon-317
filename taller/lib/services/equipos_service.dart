import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase.dart';
import '../models/equipo_model.dart';

class EquiposService {
  final SupabaseClient _supabase = SupabaseConfig.cliente;

  Stream<List<EquipoModel>> streamTodosLosEquipos() {
    return _supabase
        .from('equipos')
        .stream(primaryKey: ['id'])
        .map((lista) => lista.map((map) => EquipoModel.fromMap(map)).toList());
  }

  Stream<List<EquipoModel>> streamEquiposPorSalon(String salonId) {
    return _supabase
        .from('equipos')
        .stream(primaryKey: ['id'])
        .eq('salon_id', salonId)
        .order('codigo', ascending: true)
        .map((lista) => lista.map((map) => EquipoModel.fromMap(map)).toList());
  }

  Future<List<EquipoModel>> obtenerEquiposPorSalon(String salonId) async {
    final res = await _supabase
        .from('equipos')
        .select()
        .eq('salon_id', salonId)
        .order('codigo', ascending: true);

    return (res as List).map((map) => EquipoModel.fromMap(map)).toList();
  }

  Future<void> crearEquipo({
    required String codigo,
    required String salonId,
  }) async {
    final usuarioId = _supabase.auth.currentUser?.id;

    await _supabase.from('equipos').insert({
      'codigo': codigo,
      'salon_id': salonId,
      'estado': true,
      'reportado_por': usuarioId,
    });
  }

  Future<void> actualizarReporteEquipo({
    required String equipoId,
    required bool estado,
    required String observacion,
  }) async {
    final usuarioId = _supabase.auth.currentUser?.id;

    await _supabase.from('equipos').update({
      'estado': estado,
      'observacion': observacion,
      'reportado_por': usuarioId,
    }).eq('id', equipoId);
  }
}