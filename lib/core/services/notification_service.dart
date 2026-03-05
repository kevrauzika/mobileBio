import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Serviço de notificações locais em português.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _iniciado = false;

  /// Inicializa o serviço.
  Future<void> iniciar() async {
    if (_iniciado) {
      return;
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    _iniciado = true;
  }

  /// Exibe alerta de novo registro encontrado na área.
  Future<void> notificarNovoRegistro({
    required String titulo,
    required String mensagem,
  }) async {
    await iniciar();
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titulo,
      mensagem,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'biomapa_registros',
          'Registros próximos',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
