import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

/// Serviço de captura e compressão automática de imagem.
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Captura foto com câmera.
  Future<File?> capturarFoto() async {
    final imagem = await _picker.pickImage(source: ImageSource.camera, imageQuality: 95);
    if (imagem == null) {
      return null;
    }
    return _comprimir(File(imagem.path));
  }

  Future<File> _comprimir(File arquivo) async {
    final caminhoDestino = '${arquivo.path}_comprimida.jpg';
    final bytes = await FlutterImageCompress.compressWithFile(
      arquivo.path,
      quality: 75,
      minWidth: 1280,
      minHeight: 1280,
    );
    if (bytes == null) {
      return arquivo;
    }
    final comprimida = File(caminhoDestino);
    await comprimida.writeAsBytes(bytes);
    return comprimida;
  }
}
