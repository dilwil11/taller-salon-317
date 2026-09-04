import 'package:flutter/material.dart';
import '../models/equipo_model.dart';
import '../models/salon_model.dart';
import '../models/usuario_model.dart';
import '../services/equipos_service.dart';
import '../services/salones_service.dart';
import '../services/usuarios_service.dart';
import '../widgets/campo_texto.dart';
import '../widgets/boton_principal.dart';

class ReporteFormScreen extends StatefulWidget {
  final EquipoModel? equipoExistente;
  final String? salonId;

  const ReporteFormScreen({
    super.key,
    this.equipoExistente,
    this.salonId,
  });

  @override
  State<ReporteFormScreen> createState() => _ReporteFormScreenState();
}

class _ReporteFormScreenState extends State<ReporteFormScreen> {
  late bool _estadoOperativo;
  late TextEditingController _observacionCtrl;
  bool _enviando = false;
  bool _cargandoDatos = true;

  String? _salonSeleccionadoId;
  String? _equipoSeleccionadoId;

  List<SalonModel> _listaSalones = [];
  List<EquipoModel> _listaEquipos = [];
  UsuarioModel? _usuarioActual;

  final EquiposService _equiposService = EquiposService();
  final SalonesService _salonesService = SalonesService();
  final UsuariosService _usuariosService = UsuariosService();

  @override
  void initState() {
    super.initState();
    _estadoOperativo = widget.equipoExistente?.estado ?? false;
    _observacionCtrl = TextEditingController(text: widget.equipoExistente?.observacion ?? '');
    _salonSeleccionadoId = widget.salonId ?? widget.equipoExistente?.salonId;
    _equipoSeleccionadoId = widget.equipoExistente?.id;
    _cargarDatosIniciales();
  }

  @override
  void dispose() {
    _observacionCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosIniciales() async {
    setState(() => _cargandoDatos = true);
    final usuario = await _usuariosService.obtenerUsuarioActual();
    final salones = await _salonesService.obtenerSalones().first;

    if (mounted) {
      setState(() {
        _usuarioActual = usuario;
        _listaSalones = salones;
        if (_salonSeleccionadoId == null && salones.isNotEmpty) {
          _salonSeleccionadoId = salones.first.id;
        }
      });

      if (_salonSeleccionadoId != null) {
        await _cargarEquiposDelSalon(_salonSeleccionadoId!);
      } else {
        setState(() => _cargandoDatos = false);
      }
    }
  }

  Future<void> _cargarEquiposDelSalon(String salonId) async {
    final equipos = await _equiposService.obtenerEquiposPorSalon(salonId);
    if (mounted) {
      setState(() {
        _listaEquipos = equipos;
        if (_equipoSeleccionadoId == null || !equipos.any((e) => e.id == _equipoSeleccionadoId)) {
          _equipoSeleccionadoId = equipos.isNotEmpty ? equipos.first.id : null;
        }
        _cargandoDatos = false;
      });
    }
  }

  Future<void> _guardarReporte() async {
    final rol = _usuarioActual?.rol ?? 'aprendiz';

    if (rol == 'aprendiz') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los aprendices no tienen permisos para enviar reportes.')),
      );
      return;
    }

    if (_equipoSeleccionadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay ningún equipo seleccionado o registrado para este salón.')),
      );
      return;
    }

    setState(() => _enviando = true);
    try {
      await _equiposService.actualizarReporteEquipo(
        equipoId: _equipoSeleccionadoId!,
        estado: _estadoOperativo,
        observacion: _observacionCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte actualizado correctamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el reporte: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rol = _usuarioActual?.rol ?? 'aprendiz';
    final esSoporte = rol == 'soporte';

    if (_cargandoDatos) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reportar Estado')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.equipoExistente == null ? 'Nuevo Reporte de Equipo' : 'Actualizar Estado'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Salón:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _salonSeleccionadoId,
              items: _listaSalones.map((s) {
                return DropdownMenuItem(value: s.id, child: Text(s.nombre));
              }).toList(),
              onChanged: widget.salonId == null
                  ? (val) async {
                      if (val != null) {
                        setState(() => _salonSeleccionadoId = val);
                        await _cargarEquiposDelSalon(val);
                      }
                    }
                  : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Equipo a reportar:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            if (_listaEquipos.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECEC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDE3737)),
                ),
                child: const Text(
                  'Este salón no tiene computadores registrados. Debes crear el equipo primero desde el salón.',
                  style: TextStyle(color: Color(0xFFDE3737), fontWeight: FontWeight.bold),
                ),
              )
            else if (widget.equipoExistente != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.equipoExistente!.codigo,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F5796)),
                ),
              )
            else
              DropdownButtonFormField<String>(
                value: _equipoSeleccionadoId,
                items: _listaEquipos.map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text('${e.codigo} (${e.estado ? "Operativo" : "Con Falla"})'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    final eq = _listaEquipos.firstWhere((e) => e.id == val);
                    setState(() {
                      _equipoSeleccionadoId = val;
                      _estadoOperativo = eq.estado;
                      _observacionCtrl.text = eq.observacion ?? '';
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            const SizedBox(height: 20),

            const Text('Condición actual:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: _estadoOperativo ? const Color(0xFF2E9E49) : Colors.grey.shade300,
                        width: 2,
                      ),
                      backgroundColor: _estadoOperativo ? const Color(0xFFEAF8EE) : Colors.white,
                    ),
                    onPressed: esSoporte
                        ? () => setState(() => _estadoOperativo = true)
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Solo soporte técnico puede declarar un equipo operativo.')),
                            );
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, size: 12, color: _estadoOperativo ? const Color(0xFF2E9E49) : Colors.grey),
                        const SizedBox(width: 8),
                        Text('OPERATIVO', style: TextStyle(color: _estadoOperativo ? const Color(0xFF2E9E49) : Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: !_estadoOperativo ? const Color(0xFFDE3737) : Colors.grey.shade300,
                        width: 2,
                      ),
                      backgroundColor: !_estadoOperativo ? const Color(0xFFFDECEC) : Colors.white,
                    ),
                    onPressed: () => setState(() => _estadoOperativo = false),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle, size: 12, color: !_estadoOperativo ? const Color(0xFFDE3737) : Colors.grey),
                        const SizedBox(width: 8),
                        Text('CON FALLA', style: TextStyle(color: !_estadoOperativo ? const Color(0xFFDE3737) : Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Observación / Novedad:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            CampoTexto(
              etiqueta: 'Detalles del fallo o reparación...',
              controlador: _observacionCtrl,
              lineas: 3,
            ),
            const SizedBox(height: 32),

            _enviando
                ? const Center(child: CircularProgressIndicator())
                : BotonPrincipal(
                    texto: 'Actualizar Reporte',
                    color: const Color(0xFF0F5796),
                    alPresionar: _listaEquipos.isEmpty ? () {} : _guardarReporte,
                  ),
          ],
        ),
      ),
    );
  }
}