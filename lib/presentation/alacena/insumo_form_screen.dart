import 'package:flutter/material.dart';

class InsumoFormScreen extends StatelessWidget {
  final String modo;
  const InsumoFormScreen({super.key, required this.modo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario de Insumo ($modo)')),
      body: const Center(child: Text('Placeholder Forma de Insumo')),
    );
  }
}
