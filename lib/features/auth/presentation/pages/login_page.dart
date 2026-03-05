import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_view_model.dart';

/// Tela de login e cadastro.
class LoginPage extends StatefulWidget {
  /// Cria a tela de autenticação.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _modoCadastro = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _modoCadastro ? 'Crie sua conta no BioMapa' : 'Entrar no BioMapa',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    if (_modoCadastro)
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(labelText: 'Nome completo'),
                        validator: (value) =>
                            (value == null || value.trim().length < 3) ? 'Informe um nome válido' : null,
                      ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || !value.contains('@')) ? 'Email inválido' : null,
                    ),
                    TextFormField(
                      controller: _senhaController,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 6)
                          ? 'A senha precisa ter ao menos 6 caracteres'
                          : null,
                    ),
                    if (auth.erro != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(auth.erro!, style: const TextStyle(color: Colors.red)),
                      ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: auth.carregando ? null : () => _submeter(auth),
                      child: Text(_modoCadastro ? 'Cadastrar' : 'Entrar'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: auth.carregando ? null : auth.entrarComGoogle,
                      child: const Text('Entrar com Google'),
                    ),
                    TextButton(
                      onPressed: auth.carregando
                          ? null
                          : () => setState(() {
                                _modoCadastro = !_modoCadastro;
                              }),
                      child: Text(_modoCadastro ? 'Já tenho conta' : 'Quero criar conta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submeter(AuthViewModel auth) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_modoCadastro) {
      await auth.cadastrar(
        _nomeController.text.trim(),
        _emailController.text.trim(),
        _senhaController.text.trim(),
      );
      return;
    }
    await auth.entrarComEmail(
      _emailController.text.trim(),
      _senhaController.text.trim(),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}
