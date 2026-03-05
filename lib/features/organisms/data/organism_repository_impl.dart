import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/domain/entities.dart';
import '../domain/entities/organism.dart';
import '../domain/repositories/organism_repository.dart';
import 'models/organism_model.dart';

/// Repositório de organismos com Supabase, cache local e sync offline.
class OrganismRepositoryImpl implements OrganismRepository {
  OrganismRepositoryImpl() {
    _abrirCaixa();
  }

  final SupabaseClient _client = Supabase.instance.client;
  final StreamController<Organism> _realtimeController = StreamController.broadcast();
  Box<Map>? _boxPendentes;

  Future<void> _abrirCaixa() async {
    _boxPendentes = await Hive.openBox<Map>('registros_pendentes');
    _iniciarRealtime();
  }

  void _iniciarRealtime() {
    _client
        .channel('organisms-realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'organisms',
          callback: (payload) {
            final map = payload.newRecord;
            _realtimeController.add(OrganismModel.fromMap(map));
          },
        )
        .subscribe();
  }

  @override
  Future<List<Organism>> listar({
    CategoriaOrganismo? categoria,
    DateTime? de,
    DateTime? ate,
    String? usuarioId,
  }) async {
    PostgrestFilterBuilder<dynamic> query = _client.from('organisms').select();
    if (categoria != null) {
      query = query.eq('categoria', categoria.name);
    }
    if (usuarioId != null && usuarioId.isNotEmpty) {
      query = query.eq('usuario_id', usuarioId);
    }
    if (de != null) {
      query = query.gte('criado_em', de.toIso8601String());
    }
    if (ate != null) {
      query = query.lte('criado_em', ate.toIso8601String());
    }
    final response = await query.order('criado_em', ascending: false);
    return (response as List<dynamic>).map((item) => OrganismModel.fromMap(item)).toList();
  }

  @override
  Future<void> registrar(Organism organismo) async {
    final model = OrganismModel.fromEntity(organismo);
    final conectado = await _conectado();
    if (!conectado) {
      await salvarPendente(model);
      return;
    }
    await _client.from('organisms').insert(model.toMap());
  }

  @override
  Future<void> salvarPendente(Organism organismo) async {
    await _abrirCaixa();
    final box = _boxPendentes;
    if (box == null) {
      return;
    }
    final model = OrganismModel.fromEntity(organismo);
    await box.put(model.id, model.toMap());
  }

  @override
  Future<void> sincronizarPendentes() async {
    await _abrirCaixa();
    if (!await _conectado()) {
      return;
    }
    final box = _boxPendentes;
    if (box == null) {
      return;
    }
    for (final item in box.values) {
      await _client.from('organisms').upsert(Map<String, dynamic>.from(item));
    }
    await box.clear();
  }

  @override
  Future<List<String>> sugerirClassificacao({
    required String termo,
    required CategoriaOrganismo categoria,
  }) async {
    if (termo.trim().isEmpty) {
      return [];
    }
    final response = await _client
        .from('taxonomy_dictionary')
        .select('nome_cientifico')
        .eq('categoria', categoria.name)
        .ilike('nome_cientifico', '%$termo%')
        .limit(5);
    return (response as List<dynamic>).map((e) => e['nome_cientifico'].toString()).toList();
  }

  @override
  Stream<Organism> observarNovosRegistros() => _realtimeController.stream;

  Future<bool> _conectado() async {
    final conectividade = await Connectivity().checkConnectivity();
    return !conectividade.contains(ConnectivityResult.none);
  }
}
