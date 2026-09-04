import 'package:flutter/material.dart';
import '../services/salones_service.dart';
import '../services/usuarios_service.dart';
import '../models/salon_model.dart';
import '../models/usuario_model.dart';
import '../widgets/tarjeta_salon.dart';
import '../widgets/boton_principal.dart';
import 'salon_form.dart';
import 'equipos_screen.dart';

class SalonesScreen extends StatefulWidget {
  const SalonesScreen({super.key});

  @override
  State<SalonesScreen> createState() => _SalonesScreenState();
}

class _SalonesScreenState extends State<SalonesScreen> {
  final SalonesService _salonesService = SalonesService();
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

  @override
  Widget build(BuildContext context) {
    final esSoporte = _usuarioActual?.rol == 'soporte';

    return Scaffold(
      appBar: AppBar(title: const Text('Salones de Formación')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<SalonModel>>(
                stream: _salonesService.obtenerSalones(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final salones = snapshot.data ?? [];
                  if (salones.isEmpty) {
                    return const Center(child: Text('No hay salones registrados.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: salones.length,
                    itemBuilder: (context, index) {
                      final salon = salones[index];
                      return TarjetaSalon(
                        nombre: salon.nombre,
                        alTocar: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EquiposScreen(
                                salonId: salon.id,
                                salonNombre: salon.nombre,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            if (esSoporte)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BotonPrincipal(
                  texto: '+ Registrar Nuevo Salón',
                  alPresionar: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SalonFormScreen()));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}