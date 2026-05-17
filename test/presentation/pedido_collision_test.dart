import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:costoreal/presentation/pedidos/nuevo_pedido_screen.dart';
import 'package:costoreal/data/api_provider.dart';
import 'package:costoreal/data/api_generated/openapi.swagger.dart';
import 'package:chopper/chopper.dart' as chopper;
import 'package:http/http.dart' as http;
import 'package:costoreal/presentation/recetas/recetas_providers.dart';
import 'package:costoreal/presentation/puntos_entrega/puntos_entrega_providers.dart';

class MockOpenapi extends Mock implements Openapi {}

void main() {
  late MockOpenapi mockApi;

  setUp(() {
    mockApi = MockOpenapi();
    // Registrar el fallback para UUID y DateTime si es necesario para mocktail
    registerFallbackValue(DateTime.now());
  });

  testWidgets('NuevoPedidoScreen muestra diálogo de advertencia si hay colisión', (tester) async {
    // 1. Mock de la respuesta con colisión
    final response = chopper.Response<ColisionHoraResponse>(
      http.Response('', 200),
      const ColisionHoraResponse(
        hayColision: true,
        cantidad: 2,
        horaInicio: '14:00',
        horaFin: '15:00',
      ),
    );

    when(() => mockApi.apiV1PedidosCheckColisionGet(
      fechaEntrega: any(named: 'fechaEntrega'),
      excludeId: any(named: 'excludeId'),
    )).thenAnswer((_) async => response);

    // Mocks necesarios para que la pantalla no explote al cargar otros providers
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiProvider.overrideWithValue(mockApi),
          recetasProvider.overrideWith((ref) => Future.value([])),
          puntosEntregaProvider.overrideWith((ref) => Future.value([])),
        ],
        child: const MaterialApp(
          home: NuevoPedidoScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 2. Llenar campos mínimos
    await tester.enterText(find.byType(TextFormField).first, 'Cliente de Prueba');
    
    // 3. Seleccionar la hora de colisión (14:00)
    // Buscamos el chip que dice '14:00'
    await tester.tap(find.text('14:00'));
    await tester.pump();

    // 4. Intentar guardar
    await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar Pedido'));
    
    // Necesitamos múltiples pumps para que las microtasks de async se completen
    await tester.pump(); // Inicia el check
    await tester.pump(); // Debería procesar la respuesta y mostrar el diálogo

    // 5. Verificar que el diálogo aparece
    expect(find.text('¡Cuidado!'), findsOneWidget);
    expect(find.textContaining('Ya tenés 2 pedido(s) agendados'), findsOneWidget);
    expect(find.text('Sí, guardar'), findsOneWidget);
  });
}
