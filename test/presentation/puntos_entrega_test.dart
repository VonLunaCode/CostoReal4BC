import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:costoreal/presentation/puntos_entrega/puntos_entrega_screen.dart';
import 'package:costoreal/presentation/puntos_entrega/puntos_entrega_providers.dart';
import 'package:costoreal/data/api_generated/openapi.models.swagger.dart';

class MockPuntoEntregaNotifier extends StateNotifier<AsyncValue<void>> with Mock implements PuntoEntregaNotifier {
  MockPuntoEntregaNotifier() : super(const AsyncValue.data(null));
}

void main() {
  testWidgets('PuntosEntregaScreen shows empty state when no points', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          puntosEntregaProvider.overrideWith((ref) => Future.value([])),
        ],
        child: const MaterialApp(
          home: PuntosEntregaScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    expect(find.textContaining('No tienes puntos guardados'), findsOneWidget);
    expect(find.textContaining('Agrega tus lugares frecuentes'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('PuntosEntregaScreen shows list when points available', (tester) async {
    final now = DateTime.now();
    final mockPoints = [
      PuntoEntregaRead(
        id: '1',
        usuarioId: 'u1',
        nombre: 'Casa',
        direccion: 'Calle Falsa 123',
        fechaCreacion: now,
        fechaModificacion: now,
      ),
      PuntoEntregaRead(
        id: '2',
        usuarioId: 'u1',
        nombre: 'Oficina',
        direccion: 'Av. Siempre Viva 742',
        fechaCreacion: now,
        fechaModificacion: now,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          puntosEntregaProvider.overrideWith((ref) => Future.value(mockPoints)),
        ],
        child: const MaterialApp(
          home: PuntosEntregaScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Esperar a que el Future resuelva

    expect(find.text('Casa'), findsOneWidget);
    expect(find.text('Calle Falsa 123'), findsOneWidget);
    expect(find.text('Oficina'), findsOneWidget);
    expect(find.text('Av. Siempre Viva 742'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsNWidgets(2));
    expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
  });
}
