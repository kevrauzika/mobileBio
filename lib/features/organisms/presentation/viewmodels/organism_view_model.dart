import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/domain/entities.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/sync_service.dart';
import '../../domain/entities/organism.dart';
import '../../domain/usecases/organism_usecases.dart';

/// ViewModel para feed, mapa, filtros e registro rápido.
class OrganismViewModel extends ChangeNotifier {
  /// Cria o ViewModel de organismos.
  OrganismViewModel({
    required OrganismUseCases useCases,
    required NotificationService notificationService,
    required SyncService syncService,
  })  : _useCases = useCases,
        _notificationService = notificationService,
        _syncService = syncService;

  final OrganismUseCases _useCases;
  final NotificationService _notificationService;
  final SyncService _syncService;
  final List<Organism> _organismos = [];
  StreamSubscription<Organism>? _streamSubscription;

  bool carregando = false;
  String? erro;
  CategoriaOrganismo? filtroCategoria;
  DateTimeRange? filtroPeriodo;
  String? filtroUsuario;
  NotificacaoPreferencia notificacaoPreferencia = const NotificacaoPreferencia(
    raioKm: 3,
    categorias: [CategoriaOrganismo.animal, CategoriaOrganismo.planta, CategoriaOrganismo.fungo],
    taxons: [],
    especies: [],
  );

  /// Organismos visíveis no feed e mapa.
  List<Organism> get organismos => List.unmodifiable(_organismos);

  /// Carrega dados iniciais e assina realtime.
  Future<void> carregar() async {
    await _listar();
    _streamSubscription?.cancel();
    _streamSubscription = _useCases.observarNovosRegistros().listen((novo) async {
      _organismos.insert(0, novo);
      notifyListeners();
      if (notificacaoPreferencia.categorias.contains(novo.categoria)) {
        await _notificationService.notificarNovoRegistro(
          titulo: 'Novo registro próximo',
          mensagem: '${novo.nomePopular} foi registrado na sua região.',
        );
      }
    });
  }

  /// Atualiza filtros dinâmicos do mapa.
  Future<void> aplicarFiltros({
    CategoriaOrganismo? categoria,
    DateTimeRange? periodo,
    String? usuarioId,
  }) async {
    filtroCategoria = categoria;
    filtroPeriodo = periodo;
    filtroUsuario = usuarioId;
    await _listar();
  }

  /// Registra organismo e tenta sincronizar.
  Future<void> registrar(Organism organismo) async {
    await _executar(() async {
      await _useCases.registrar(organismo);
      await _syncService.sincronizar();
      await _listar();
    });
  }

  /// Busca sugestões taxonômicas.
  Future<List<String>> sugerirTaxonomia(
    String termo,
    CategoriaOrganismo categoria,
  ) {
    return _useCases.sugerir(termo, categoria);
  }

  /// Atualiza preferências de notificações personalizadas.
  void atualizarPreferencias(NotificacaoPreferencia preferencia) {
    notificacaoPreferencia = preferencia;
    notifyListeners();
  }

  Future<void> _listar() async {
    await _executar(() async {
      final resultado = await _useCases.listar(
        categoria: filtroCategoria,
        de: filtroPeriodo?.start,
        ate: filtroPeriodo?.end,
        usuarioId: filtroUsuario,
      );
      _organismos
        ..clear()
        ..addAll(resultado);
    });
  }

  Future<void> _executar(Future<void> Function() acao) async {
    carregando = true;
    erro = null;
    notifyListeners();
    try {
      await acao();
    } catch (e) {
      erro = 'Falha na operação de organismos: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
