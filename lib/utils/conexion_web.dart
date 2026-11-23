import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Emite `true` cuando vuelve la conexión y `false` cuando se pierde.
Stream<bool> cambiosDeConexion() {
  late final StreamController<bool> controlador;

  final alConectar = ((web.Event _) => controlador.add(true)).toJS;
  final alDesconectar = ((web.Event _) => controlador.add(false)).toJS;

  controlador = StreamController<bool>(
    onListen: () {
      web.window.addEventListener('online', alConectar);
      web.window.addEventListener('offline', alDesconectar);
    },
    onCancel: () {
      web.window.removeEventListener('online', alConectar);
      web.window.removeEventListener('offline', alDesconectar);
    },
  );

  return controlador.stream;
}
