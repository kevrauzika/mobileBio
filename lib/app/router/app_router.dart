import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';

/// Configuração central de rotas da aplicação.
class AppRouter {
  /// Cria o roteador com base no estado de autenticação.
  AppRouter({required this.authViewModel});

  final AuthViewModel authViewModel;

  /// Instância configurada do GoRouter.
  late final GoRouter router = GoRouter(
    initialLocation: '/entrar',
    refreshListenable: authViewModel,
    redirect: (context, state) {
      final autenticado = authViewModel.usuarioAtual != null;
      final naTelaAuth = state.fullPath == '/entrar';
      if (!autenticado && !naTelaAuth) {
        return '/entrar';
      }
      if (autenticado && naTelaAuth) {
        return '/inicio';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/entrar',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/inicio',
        builder: (context, state) => const HomeShellPage(),
      ),
    ],
  );
}
