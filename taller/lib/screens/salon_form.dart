import 'package:flutter/material.dart';
import '../services/salones_service.dart';
import '../widgets/campo_texto.dart';
import '../widgets/boton_principal.dart';

class SalonFormScreen extends StatefulWidget {
  const SalonFormScreen({super.key});

  @override
  State<SalonFormScreen> createState() => _SalonFormScreenState();
}

class _SalonFormScreenState extends State<SalonFormScreen> {
  final TextEditingController _nombreCtrl = TextEditingController();
  final SalonesService _salonesService = SalonesService();
  bool _guardando = false;

  Future<void> _guardarSalon() async {
    final nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe el nombre del salón')),
      );
      return;
    }

    setState(() => _guardando = true);
    try {
      await _salonesService.crearSalon(nombre);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Salón')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CampoTexto(
              etiqueta: 'Nombre del Salón (Ej: Salón 317)',
              controlador: _nombreCtrl,
            ),
            const Spacer(),
            _guardando
                ? const CircularProgressIndicator()
                : BotonPrincipal(
                    texto: 'Guardar Salón',
                    alPresionar: _guardarSalon,
                  ),
          ],
        ),
      ),
    );
  }
}