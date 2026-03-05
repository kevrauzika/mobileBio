import 'package:uuid/uuid.dart';

import '../../../../core/domain/entities.dart';
import '../../domain/entities/organism.dart';

/// Modelo de serialização para Supabase e cache local.
class OrganismModel extends Organism {
  /// Cria modelo de organismo.
  const OrganismModel({
    required super.id,
    required super.usuarioId,
    required super.nomePopular,
    required super.categoria,
    required super.localizacao,
    required super.fotos,
    required super.criadoEm,
    super.reino,
    super.filo,
    super.classe,
    super.ordem,
    super.familia,
    super.genero,
    super.especie,
    super.descricao,
  });

  /// Cria modelo a partir de entidade.
  factory OrganismModel.fromEntity(Organism entity) => OrganismModel(
        id: entity.id.isEmpty ? const Uuid().v4() : entity.id,
        usuarioId: entity.usuarioId,
        nomePopular: entity.nomePopular,
        categoria: entity.categoria,
        localizacao: entity.localizacao,
        fotos: entity.fotos,
        criadoEm: entity.criadoEm,
        reino: entity.reino,
        filo: entity.filo,
        classe: entity.classe,
        ordem: entity.ordem,
        familia: entity.familia,
        genero: entity.genero,
        especie: entity.especie,
        descricao: entity.descricao,
      );

  /// Cria modelo a partir do Supabase.
  factory OrganismModel.fromMap(Map<String, dynamic> map) {
    return OrganismModel(
      id: map['id']?.toString() ?? '',
      usuarioId: map['usuario_id']?.toString() ?? '',
      nomePopular: map['nome_popular']?.toString() ?? '',
      categoria: CategoriaOrganismo.values.firstWhere(
        (e) => e.name == map['categoria'],
        orElse: () => CategoriaOrganismo.outro,
      ),
      localizacao: Localizacao(
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
        precisaoMetros: (map['precisao_metros'] as num?)?.toDouble() ?? 0,
      ),
      fotos: ((map['fotos'] as List<dynamic>?) ?? [])
          .map(
            (item) => FotoRegistro(
              url: item['url']?.toString() ?? '',
              largura: (item['largura'] as num?)?.toInt() ?? 0,
              altura: (item['altura'] as num?)?.toInt() ?? 0,
              tamanhoBytes: (item['tamanho_bytes'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList(),
      criadoEm: DateTime.tryParse(map['criado_em']?.toString() ?? '') ?? DateTime.now(),
      reino: map['reino']?.toString(),
      filo: map['filo']?.toString(),
      classe: map['classe']?.toString(),
      ordem: map['ordem']?.toString(),
      familia: map['familia']?.toString(),
      genero: map['genero']?.toString(),
      especie: map['especie']?.toString(),
      descricao: map['descricao']?.toString(),
    );
  }

  /// Converte para mapa de banco.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'nome_popular': nomePopular,
      'categoria': categoria.name,
      'latitude': localizacao.latitude,
      'longitude': localizacao.longitude,
      'precisao_metros': localizacao.precisaoMetros,
      'fotos': fotos
          .map(
            (foto) => {
              'url': foto.url,
              'largura': foto.largura,
              'altura': foto.altura,
              'tamanho_bytes': foto.tamanhoBytes,
            },
          )
          .toList(),
      'criado_em': criadoEm.toIso8601String(),
      'reino': reino,
      'filo': filo,
      'classe': classe,
      'ordem': ordem,
      'familia': familia,
      'genero': genero,
      'especie': especie,
      'descricao': descricao,
    };
  }
}
