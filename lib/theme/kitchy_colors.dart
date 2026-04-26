import 'package:flutter/material.dart';

class KitchyColors {
  // Fondos
  static const Color background     = Color(0xFFF5F0E8); // crema cálido principal
  static const Color surface        = Color(0xFFFFFFFF); // blanco para cards/inputs
  static const Color surfaceWarm    = Color(0xFFFAF6EF); // crema más claro para secciones

  // Primario (dorado/ámbar)
  static const Color primary        = Color(0xFFC49A3C); // dorado — logo, botones activos, chips seleccionados
  static const Color primaryLight   = Color(0xFFE8C96B); // dorado claro — hover/pressed
  static const Color primaryDark    = Color(0xFF9A7520); // dorado oscuro — texto sobre primario

  // Texto
  static const Color textPrimary    = Color(0xFF2C2C2C); // casi negro — títulos y body
  static const Color textSecondary  = Color(0xFF8A8A8A); // gris medio — subtítulos, hints
  static const Color textDisabled   = Color(0xFFBCBCBC); // gris claro — placeholder

  // UI / Bordes
  static const Color border         = Color(0xFFE0D9CC); // borde suave sobre crema
  static const Color divider        = Color(0xFFEDE8DE); // separadores internos
  static const Color chipUnselected = Color(0xFFEDE8DE); // fondo chips no activos

  // Acento / Estado
  static const Color success        = Color(0xFF4CAF50); // confirmar pedido (ícono check)
  static const Color iconMuted      = Color(0xFFBBAA88); // íconos secundarios nav bar

  // Bottom Nav
  static const Color navBackground  = Color(0xFF2C2418); // marrón oscuro — barra inferior
  static const Color navActive      = Color(0xFFC49A3C); // dorado — ítem activo nav
  static const Color navInactive    = Color(0xFF8A7A5A); // dorado apagado — ítem inactivo

  // Estado del pedido — pasos
  static const Color stepActive     = Color(0xFFC49A3C); // dorado — paso actual
  static const Color stepCompleted  = Color(0xFF4CAF50); // verde suave — paso completado (check)
  static const Color stepInactive   = Color(0xFFE0D9CC); // gris crema — pasos futuros

  // WhatsApp button
  static const Color whatsapp       = Color(0xFF25D366); // verde WhatsApp
  static const Color whatsappText   = Color(0xFFFFFFFF); // texto blanco sobre WhatsApp

  // Totales
  static const Color totalLabel     = Color(0xFF2C2C2C); // "Total" en bold
  static const Color totalAmount    = Color(0xFFC49A3C); // monto total en dorado

  // Info cards (dirección / notas) — fondo levemente diferente
  static const Color infoCardBg     = Color(0xFFFAF6EF); // crema más suave
}
