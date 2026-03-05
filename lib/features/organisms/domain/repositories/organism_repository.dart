import '../../../../core/domain/entities.dart';
import '../entities/organism.dart';

/// Contrato de dados para organismo, social e notificações.
abstract interface class OrganismRepository {
  /// Lista registros por filtros.
  Future<List<Organism>> listar({
    CategoriaOrganismo? categoria,
    DateTime? de,
    DateTime? ate,
    String? usuarioId,
  });

  /// Cria novo registro.
  Future<void> registrar(Organism organismo);

  /// Sugere classificação automática com base em nome e categoria.
  Future<List<String>> sugerirClassificacao({
    required String termo,
    required CategoriaOrganismo categoria,
  });

  /// Salva localmente quando offline.
  Future<void> salvarPendente(Organism organismo);

  /// Sincroniza pendências locais com servidor.
  Future<void> sincronizarPendentes();

  /// Fluxo realtime de novos organismos.
  Stream<Organism> observarNovosRegistros();
}
