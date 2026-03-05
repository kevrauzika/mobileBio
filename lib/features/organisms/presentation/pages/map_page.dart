import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../core/domain/entities.dart';
import '../viewmodels/organism_view_model.dart';

/// Tela principal com mapa interativo e filtros.
class MapPage extends StatelessWidget {
  /// Cria página do mapa.
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrganismViewModel>();
    final markers = viewModel.organismos
        .map(
          (organismo) => Marker(
            point: LatLng(organismo.localizacao.latitude, organismo.localizacao.longitude),
            width: 40,
            height: 40,
            child: Icon(Icons.location_on, color: _corCategoria(organismo.categoria), size: 34),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa biológico'),
        actions: [
          PopupMenuButton<CategoriaOrganismo?>(
            icon: const Icon(Icons.filter_alt_outlined),
            onSelected: (categoria) => viewModel.aplicarFiltros(categoria: categoria),
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text('Todas categorias')),
              PopupMenuItem(value: CategoriaOrganismo.animal, child: Text('Animais')),
              PopupMenuItem(value: CategoriaOrganismo.planta, child: Text('Plantas')),
              PopupMenuItem(value: CategoriaOrganismo.fungo, child: Text('Fungos')),
              PopupMenuItem(value: CategoriaOrganismo.outro, child: Text('Outros')),
            ],
          ),
          IconButton(
            onPressed: () => _abrirPreferencias(context, viewModel),
            icon: const Icon(Icons.notifications_active_outlined),
          ),
        ],
      ),
      body: FlutterMap(
        options: const MapOptions(initialCenter: LatLng(-14.235004, -51.92528), initialZoom: 4),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'br.com.mobileia.mobile_ia',
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              size: const Size(48, 48),
              markers: markers,
              builder: (context, markers) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(markers.length.toString())),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Acesse a aba Registrar no menu inferior.')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Registro rápido'),
      ),
    );
  }

  Color _corCategoria(CategoriaOrganismo categoria) {
    switch (categoria) {
      case CategoriaOrganismo.animal:
        return Colors.orange;
      case CategoriaOrganismo.planta:
        return Colors.green;
      case CategoriaOrganismo.fungo:
        return Colors.purple;
      case CategoriaOrganismo.outro:
        return Colors.blueGrey;
    }
  }

  Future<void> _abrirPreferencias(BuildContext context, OrganismViewModel viewModel) async {
    double raio = viewModel.notificacaoPreferencia.raioKm;
    final categoriasSelecionadas = {...viewModel.notificacaoPreferencia.categorias};
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notificações personalizadas', style: Theme.of(context).textTheme.titleMedium),
                  Slider(
                    value: raio,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: '${raio.toStringAsFixed(0)} km',
                    onChanged: (novo) => setState(() => raio = novo),
                  ),
                  Wrap(
                    spacing: 8,
                    children: CategoriaOrganismo.values
                        .map(
                          (categoria) => FilterChip(
                            label: Text(categoria.name),
                            selected: categoriasSelecionadas.contains(categoria),
                            onSelected: (selecionado) {
                              setState(() {
                                if (selecionado) {
                                  categoriasSelecionadas.add(categoria);
                                } else {
                                  categoriasSelecionadas.remove(categoria);
                                }
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () {
                      viewModel.atualizarPreferencias(
                        NotificacaoPreferencia(
                          raioKm: raio,
                          categorias: categoriasSelecionadas.toList(),
                          taxons: const [],
                          especies: const [],
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Salvar preferências'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
