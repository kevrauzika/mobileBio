import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../viewmodels/organism_view_model.dart';

/// Feed social de registros da comunidade.
class FeedPage extends StatelessWidget {
  /// Cria página de feed.
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrganismViewModel>();
    final formatter = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
    return Scaffold(
      appBar: AppBar(title: const Text('Feed da comunidade')),
      body: RefreshIndicator(
        onRefresh: viewModel.carregar,
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: viewModel.organismos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = viewModel.organismos[index];
            return Card(
              child: ListTile(
                title: Text(item.nomePopular),
                subtitle: Text(
                  '${item.especie ?? 'Espécie não informada'} • ${formatter.format(item.criadoEm)}',
                ),
                trailing: Text(item.categoria.name.toUpperCase()),
              ),
            );
          },
        ),
      ),
    );
  }
}
