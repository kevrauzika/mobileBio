import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/entities/app_user.dart';
import '../domain/repositories/auth_repository.dart';
import 'models/app_user_model.dart';

/// Implementação do repositório de autenticação integrada ao Supabase.
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  AppUser? get usuarioAtual {
    final usuario = _client.auth.currentUser;
    if (usuario == null) {
      return null;
    }
    return AppUserModel(
      id: usuario.id,
      nome: usuario.userMetadata?['full_name']?.toString() ??
          usuario.email?.split('@').first ??
          'Observador',
      email: usuario.email ?? '',
      totalRegistros: 0,
      especiesDiferentes: 0,
      areasExploradas: 0,
    );
  }

  @override
  Stream<AppUser?> observarSessao() {
    return _client.auth.onAuthStateChange.map((_) => usuarioAtual);
  }

  @override
  Future<void> cadastrarComEmail({
    required String nome,
    required String email,
    required String senha,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: senha,
      data: {'full_name': nome},
    );
  }

  @override
  Future<void> entrarComEmail({
    required String email,
    required String senha,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: senha);
  }

  @override
  Future<void> entrarComGoogle() async {
    const webClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
    const iosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
    final googleSignIn = GoogleSignIn(
      clientId: iosClientId.isEmpty ? null : iosClientId,
      serverClientId: webClientId.isEmpty ? null : webClientId,
    );
    final conta = await googleSignIn.signIn();
    if (conta == null) {
      throw const AuthException('Login com Google cancelado.');
    }
    final auth = await conta.authentication;
    final idToken = auth.idToken;
    final accessToken = auth.accessToken;
    if (idToken == null || accessToken == null) {
      throw const AuthException('Falha ao recuperar token do Google.');
    }
    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<void> sair() async {
    await _client.auth.signOut();
  }
}
