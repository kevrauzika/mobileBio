import '../entities/app_user.dart';

/// Contrato da camada de autenticação.
abstract interface class AuthRepository {
  /// Usuário atual persistido na sessão.
  AppUser? get usuarioAtual;

  /// Fluxo de mudanças de autenticação.
  Stream<AppUser?> observarSessao();

  /// Login com email e senha.
  Future<void> entrarComEmail({required String email, required String senha});

  /// Cadastro com email e senha.
  Future<void> cadastrarComEmail({
    required String nome,
    required String email,
    required String senha,
  });

  /// Login com conta Google.
  Future<void> entrarComGoogle();

  /// Finaliza sessão atual.
  Future<void> sair();
}
