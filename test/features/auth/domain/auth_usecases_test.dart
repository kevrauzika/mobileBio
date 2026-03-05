import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ia/features/auth/domain/entities/app_user.dart';
import 'package:mobile_ia/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile_ia/features/auth/domain/usecases/auth_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _AuthRepositoryMock extends Mock implements AuthRepository {}

void main() {
  late _AuthRepositoryMock repository;
  late AuthUseCases useCases;

  setUp(() {
    repository = _AuthRepositoryMock();
    useCases = AuthUseCases(repository: repository);
  });

  test('encaminha login por email e senha', () async {
    when(() => repository.entrarComEmail(email: any(named: 'email'), senha: any(named: 'senha')))
        .thenAnswer((_) async {});
    await useCases.entrar('teste@bio.com', '123456');
    verify(() => repository.entrarComEmail(email: 'teste@bio.com', senha: '123456')).called(1);
  });

  test('devolve usuário atual', () {
    const usuario = AppUser(
      id: '1',
      nome: 'Ana',
      email: 'ana@bio.com',
      totalRegistros: 4,
      especiesDiferentes: 3,
      areasExploradas: 2,
    );
    when(() => repository.usuarioAtual).thenReturn(usuario);
    expect(useCases.usuarioAtual(), usuario);
  });

  test('encaminha cadastro, google e logout', () async {
    when(
      () => repository.cadastrarComEmail(
        nome: any(named: 'nome'),
        email: any(named: 'email'),
        senha: any(named: 'senha'),
      ),
    ).thenAnswer((_) async {});
    when(() => repository.entrarComGoogle()).thenAnswer((_) async {});
    when(() => repository.sair()).thenAnswer((_) async {});

    await useCases.cadastrar('Ana', 'ana@bio.com', '123456');
    await useCases.entrarComGoogle();
    await useCases.sair();

    verify(() => repository.cadastrarComEmail(nome: 'Ana', email: 'ana@bio.com', senha: '123456')).called(1);
    verify(() => repository.entrarComGoogle()).called(1);
    verify(() => repository.sair()).called(1);
  });

  test('observa stream de sessão', () async {
    const usuario = AppUser(
      id: '2',
      nome: 'Bia',
      email: 'bia@bio.com',
      totalRegistros: 1,
      especiesDiferentes: 1,
      areasExploradas: 1,
    );
    when(() => repository.observarSessao()).thenAnswer((_) => Stream.value(usuario));
    await expectLater(useCases.observarSessao(), emits(usuario));
  });
}
