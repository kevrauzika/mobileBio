import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ia/core/domain/entities.dart';
import 'package:mobile_ia/features/organisms/domain/entities/organism.dart';
import 'package:mobile_ia/features/organisms/domain/repositories/organism_repository.dart';
import 'package:mobile_ia/features/organisms/domain/usecases/organism_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _OrganismRepositoryMock extends Mock implements OrganismRepository {}

void main() {
  late _OrganismRepositoryMock repository;
  late OrganismUseCases useCases;

  setUp(() {
    repository = _OrganismRepositoryMock();
    useCases = OrganismUseCases(repository: repository);
  });

  test('lista organismos por filtro', () async {
    final organismo = Organism(
      id: 'o1',
      usuarioId: 'u1',
      nomePopular: 'Ipê',
      categoria: CategoriaOrganismo.planta,
      localizacao: Localizacao(latitude: 0, longitude: 0, precisaoMetros: 5),
      fotos: [],
      criadoEm: DateTime(2025),
    );
    when(
      () => repository.listar(
        categoria: CategoriaOrganismo.planta,
        de: any(named: 'de'),
        ate: any(named: 'ate'),
        usuarioId: any(named: 'usuarioId'),
      ),
    ).thenAnswer((_) async => [organismo]);

    final resultado = await useCases.listar(categoria: CategoriaOrganismo.planta);
    expect(resultado.first.nomePopular, 'Ipê');
  });

  test('encaminha sincronização pendente', () async {
    when(() => repository.sincronizarPendentes()).thenAnswer((_) async {});
    await useCases.sincronizarPendentes();
    verify(() => repository.sincronizarPendentes()).called(1);
  });
}
