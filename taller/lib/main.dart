import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase.dart';
import 'config/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.inicializar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'Gestión Salón 317',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: session != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}