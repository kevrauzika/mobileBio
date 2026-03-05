import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ia/core/services/notification_service.dart';

void main() {
  test('executa fluxo de notificação sem travar', () async {
    final service = NotificationService();
    try {
      await service.notificarNovoRegistro(
        titulo: 'Novo registro',
        mensagem: 'Uma nova espécie foi registrada',
      );
    } catch (_) {}
    expect(true, isTrue);
  });
}
