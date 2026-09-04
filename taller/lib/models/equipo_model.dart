class EquipoModel {
  final String id;
  final String codigo;
  final bool estado;
  final String? observacion;
  final String salonId;
  final String? reportadoPor;

  EquipoModel({
    required this.id,
    required this.codigo,
    required this.estado,
    this.observacion,
    required this.salonId,
    this.reportadoPor,
  });

  factory EquipoModel.fromMap(Map<String, dynamic> map) {
    return EquipoModel(
      id: map['id']?.toString() ?? '',
      codigo: map['codigo'] ?? '',
      estado: map['estado'] ?? true,
      observacion: map['observacion'],
      salonId: map['salon_id']?.toString() ?? '',
      reportadoPor: map['reportado_por']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'estado': estado,
      'observacion': observacion,
      'salon_id': salonId,
      'reportado_por': reportadoPor,
    };
  }
}