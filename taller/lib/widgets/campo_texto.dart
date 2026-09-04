import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  final String etiqueta;
  final TextEditingController controlador;
  final int lineas;
  final TextInputType tipoTeclado;
  final bool esContrasena;

  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.lineas = 1,
    this.tipoTeclado = TextInputType.text,
    this.esContrasena = false,
  });

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  late bool _ocultarTexto;

  @override
  void initState() {
    super.initState();
    _ocultarTexto = widget.esContrasena;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      maxLines: widget.lineas,
      obscureText: _ocultarTexto,
      keyboardType: widget.tipoTeclado,
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0F5796), width: 2),
        ),
        suffixIcon: widget.esContrasena
            ? IconButton(
                icon: Icon(
                  _ocultarTexto ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _ocultarTexto = !_ocultarTexto;
                  });
                },
              )
            : null,
      ),
    );
  }
}