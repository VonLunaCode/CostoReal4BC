import 'package:flutter/material.dart';

class KitchyShadows {
  // Card sutil (productos, inputs)
  static List<BoxShadow> card = [
    const BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Botón primario (dorado)
  static List<BoxShadow> primaryButton = [
    const BoxShadow(
      color: Color(0x33C49A3C),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  // Bottom nav bar
  static List<BoxShadow> bottomNav = [
    const BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, -4),
    ),
  ];
}
