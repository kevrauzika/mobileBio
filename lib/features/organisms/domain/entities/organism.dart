import '../../../../core/domain/entities.dart';

/// Registro biológico coletado no campo.
class Organism {
  /// Cria um organismo com dados gerais e taxonomia.
  const Organism({
    required this.id,
    required this.usuarioId,
    required this.nomePopular,
    required this.categoria,
    required this.localizacao,
    required this.fotos,
    required this.criadoEm,
    this.reino,
    this.filo,
    this.classe,
    this.ordem,
    this.familia,
    this.genero,
    this.especie,
    this.descricao,
  });

  final String id;
  final String usuarioId;
  final String nomePopular;
  final CategoriaOrganismo categoria;
  final Localizacao localizacao;
  final List<FotoRegistro> fotos;
  final DateTime criadoEm;
  final String? reino;
  final String? filo;
  final String? classe;
  final String? ordem;
  final String? familia;
  final String? genero;
  final String? especie;
  final String? descricao;

  /// Devolve cópia alterando campos específicos.
  Organism copyWith({
    String? id,
    String? usuarioId,
    String? nomePopular,
    CategoriaOrganismo? categoria,
    Localizacao? localizacao,
    List<FotoRegistro>? fotos,
    DateTime? criadoEm,
    String? reino,
    String? filo,
    String? classe,
    String? ordem,
    String? familia,
    String? genero,
    String? especie,
    String? descricao,
  }) {
    return Organism(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      nomePopular: nomePopular ?? this.nomePopular,
      categoria: categoria ?? this.categoria,
      localizacao: localizacao ?? this.localizacao,
      fotos: fotos ?? this.fotos,
      criadoEm: criadoEm ?? this.criadoEm,
      reino: reino ?? this.reino,
      filo: filo ?? this.filo,
      classe: classe ?? this.classe,
      ordem: ordem ?? this.ordem,
      familia: familia ?? this.familia,
      genero: genero ?? this.genero,
      especie: especie ?? this.especie,
      descricao: descricao ?? this.descricao,
    );
  }
}
