/// Usuário autenticado no sistema.
class AppUser {
  /// Cria usuário com dados de perfil.
  const AppUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.totalRegistros,
    required this.especiesDiferentes,
    required this.areasExploradas,
  });

  final String id;
  final String nome;
  final String email;
  final int totalRegistros;
  final int especiesDiferentes;
  final int areasExploradas;
}
