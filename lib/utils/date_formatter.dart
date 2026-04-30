import 'package:intl/intl.dart';

class KitchyDateFormatter {
  static String formatDeliveryDate(DateTime date) {
    final now = DateTime.now();
    final localDate = date.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final targetDate = DateTime(localDate.year, localDate.month, localDate.day);

    final timeStr = DateFormat.jm().format(localDate); // Ej: 3:00 PM

    if (targetDate == today) {
      return 'Hoy, $timeStr';
    } else if (targetDate == tomorrow) {
      return 'Mañana, $timeStr';
    } else if (targetDate.isBefore(today.add(const Duration(days: 7)))) {
      // Si es esta semana, mostrar el nombre del día
      final dayName = DateFormat('EEEE', 'es_ES').format(localDate);
      return '${dayName[0].toUpperCase()}${dayName.substring(1)}, $timeStr';
    } else {
      // Fecha completa para más adelante
      return '${DateFormat('d MMM').format(localDate)}, $timeStr';
    }
  }
}
