import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ia/features/auth/domain/entities/app_user.dart';
import 'package:mobile_ia/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_ia/features/auth/domain/usecases/auth_usecases.dart';
import 'package:mobile_ia/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _AuthRepositoryMock extends Mock implements AuthRepository {}

void main() {
  late _AuthRepositoryMock repository;
  late AuthViewModel viewModel;

  setUp(() {
    repository = _AuthRepositoryMock();
    when(() => repository.usuarioAtual).thenReturn(null);
    when(() => repository.observarSessao()).thenAnswer((_) => const Stream.empty());
    when(() => repository.entrarComEmail(email: any(named: 'email'), senha: any(named: 'senha')))
        .thenAnswer((_) async {});
    when(
      () => repository.cadastrarComEmail(
        nome: any(named: 'nome'),
        email: any(named: 'email'),
        senha: any(named: 'senha'),
      ),
    ).thenAnswer((_) async {});
    when(() => repository.entrarComGoogle()).thenAnswer((_) async {});
    when(() => repository.sair()).thenAnswer((_) async {});
    viewModel = AuthViewModel(useCases: AuthUseCases(repository: repository));
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('inicia sessão com usuário atual do repositório', () async {
    const usuario = AppUser(
      id: '1',
      nome: 'Lia',
      email: 'lia@bio.com',
      totalRegistros: 0,
      especiesDiferentes: 0,
      areasExploradas: 0,
    );
    when(() => repository.usuarioAtual).thenReturn(usuario);
    viewModel.iniciarSessao();
    expect(viewModel.usuarioAtual?.nome, 'Lia');
  });

  test('executa login, cadastro, google e logout sem erro', () async {
    await viewModel.entrarComEmail('a@b.com', '123456');
    await viewModel.cadastrar('Ana', 'a@b.com', '123456');
    await viewModel.entrarComGoogle();
    await viewModel.sair();
    expect(viewModel.erro, isNull);
    verify(() => repository.entrarComEmail(email: 'a@b.com', senha: '123456')).called(1);
    verify(() => repository.cadastrarComEmail(nome: 'Ana', email: 'a@b.com', senha: '123456')).called(1);
    verify(() => repository.entrarComGoogle()).called(1);
    verify(() => repository.sair()).called(1);
  });

  test('exibe erro em falha de autenticação', () async {
    when(() => repository.entrarComGoogle()).thenThrow(Exception('falha'));
    await viewModel.entrarComGoogle();
    expect(viewModel.erro, contains('Não foi possível'));
  });
}
