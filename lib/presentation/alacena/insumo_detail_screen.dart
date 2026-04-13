import 'package:flutter/material.dart';

class InsumoDetailScreen extends StatelessWidget {
  final String insumoId;
  const InsumoDetailScreen({super.key, required this.insumoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Insumo')),
      body: Center(child: Text('Detalles para ID: $insumoId')),
    );
  }
}
