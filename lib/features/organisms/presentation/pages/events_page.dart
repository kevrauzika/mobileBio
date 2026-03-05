import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/domain/entities.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';

/// Gestão de eventos de campo colaborativos.
class EventsPage extends StatefulWidget {
  /// Cria página de eventos.
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _supabase = Supabase.instance.client;
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  Future<List<EventoCampo>> _carregarEventos() async {
    final response = await _supabase.from('field_events').select().order('data_hora');
    return (response as List<dynamic>).map((item) {
      return EventoCampo(
        id: item['id']?.toString() ?? '',
        titulo: item['titulo']?.toString() ?? '',
        descricao: item['descricao']?.toString() ?? '',
        organizadorId: item['organizador_id']?.toString() ?? '',
        localizacao: Localizacao(
          latitude: (item['latitude'] as num?)?.toDouble() ?? 0,
          longitude: (item['longitude'] as num?)?.toDouble() ?? 0,
          precisaoMetros: 0,
        ),
        dataHora: DateTime.tryParse(item['data_hora']?.toString() ?? '') ?? DateTime.now(),
        participantesIds: ((item['participantes_ids'] as List<dynamic>?) ?? []).cast<String>(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eventos de campo')),
      body: FutureBuilder<List<EventoCampo>>(
        future: _carregarEventos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final eventos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: eventos.length,
            itemBuilder: (_, index) {
              final evento = eventos[index];
              return Card(
                child: ListTile(
                  title: Text(evento.titulo),
                  subtitle: Text(evento.descricao),
                  trailing: Text('${evento.participantesIds.length} participantes'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirCriacao(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _abrirCriacao(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _tituloController, decoration: const InputDecoration(labelText: 'Título')),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final usuario = context.read<AuthViewModel>().usuarioAtual;
                  if (usuario == null) {
                    return;
                  }
                  await _supabase.from('field_events').insert({
                    'id': const Uuid().v4(),
                    'titulo': _tituloController.text.trim(),
                    'descricao': _descricaoController.text.trim(),
                    'organizador_id': usuario.id,
                    'latitude': 0,
                    'longitude': 0,
                    'data_hora': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
                    'participantes_ids': [usuario.id],
                  });
                  if (!mounted) {
                    return;
                  }
                  navigator.pop();
                  setState(() {});
                },
                child: const Text('Criar evento'),
              ),
            ],
          ),
        );
      },
    );
  }
}
