import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ia/features/auth/domain/entities/app_user.dart';
import 'package:mobile_ia/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_ia/features/auth/domain/usecases/auth_usecases.dart';
import 'package:mobile_ia/features/auth/presentation/pages/login_page.dart';
import 'package:mobile_ia/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class _AuthRepositoryFake implements AuthRepository {
  @override
  Future<void> cadastrarComEmail({required String nome, required String email, required String senha}) async {}

  @override
  Future<void> entrarComEmail({required String email, required String senha}) async {}

  @override
  Future<void> entrarComGoogle() async {}

  @override
  Stream<AppUser?> observarSessao() => const Stream.empty();

  @override
  Future<void> sair() async {}

  @override
  AppUser? get usuarioAtual => null;
}

void main() {
  Future<void> pumpLogin(WidgetTester tester, AuthViewModel auth) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: auth,
          child: const LoginPage(),
        ),
      ),
    );
  }

  testWidgets('Tela de login renderiza em português', (tester) async {
    final auth = AuthViewModel(useCases: AuthUseCases(repository: _AuthRepositoryFake()));
    await pumpLogin(tester, auth);
    expect(find.text('Entrar no BioMapa'), findsOneWidget);
    expect(find.text('Entrar com Google'), findsOneWidget);
  });

  testWidgets('Tela alterna para cadastro e valida formulário', (tester) async {
    final auth = AuthViewModel(useCases: AuthUseCases(repository: _AuthRepositoryFake()));
    await pumpLogin(tester, auth);
    await tester.tap(find.text('Quero criar conta'));
    await tester.pumpAndSettle();
    expect(find.text('Crie sua conta no BioMapa'), findsOneWidget);
    await tester.tap(find.text('Cadastrar'));
    await tester.pump();
    expect(find.text('Informe um nome válido'), findsOneWidget);
    expect(find.text('Email inválido'), findsOneWidget);
    expect(find.text('A senha precisa ter ao menos 6 caracteres'), findsOneWidget);
  });
}
