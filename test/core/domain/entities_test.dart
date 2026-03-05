import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ia/core/domain/entities.dart';

void main() {
  test('instancia entidades compartilhadas', () {
    const localizacao = Localizacao(latitude: -15.0, longitude: -47.0, precisaoMetros: 3.5);
    const foto = FotoRegistro(url: 'arquivo.jpg', largura: 1200, altura: 900, tamanhoBytes: 1024);
    const notificacao = NotificacaoPreferencia(
      raioKm: 5,
      categorias: [CategoriaOrganismo.animal],
      taxons: ['Canidae'],
      especies: ['Chrysocyon brachyurus'],
    );
    final mensagem = Mensagem(
      id: 'm1',
      remetenteId: 'u1',
      destinatarioId: 'u2',
      conteudo: 'Achei um registro raro!',
      criadoEm: DateTime(2026, 3, 1),
    );
    final evento = EventoCampo(
      id: 'e1',
      titulo: 'Observação noturna',
      descricao: 'Saída para observar anfíbios',
      organizadorId: 'u1',
      localizacao: localizacao,
      dataHora: DateTime(2026, 3, 10),
      participantesIds: const ['u1', 'u2'],
    );

    expect(foto.largura, 1200);
    expect(notificacao.raioKm, 5);
    expect(mensagem.destinatarioId, 'u2');
    expect(evento.participantesIds.length, 2);
  });
}
