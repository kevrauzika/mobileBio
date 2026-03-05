import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/domain/entities.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../domain/entities/organism.dart';
import '../viewmodels/organism_view_model.dart';

/// Formulário de registro com modo leigo e avançado.
class RegistroRapidoPage extends StatefulWidget {
  /// Cria página de registro.
  const RegistroRapidoPage({super.key});

  @override
  State<RegistroRapidoPage> createState() => _RegistroRapidoPageState();
}

class _RegistroRapidoPageState extends State<RegistroRapidoPage> {
  final _nomeController = TextEditingController();
  final _especieController = TextEditingController();
  final _generoController = TextEditingController();
  final _familiaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _imageService = ImageService();
  final _locationService = LocationService();
  CategoriaOrganismo _categoria = CategoriaOrganismo.animal;
  bool _modoAvancado = false;
  File? _foto;
  List<String> _sugestoes = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrganismViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar organismo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField(
            initialValue: _categoria,
            decoration: const InputDecoration(labelText: 'Categoria'),
            items: const [
              DropdownMenuItem(value: CategoriaOrganismo.animal, child: Text('Animal')),
              DropdownMenuItem(value: CategoriaOrganismo.planta, child: Text('Planta')),
              DropdownMenuItem(value: CategoriaOrganismo.fungo, child: Text('Fungo')),
              DropdownMenuItem(value: CategoriaOrganismo.outro, child: Text('Outro')),
            ],
            onChanged: (value) => setState(() => _categoria = value ?? _categoria),
          ),
          TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome popular'),
          ),
          TextFormField(
            controller: _especieController,
            decoration: const InputDecoration(labelText: 'Espécie (opcional)'),
            onChanged: (termo) async {
              final sugestoes = await viewModel.sugerirTaxonomia(termo, _categoria);
              setState(() => _sugestoes = sugestoes);
            },
          ),
          Wrap(
            spacing: 8,
            children: _sugestoes
                .map((item) => ActionChip(label: Text(item), onPressed: () => _especieController.text = item))
                .toList(),
          ),
          SwitchListTile(
            value: _modoAvancado,
            onChanged: (value) => setState(() => _modoAvancado = value),
            title: const Text('Modo avançado de taxonomia'),
          ),
          if (_modoAvancado) ...[
            TextFormField(
              controller: _generoController,
              decoration: const InputDecoration(labelText: 'Gênero'),
            ),
            TextFormField(
              controller: _familiaController,
              decoration: const InputDecoration(labelText: 'Família'),
            ),
          ],
          TextFormField(
            controller: _descricaoController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Observações'),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              final foto = await _imageService.capturarFoto();
              setState(() => _foto = foto);
            },
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Capturar foto'),
          ),
          if (_foto != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('Foto selecionada: ${_foto!.path.split(Platform.pathSeparator).last}'),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: viewModel.carregando ? null : _registrar,
            child: const Text('Salvar registro'),
          ),
          if (viewModel.erro != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(viewModel.erro!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Future<void> _registrar() async {
    final auth = context.read<AuthViewModel>();
    final viewModel = context.read<OrganismViewModel>();
    final usuario = auth.usuarioAtual;
    if (usuario == null) {
      return;
    }
    final localizacao = await _locationService.obterAtual();
    final organismo = Organism(
      id: const Uuid().v4(),
      usuarioId: usuario.id,
      nomePopular: _nomeController.text.trim(),
      categoria: _categoria,
      localizacao: localizacao,
      fotos: [
        if (_foto != null)
          FotoRegistro(
            url: _foto!.path,
            largura: 0,
            altura: 0,
            tamanhoBytes: await _foto!.length(),
          ),
      ],
      criadoEm: DateTime.now(),
      especie: _especieController.text.trim().isEmpty ? null : _especieController.text.trim(),
      genero: _generoController.text.trim().isEmpty ? null : _generoController.text.trim(),
      familia: _familiaController.text.trim().isEmpty ? null : _familiaController.text.trim(),
      descricao: _descricaoController.text.trim().isEmpty ? null : _descricaoController.text.trim(),
    );
    await viewModel.registrar(organismo);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro salvo com sucesso.')),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _especieController.dispose();
    _generoController.dispose();
    _familiaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}
