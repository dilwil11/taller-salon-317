import 'package:flutter/material.dart';
import '../services/equipos_service.dart';
import '../services/usuarios_service.dart';
import '../models/equipo_model.dart';
import '../models/usuario_model.dart';
import '../widgets/tarjeta_equipo.dart';
import '../widgets/barra_navegacion.dart';
import 'reporte_form.dart';

class EquiposScreen extends StatefulWidget {
  final String salonId;
  final String salonNombre;

  const EquiposScreen({
    super.key,
    required this.salonId,
    required this.salonNombre,
  });

  @override
  State<EquiposScreen> createState() => _EquiposScreenState();
}

class _EquiposScreenState extends State<EquiposScreen> {
  final EquiposService _equiposService = EquiposService();
  final UsuariosService _usuariosService = UsuariosService();
  UsuarioModel? _usuarioActual;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final u = await _usuariosService.obtenerUsuarioActual();
    if (mounted) setState(() => _usuarioActual = u);
  }

  Future<void> _crearEquipoRapido(BuildContext context) async {
    final TextEditingController codigoCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Equipo'),
        content: TextField(
          controller: codigoCtrl,
          decoration: const InputDecoration(hintText: 'Ej: PC-317-01'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (codigoCtrl.text.isNotEmpty) {
                await _equiposService.crearEquipo(
                  codigo: codigoCtrl.text.trim(),
                  salonId: widget.salonId,
                );
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rol = _usuarioActual?.rol ?? 'aprendiz';
    final esSoporte = rol == 'soporte';
    final puedeModificar = rol == 'instructor' || esSoporte;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.salonNombre} (30 PCs)', style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Solo Soporte puede agregar nuevos PCs
          if (esSoporte)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E9E49),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nuevo'),
                onPressed: () => _crearEquipoRapido(context),
              ),
            ),
        ],
      ),
      body: StreamBuilder<List<EquipoModel>>(
        stream: _equiposService.streamEquiposPorSalon(widget.salonId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final equipos = snapshot.data ?? [];

          if (equipos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No hay equipos en este salón.'),
                  if (esSoporte) ...[
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _crearEquipoRapido(context),
                      child: const Text('Registrar Primer PC'),
                    ),
                  ],
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: equipos.length,
            itemBuilder: (context, index) {
              final equipo = equipos[index];
              return TarjetaEquipo(
                codigo: equipo.codigo,
                estado: equipo.estado,
                observacion: equipo.observacion,
                alTocar: () {
                  if (puedeModificar) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReporteFormScreen(
                          equipoExistente: equipo,
                          salonId: widget.salonId,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Los aprendices solo pueden visualizar el estado.')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BarraNavegacion(
        indiceActual: 1,
        alCambiar: (index) {
          if (index == 0) Navigator.popUntil(context, (route) => route.isFirst);
          if (index == 2) Navigator.pop(context);
        },
      ),
    );
  }
}