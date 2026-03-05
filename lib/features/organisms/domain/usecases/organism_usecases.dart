import '../../../../core/domain/entities.dart';
import '../entities/organism.dart';
import '../repositories/organism_repository.dart';

/// Casos de uso do mapeamento biológico.
class OrganismUseCases {
  /// Cria os casos de uso.
  const OrganismUseCases({required this.repository});

  /// Repositório injetado.
  final OrganismRepository repository;

  /// Lista organismos com filtros dinâmicos.
  Future<List<Organism>> listar({
    CategoriaOrganismo? categoria,
    DateTime? de,
    DateTime? ate,
    String? usuarioId,
  }) {
    return repository.listar(categoria: categoria, de: de, ate: ate, usuarioId: usuarioId);
  }

  /// Registra novo organismo.
  Future<void> registrar(Organism organismo) => repository.registrar(organismo);

  /// Sugestões de classificação.
  Future<List<String>> sugerir(String termo, CategoriaOrganismo categoria) {
    return repository.sugerirClassificacao(termo: termo, categoria: categoria);
  }

  /// Sincroniza pendências locais.
  Future<void> sincronizarPendentes() => repository.sincronizarPendentes();

  /// Escuta novos registros em tempo real.
  Stream<Organism> observarNovosRegistros() => repository.observarNovosRegistros();
}
