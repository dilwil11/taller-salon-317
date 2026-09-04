import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/boton_principal.dart';
import '../home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final AuthService _authService = AuthService();

  String _rolSeleccionado = 'aprendiz';
  File? _avatarFile;
  bool _cargando = false;

  Future<void> _elegirAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));
    }
  }

  Future<void> _registro() async {
    final nombre = _nombreCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos obligatorios.')),
      );
      return;
    }

    setState(() => _cargando = true);
    try {
      await _authService.registrar(
        nombre: nombre,
        email: email,
        password: password,
        rol: _rolSeleccionado,
        imagenAvatar: _avatarFile, 
      );

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _avatarFile != null ? FileImage(_avatarFile!) : null,
                    child: _avatarFile == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _elegirAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F5796),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Foto de perfil (Opcional)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            CampoTexto(etiqueta: 'Nombre Completo', controlador: _nombreCtrl),
            const SizedBox(height: 16),
            CampoTexto(
              etiqueta: 'Correo Institucional',
              controlador: _emailCtrl,
              tipoTeclado: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CampoTexto(
              etiqueta: 'Contraseña',
              controlador: _passwordCtrl,
              esContrasena: true,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _rolSeleccionado,
              decoration: InputDecoration(
                labelText: 'Rol de usuario',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              items: const [
                DropdownMenuItem(value: 'aprendiz', child: Text('Aprendiz')),
                DropdownMenuItem(value: 'instructor', child: Text('Instructor')),
                DropdownMenuItem(value: 'soporte', child: Text('Soporte Técnico')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _rolSeleccionado = val);
              },
            ),
            const SizedBox(height: 28),

            _cargando
                ? const CircularProgressIndicator()
                : BotonPrincipal(
                    texto: 'Registrarse',
                    color: const Color(0xFF0F5796),
                    alPresionar: _registro,
                  ),
          ],
        ),
      ),
    );
  }
}