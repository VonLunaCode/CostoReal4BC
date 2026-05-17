import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:costoreal/presentation/screens/login_screen.dart';
import 'package:costoreal/presentation/screens/register_screen.dart';
import 'package:costoreal/presentation/auth_provider.dart';

class _FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => AuthState(status: AuthStatus.unauthenticated);
}

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _FakeAuthNotifier()),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  group('LoginScreen', () {
    testWidgets('test_login_empty_email_shows_error', (tester) async {
      await tester.pumpWidget(_wrap(const LoginScreen()));
      await tester.tap(find.text('Iniciar Sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Correo o contraseña incorrectos'), findsOneWidget);
    });

    testWidgets('test_login_invalid_email_shows_error', (tester) async {
      await tester.pumpWidget(_wrap(const LoginScreen()));
      await tester.enterText(find.byType(TextField).first, 'notanemail');
      await tester.tap(find.text('Iniciar Sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Correo o contraseña incorrectos'), findsOneWidget);
    });
  });

  group('RegisterScreen', () {
    testWidgets('test_login_short_password_shows_error', (tester) async {
      await tester.pumpWidget(_wrap(const RegisterScreen()));

      await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.text('Crear Cuenta'));
      await tester.pumpAndSettle();

      expect(find.text('Mínimo 6 caracteres'), findsOneWidget);
    });

    testWidgets('test_register_passwords_dont_match', (tester) async {
      await tester.pumpWidget(_wrap(const RegisterScreen()));

      await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'different');
      await tester.tap(find.text('Crear Cuenta'));
      await tester.pumpAndSettle();

      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });
  });
}
