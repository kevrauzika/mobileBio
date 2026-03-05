import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/services/notification_service.dart';
import '../core/services/sync_service.dart';
import '../features/auth/data/auth_repository_impl.dart';
import '../features/auth/domain/usecases/auth_usecases.dart';
import '../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../features/organisms/data/organism_repository_impl.dart';
import '../features/organisms/domain/usecases/organism_usecases.dart';
import '../features/organisms/presentation/viewmodels/organism_view_model.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Aplicativo principal com injeção de dependências e roteamento.
class App extends StatelessWidget {
  /// Cria a aplicação.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl();
    final organismRepository = OrganismRepositoryImpl();
    return MultiProvider(
      providers: [
        Provider(create: (_) => NotificationService()),
        Provider(create: (_) => SyncService(repository: organismRepository)),
        Provider(create: (_) => AuthUseCases(repository: authRepository)),
        Provider(create: (_) => OrganismUseCases(repository: organismRepository)),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            useCases: context.read<AuthUseCases>(),
          )..iniciarSessao(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrganismViewModel(
            useCases: context.read<OrganismUseCases>(),
            notificationService: context.read<NotificationService>(),
            syncService: context.read<SyncService>(),
          )..carregar(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter(authViewModel: context.read<AuthViewModel>()).router;
          return MaterialApp.router(
            title: 'BioMapa',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: AppTheme.claro,
            darkTheme: AppTheme.escuro,
            routerConfig: router,
            supportedLocales: const [Locale('pt', 'BR')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('pt', 'BR'),
          );
        },
      ),
    );
  }
}
