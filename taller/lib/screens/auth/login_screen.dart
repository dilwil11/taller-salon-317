import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/boton_principal.dart';
import '../home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final AuthService _authService = AuthService();
  bool _cargando = false;

  Future<void> _login() async {
    setState(() => _cargando = true);
    try {
      await _authService.iniciarSesion(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de autenticación: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.devices, size: 64, color: Color(0xFF0F5796)),
              const SizedBox(height: 16),
              const Text('Control de Equipos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              CampoTexto(etiqueta: 'Correo Electrónico', controlador: _emailCtrl),
              const SizedBox(height: 16),
              CampoTexto(etiqueta: 'Contraseña', controlador: _passwordCtrl, esContrasena: true),
              const SizedBox(height: 24),
              _cargando
                  ? const CircularProgressIndicator()
                  : BotonPrincipal(texto: 'Iniciar Sesión', alPresionar: _login),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                child: const Text('¿No tienes cuenta? Regístrate aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}