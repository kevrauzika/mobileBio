import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/viewmodels/auth_view_model.dart';

/// Perfil social com estatísticas, seguidores e mensagens privadas.
class ProfilePage extends StatefulWidget {
  /// Cria página de perfil.
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _supabase = Supabase.instance.client;
  final _mensagemController = TextEditingController();
  final _seguirController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthViewModel>().usuarioAtual;
    if (usuario == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu perfil'),
        actions: [
          IconButton(
            onPressed: context.read<AuthViewModel>().sair,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(usuario.nome),
              subtitle: Text(usuario.email),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Registros: ${usuario.totalRegistros}'),
                  Text('Espécies: ${usuario.especiesDiferentes}'),
                  Text('Áreas: ${usuario.areasExploradas}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Rede de seguidores'),
          const SizedBox(height: 8),
          TextField(
            controller: _seguirController,
            decoration: const InputDecoration(
              labelText: 'ID do usuário para seguir/deixar de seguir',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () async {
              final alvoId = _seguirController.text.trim();
              if (alvoId.isEmpty) {
                return;
              }
              final existentes = await _supabase
                  .from('follows')
                  .select('follower_id, followed_id')
                  .eq('follower_id', usuario.id)
                  .eq('followed_id', alvoId)
                  .limit(1);
              if ((existentes as List).isEmpty) {
                await _supabase.from('follows').insert({
                  'follower_id': usuario.id,
                  'followed_id': alvoId,
                });
              } else {
                await _supabase.from('follows').delete().match({
                  'follower_id': usuario.id,
                  'followed_id': alvoId,
                });
              }
              if (mounted) {
                setState(() {});
              }
            },
            child: const Text('Alternar seguir'),
          ),
          const SizedBox(height: 12),
          const Text('Mensagens privadas'),
          const SizedBox(height: 8),
          FutureBuilder<List<dynamic>>(
            future: _supabase.from('messages').select().eq('destinatario_id', usuario.id).limit(10),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const LinearProgressIndicator();
              }
              final mensagens = snapshot.data!;
              return Column(
                children: mensagens
                    .map(
                      (item) => Card(
                        child: ListTile(
                          title: Text(item['conteudo']?.toString() ?? ''),
                          subtitle: Text('De: ${item['remetente_id']}'),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _mensagemController,
            decoration: const InputDecoration(
              labelText: 'Enviar mensagem para um usuário',
              hintText: 'Formato: usuario_id: mensagem',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () async {
              final texto = _mensagemController.text.trim();
              final partes = texto.split(':');
              if (partes.length < 2) {
                return;
              }
              final destinatarioId = partes.first.trim();
              final conteudo = partes.sublist(1).join(':').trim();
              await _supabase.from('messages').insert({
                'remetente_id': usuario.id,
                'destinatario_id': destinatarioId,
                'conteudo': conteudo,
              });
              _mensagemController.clear();
              if (mounted) {
                setState(() {});
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    _seguirController.dispose();
    super.dispose();
  }
}
