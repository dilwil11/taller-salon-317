import 'dart:io';
import 'package:flutter/material.dart';

class SelectorImagen extends StatelessWidget {
  final File? archivoSeleccionado;
  final VoidCallback alPresionar;

  const SelectorImagen({
    super.key,
    required this.archivoSeleccionado,
    required this.alPresionar,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alPresionar,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
        ),
        child: archivoSeleccionado != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(archivoSeleccionado!, fit: BoxFit.cover),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 36, color: Color(0xFF0F5796)),
                  SizedBox(height: 8),
                  Text(
                    'Adjuntar foto o evidencia de la falla',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
      ),
    );
  }
}