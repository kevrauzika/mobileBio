import 'package:geolocator/geolocator.dart';

import '../domain/entities.dart';

/// Serviço para captura de geolocalização com permissões.
class LocationService {
  /// Obtém localização atual do dispositivo.
  Future<Localizacao> obterAtual() async {
    final habilitado = await Geolocator.isLocationServiceEnabled();
    if (!habilitado) {
      throw Exception('Ative o GPS para registrar organismos.');
    }

    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied || permissao == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada.');
    }

    final position = await Geolocator.getCurrentPosition();
    return Localizacao(
      latitude: position.latitude,
      longitude: position.longitude,
      precisaoMetros: position.accuracy,
    );
  }
}
