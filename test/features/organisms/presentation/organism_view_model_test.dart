import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ia/core/domain/entities.dart';
import 'package:mobile_ia/core/services/notification_service.dart';
import 'package:mobile_ia/core/services/sync_service.dart';
import 'package:mobile_ia/features/organisms/domain/entities/organism.dart';
import 'package:mobile_ia/features/organisms/domain/repositories/organism_repository.dart';
import 'package:mobile_ia/features/organisms/domain/usecases/organism_usecases.dart';
import 'package:mobile_ia/features/organisms/presentation/viewmodels/organism_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _OrganismRepositoryMock extends Mock implements OrganismRepository {}

class _NotificationServiceFake extends NotificationService {
  int chamadas = 0;

  @override
  Future<void> notificarNovoRegistro({required String titulo, required String mensagem}) async {
    chamadas++;
  }
}

void main() {
  late _OrganismRepositoryMock repository;
  late OrganismViewModel viewModel;
  late _NotificationServiceFake notificationService;

  setUpAll(() {
    registerFallbackValue(
      Organism(
        id: 'fallback',
        usuarioId: 'fallback',
        nomePopular: 'fallback',
        categoria: CategoriaOrganismo.outro,
        localizacao: const Localizacao(latitude: 0, longitude: 0, precisaoMetros: 0),
        fotos: const [],
        criadoEm: DateTime(2026),
      ),
    );
  });

  setUp(() {
    repository = _OrganismRepositoryMock();
    notificationService = _NotificationServiceFake();
    when(() => repository.listar(categoria: null, de: null, ate: null, usuarioId: null))
        .thenAnswer((_) async => []);
    when(() => repository.observarNovosRegistros()).thenAnswer((_) => const Stream.empty());
    when(() => repository.registrar(any())).thenAnswer((_) async {});
    when(() => repository.sincronizarPendentes()).thenAnswer((_) async {});
    when(() => repository.sugerirClassificacao(termo: 'lup', categoria: CategoriaOrganismo.animal))
        .thenAnswer((_) async => ['Canis lupus']);

    final useCases = OrganismUseCases(repository: repository);
    final syncService = SyncService(repository: repository);
    viewModel = OrganismViewModel(
      useCases: useCases,
      notificationService: notificationService,
      syncService: syncService,
    );
  });

  test('carrega lista inicial sem erro', () async {
    await viewModel.carregar();
    expect(viewModel.erro, isNull);
    expect(viewModel.organismos, isEmpty);
  });

  test('retorna sugestão de taxonomia', () async {
    final sugestoes = await viewModel.sugerirTaxonomia('lup', CategoriaOrganismo.animal);
    expect(sugestoes, ['Canis lupus']);
  });

  test('registra organismo e sincroniza pendências', () async {
    final organismo = Organism(
      id: 'o1',
      usuarioId: 'u1',
      nomePopular: 'Lobo-guará',
      categoria: CategoriaOrganismo.animal,
      localizacao: Localizacao(latitude: -10, longitude: -50, precisaoMetros: 3),
      fotos: [],
      criadoEm: DateTime(2026),
    );
    await viewModel.registrar(organismo);
    verify(() => repository.registrar(organismo)).called(1);
    verify(() => repository.sincronizarPendentes()).called(1);
  });
}
