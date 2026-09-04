import 'package:flutter/material.dart';

class TarjetaSalon extends StatelessWidget {
  final String nombre;
  final VoidCallback alTocar;

  const TarjetaSalon({
    super.key,
    required this.nombre,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFEAF8EE),
          child: Icon(Icons.meeting_room, color: Color(0xFF2E9E49)),
        ),
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: alTocar,
      ),
    );
  }
}