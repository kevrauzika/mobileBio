import '../../domain/entities/app_user.dart';

/// Conversor entre payload Supabase e entidade de domínio.
class AppUserModel extends AppUser {
  /// Cria modelo de usuário.
  const AppUserModel({
    required super.id,
    required super.nome,
    required super.email,
    required super.totalRegistros,
    required super.especiesDiferentes,
    required super.areasExploradas,
  });

  /// Constrói a partir de mapa retornado do Supabase.
  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      id: map['id']?.toString() ?? '',
      nome: map['nome']?.toString() ?? 'Observador',
      email: map['email']?.toString() ?? '',
      totalRegistros: (map['total_registros'] as num?)?.toInt() ?? 0,
      especiesDiferentes: (map['especies_diferentes'] as num?)?.toInt() ?? 0,
      areasExploradas: (map['areas_exploradas'] as num?)?.toInt() ?? 0,
    );
  }
}
