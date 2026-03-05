import '../../features/organisms/domain/repositories/organism_repository.dart';

/// Serviço de sincronização automática de dados offline.
class SyncService {
  /// Cria serviço de sincronização.
  const SyncService({required this.repository});

  /// Repositório de organismos.
  final OrganismRepository repository;

  /// Dispara sincronização.
  Future<void> sincronizar() => repository.sincronizarPendentes();
}
