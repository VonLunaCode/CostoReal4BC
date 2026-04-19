import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/auth_provider.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/register_screen.dart';

import '../presentation/alacena/alacena_screen.dart';
import '../presentation/alacena/insumo_form_screen.dart';
import '../presentation/alacena/insumo_detail_screen.dart';
import '../presentation/recetas/recetas_list_screen.dart';
import '../presentation/recetas/receta_detail_screen.dart';
import '../presentation/recetas/receta_form_screen.dart';
import '../data/api_generated/openapi.models.swagger.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'alacena',
            builder: (context, state) => const AlacenaScreen(),
            routes: [
              GoRoute(
                path: 'crear',
                builder: (context, state) => const InsumoFormScreen(),
              ),
              GoRoute(
                path: 'editar',
                builder: (context, state) {
                  final insumo = state.extra as InsumoResponse?;
                  return InsumoFormScreen(insumoExistente: insumo);
                },
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return InsumoDetailScreen(insumoId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'recetas',
            builder: (context, state) => const RecetasListScreen(),
            routes: [
              GoRoute(
                path: 'crear',
                builder: (context, state) => const RecetaFormScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return RecetaDetailScreen(id: id);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
});
