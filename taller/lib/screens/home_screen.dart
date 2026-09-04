import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/equipos_service.dart';
import '../services/salones_service.dart';
import '../services/usuarios_service.dart';
import '../models/equipo_model.dart';
import '../models/usuario_model.dart';
import '../widgets/tarjeta_contador.dart';
import '../widgets/boton_principal.dart';
import '../widgets/barra_navegacion.dart';
import 'salones_screen.dart';
import 'salon_form.dart';
import 'reporte_form.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceActual = 0;
  final EquiposService _equiposService = EquiposService();
  final SalonesService _salonesService = SalonesService();
  final UsuariosService _usuariosService = UsuariosService();
  
  UsuarioModel? _usuarioActual;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final perfil = await _usuariosService.obtenerUsuarioActual();
    if (mounted) setState(() => _usuarioActual = perfil);
  }

  Future<void> _verificarYCrearReporte() async {
    if (_usuarioActual?.rol == 'aprendiz') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Acceso restringido: Los aprendices solo tienen permiso de lectura.')),
      );
      return;
    }

    final haySalones = await _salonesService.haySalones();
    if (!mounted) return;

    if (!haySalones) {
      if (_usuarioActual?.rol == 'soporte') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Sin Salones Registrados'),
            content: const Text('Primero debes registrar un salón antes de reportar un equipo.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SalonFormScreen()));
                },
                child: const Text('Registrar Salón'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay salones disponibles. Contacta a Soporte Técnico.')),
        );
      }
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReporteFormScreen()));
    }
  }

  Future<void> _cerrarSesion() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rol = _usuarioActual?.rol ?? 'aprendiz';
    final puedeReportar = rol == 'instructor' || rol == 'soporte';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Control de Equipos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (_usuarioActual != null)
              Text(
                '${_usuarioActual!.nombre} (${rol.toUpperCase()})',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Cerrar Sesión',
            icon: const Icon(Icons.logout, color: Color(0xFFDE3737)),
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: StreamBuilder<List<EquipoModel>>(
        stream: _equiposService.streamTodosLosEquipos(),
        builder: (context, snapshot) {
          int operativos = 0;
          int conFalla = 0;

          if (snapshot.hasData) {
            final lista = snapshot.data!;
            operativos = lista.where((e) => e.estado).length;
            conFalla = lista.where((e) => !e.estado).length;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TarjetaContador(
                              valor: operativos.toString().padLeft(2, '0'),
                              etiqueta: 'PCs Operativos',
                              colorBorde: const Color(0xFF2E9E49),
                              colorFondo: const Color(0xFFEAF8EE),
                              colorTexto: const Color(0xFF2E9E49),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TarjetaContador(
                              valor: conFalla.toString().padLeft(2, '0'),
                              etiqueta: 'Con Falla',
                              colorBorde: const Color(0xFFDE3737),
                              colorFondo: const Color(0xFFFDECEC),
                              colorTexto: const Color(0xFFDE3737),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2E9E49), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      const SizedBox(height: 18),
                      if (puedeReportar) ...[
                        BotonPrincipal(
                          texto: '+ Nuevo Reporte',
                          color: const Color(0xFF0F5796),
                          alPresionar: _verificarYCrearReporte,
                        ),
                        const SizedBox(height: 12),
                      ],
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0F5796), width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SalonesScreen()));
                          },
                          child: const Text('Ver Salones y Equipos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F5796))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BarraNavegacion(
        indiceActual: _indiceActual,
        alCambiar: (index) {
          setState(() => _indiceActual = index);
          if (index == 1 || index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SalonesScreen()));
          }
        },
      ),
    );
  }
}