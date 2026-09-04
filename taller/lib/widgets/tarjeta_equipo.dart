import 'package:flutter/material.dart';

class TarjetaEquipo extends StatelessWidget {
  final String codigo;
  final bool estado; 
  final String? observacion;
  final VoidCallback alTocar;

  const TarjetaEquipo({
    super.key,
    required this.codigo,
    required this.estado,
    this.observacion,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    final colorEstado = estado ? const Color(0xFF2E9E49) : const Color(0xFFDE3737);
    final textoEstado = estado ? 'BIEN' : 'MAL';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorEstado.withOpacity(0.4), width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: colorEstado.withOpacity(0.2),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colorEstado,
              shape: BoxShape.circle,
            ),
          ),
        ),
        title: Text(
          codigo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          observacion ?? (estado ? 'Core i7 • 16GB • OK' : 'Sin reporte específico'),
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorEstado,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            textoEstado,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        onTap: alTocar,
      ),
    );
  }
}