import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ia/core/domain/entities.dart';
import 'package:mobile_ia/features/organisms/domain/entities/organism.dart';

void main() {
  test('copyWith mantém dados e altera campos desejados', () {
    final original = Organism(
      id: 'o1',
      usuarioId: 'u1',
      nomePopular: 'Lobo',
      categoria: CategoriaOrganismo.animal,
      localizacao: Localizacao(latitude: -10, longitude: -50, precisaoMetros: 2),
      fotos: [FotoRegistro(url: 'a.jpg', largura: 10, altura: 10, tamanhoBytes: 120)],
      criadoEm: DateTime(2026, 1, 1),
      especie: 'Chrysocyon brachyurus',
      descricao: 'Registro no cerrado',
    );

    final alterado = original.copyWith(
      nomePopular: 'Lobo-guará',
      categoria: CategoriaOrganismo.outro,
      familia: 'Canidae',
      genero: 'Chrysocyon',
      reino: 'Animalia',
      filo: 'Chordata',
      classe: 'Mammalia',
      ordem: 'Carnivora',
    );

    expect(alterado.id, 'o1');
    expect(alterado.nomePopular, 'Lobo-guará');
    expect(alterado.categoria, CategoriaOrganismo.outro);
    expect(alterado.familia, 'Canidae');
    expect(alterado.genero, 'Chrysocyon');
    expect(alterado.reino, 'Animalia');
    expect(alterado.filo, 'Chordata');
    expect(alterado.classe, 'Mammalia');
    expect(alterado.ordem, 'Carnivora');
  });

  test('copyWith sem parâmetros preserva todos os campos', () {
    final original = Organism(
      id: 'o2',
      usuarioId: 'u2',
      nomePopular: 'Ipê-amarelo',
      categoria: CategoriaOrganismo.planta,
      localizacao: const Localizacao(latitude: -20, longitude: -45, precisaoMetros: 4),
      fotos: const [],
      criadoEm: DateTime(2026, 2, 1),
      reino: 'Plantae',
      filo: 'Magnoliophyta',
      classe: 'Magnoliopsida',
      ordem: 'Lamiales',
      familia: 'Bignoniaceae',
      genero: 'Handroanthus',
      especie: 'H. albus',
      descricao: 'Árvore em área urbana',
    );
    final copia = original.copyWith();
    expect(copia.nomePopular, original.nomePopular);
    expect(copia.categoria, original.categoria);
    expect(copia.genero, original.genero);
    expect(copia.especie, original.especie);
  });
}
