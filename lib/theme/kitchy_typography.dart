import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kitchy_colors.dart';

class KitchyTypography {
  // Logo / Brand
  static TextStyle logo = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: KitchyColors.primary,
    letterSpacing: 2.0,
  );

  // Títulos de pantalla
  static TextStyle heading1 = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: KitchyColors.textPrimary,
    height: 1.2,
  );

  // Subtítulo de sección (labels en mayúsculas)
  static TextStyle sectionLabel = GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: KitchyColors.textSecondary,
    letterSpacing: 1.4,
  );

  // Body normal
  static TextStyle body = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: KitchyColors.textPrimary,
    height: 1.5,
  );

  // Body bold (nombres de productos, cliente)
  static TextStyle bodyBold = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: KitchyColors.textPrimary,
  );

  // Precio
  static TextStyle price = GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: KitchyColors.textSecondary,
  );

  // Precio total
  static TextStyle priceTotal = GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: KitchyColors.textPrimary,
  );

  // Botón principal
  static TextStyle button = GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  // Botón secundario / outlined
  static TextStyle buttonSecondary = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: KitchyColors.textSecondary,
  );

  // Chip / tiempo seleccionado
  static TextStyle chipActive = GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle chipInactive = GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: KitchyColors.textSecondary,
  );

  // Número de cantidad
  static TextStyle quantity = GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: KitchyColors.textPrimary,
  );

  // Nombre del cliente (heading grande, multi-línea)
  static TextStyle clientHeading = GoogleFonts.playfairDisplay(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: KitchyColors.textPrimary,
    height: 1.15,
  );

  // Subtítulo de fecha/hora/tipo de entrega
  static TextStyle deliveryMeta = GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: KitchyColors.textSecondary,
  );

  // Nombre del producto en resumen
  static TextStyle productName = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: KitchyColors.textPrimary,
  );

  // Variante del producto (ej: "Extra mantequilla")
  static TextStyle productVariant = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: KitchyColors.textSecondary,
    height: 1.4,
  );

  // Precio del producto (alineado a la derecha)
  static TextStyle productPrice = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: KitchyColors.textPrimary,
  );

  // Fila subtotal / envío
  static TextStyle summaryRow = GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: KitchyColors.textSecondary,
  );

  // Fila Total (bold + dorado)
  static TextStyle totalRow = GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: KitchyColors.textPrimary,
  );

  static TextStyle totalAmount = GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: KitchyColors.primary,
  );

  // Texto de dirección / notas
  static TextStyle infoBody = GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: KitchyColors.textPrimary,
    height: 1.5,
  );

  // Label de paso del stepper
  static TextStyle stepLabel = GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: KitchyColors.textSecondary,
  );

  static TextStyle stepLabelActive = GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: KitchyColors.primary,
  );
}
