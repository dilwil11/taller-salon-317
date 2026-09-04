import 'package:flutter/material.dart';

class TarjetaContador extends StatelessWidget {
  final String valor;
  final String etiqueta;
  final Color colorBorde;
  final Color colorFondo;
  final Color colorTexto;

  const TarjetaContador({
    super.key,
    required this.valor,
    required this.etiqueta,
    required this.colorBorde,
    required this.colorFondo,
    required this.colorTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorBorde, width: 2),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorTexto,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorTexto,
            ),
          ),
        ],
      ),
    );
  }
}