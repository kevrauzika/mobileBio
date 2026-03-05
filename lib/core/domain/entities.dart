/// Categoria biológica principal.
enum CategoriaOrganismo { animal, planta, fungo, outro }

/// Ponto geográfico do registro.
class Localizacao {
  /// Cria localização com latitude e longitude.
  const Localizacao({
    required this.latitude,
    required this.longitude,
    required this.precisaoMetros,
  });

  final double latitude;
  final double longitude;
  final double precisaoMetros;
}

/// Dados da foto do registro.
class FotoRegistro {
  /// Cria metadados da foto enviada.
  const FotoRegistro({
    required this.url,
    required this.largura,
    required this.altura,
    required this.tamanhoBytes,
  });

  final String url;
  final int largura;
  final int altura;
  final int tamanhoBytes;
}

/// Configuração personalizada de alertas.
class NotificacaoPreferencia {
  /// Cria preferência de notificação por raio e filtros.
  const NotificacaoPreferencia({
    required this.raioKm,
    required this.categorias,
    required this.taxons,
    required this.especies,
  });

  final double raioKm;
  final List<CategoriaOrganismo> categorias;
  final List<String> taxons;
  final List<String> especies;
}

/// Mensagem privada entre usuários.
class Mensagem {
  /// Cria uma mensagem direta.
  const Mensagem({
    required this.id,
    required this.remetenteId,
    required this.destinatarioId,
    required this.conteudo,
    required this.criadoEm,
  });

  final String id;
  final String remetenteId;
  final String destinatarioId;
  final String conteudo;
  final DateTime criadoEm;
}

/// Evento de campo para observação coletiva.
class EventoCampo {
  /// Cria um evento de observação.
  const EventoCampo({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.organizadorId,
    required this.localizacao,
    required this.dataHora,
    required this.participantesIds,
  });

  final String id;
  final String titulo;
  final String descricao;
  final String organizadorId;
  final Localizacao localizacao;
  final DateTime dataHora;
  final List<String> participantesIds;
}
