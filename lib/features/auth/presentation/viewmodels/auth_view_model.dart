import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/usecases/auth_usecases.dart';

/// ViewModel responsável pelo fluxo de autenticação.
class AuthViewModel extends ChangeNotifier {
  /// Cria o ViewModel com casos de uso.
  AuthViewModel({required AuthUseCases useCases}) : _useCases = useCases;

  final AuthUseCases _useCases;
  StreamSubscription<AppUser?>? _subscription;
  bool carregando = false;
  String? erro;
  AppUser? usuarioAtual;

  /// Inicializa observação da sessão.
  void iniciarSessao() {
    usuarioAtual = _useCases.usuarioAtual();
    _subscription?.cancel();
    _subscription = _useCases.observarSessao().listen((usuario) {
      usuarioAtual = usuario;
      notifyListeners();
    });
  }

  /// Login com email e senha.
  Future<void> entrarComEmail(String email, String senha) async {
    await _executar(() => _useCases.entrar(email, senha));
  }

  /// Cadastro com email e senha.
  Future<void> cadastrar(String nome, String email, String senha) async {
    await _executar(() => _useCases.cadastrar(nome, email, senha));
  }

  /// Login com Google.
  Future<void> entrarComGoogle() async {
    await _executar(_useCases.entrarComGoogle);
  }

  /// Logout.
  Future<void> sair() async {
    await _executar(_useCases.sair);
  }

  Future<void> _executar(Future<void> Function() acao) async {
    carregando = true;
    erro = null;
    notifyListeners();
    try {
      await acao();
    } catch (e) {
      erro = 'Não foi possível concluir a autenticação: $e';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
