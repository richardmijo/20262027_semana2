// Escucha los cambios de conexión a internet del dispositivo.
// En web usa los eventos 'online' y 'offline' del navegador.
// En otras plataformas no hace nada (el stream está vacío).
export 'conexion_stub.dart' if (dart.library.js_interop) 'conexion_web.dart';
