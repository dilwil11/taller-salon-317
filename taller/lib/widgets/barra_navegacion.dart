import 'package:flutter/material.dart';

class BarraNavegacion extends StatelessWidget {
  final int indiceActual;
  final Function(int) alCambiar;

  const BarraNavegacion({
    super.key,
    required this.indiceActual,
    required this.alCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceActual,
      selectedItemColor: const Color(0xFF2E9E49),
      unselectedItemColor: Colors.grey,
      backgroundColor: const Color(0xFF082647),
      onTap: alCambiar,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 22), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.computer, size: 22), label: 'Equipos'),
        BottomNavigationBarItem(icon: Icon(Icons.meeting_room, size: 22), label: 'Salones'),
      ],
    );
  }
}