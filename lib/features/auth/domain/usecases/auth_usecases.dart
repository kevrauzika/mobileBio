import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

/// Casos de uso de autenticação.
class AuthUseCases {
  /// Cria os casos de uso com injeção de repositório.
  const AuthUseCases({required this.repository});

  /// Repositório de autenticação.
  final AuthRepository repository;

  /// Devolve usuário atual.
  AppUser? usuarioAtual() => repository.usuarioAtual;

  /// Observa alterações de sessão.
  Stream<AppUser?> observarSessao() => repository.observarSessao();

  /// Executa login.
  Future<void> entrar(String email, String senha) {
    return repository.entrarComEmail(email: email, senha: senha);
  }

  /// Executa cadastro.
  Future<void> cadastrar(String nome, String email, String senha) {
    return repository.cadastrarComEmail(nome: nome, email: email, senha: senha);
  }

  /// Login com Google.
  Future<void> entrarComGoogle() => repository.entrarComGoogle();

  /// Logout.
  Future<void> sair() => repository.sair();
}
