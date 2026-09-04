import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase.dart';
import '../models/salon_model.dart';

class SalonesService {
  final SupabaseClient _supabase = SupabaseConfig.cliente;

  Stream<List<SalonModel>> obtenerSalones() {
    return _supabase
        .from('salones')
        .stream(primaryKey: ['id'])
        .order('nombre')
        .map((lista) => lista.map((map) => SalonModel.fromMap(map)).toList());
  }

  Future<void> crearSalon(String nombre) async {
    await _supabase.from('salones').insert({'nombre': nombre});
  }

  Future<bool> haySalones() async {
    final res = await _supabase.from('salones').select('id').limit(1);
    return res.isNotEmpty;
  }
}