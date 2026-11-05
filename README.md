# Cafés de Loja ☕

Proyecto móvil desarrollado en **Flutter** para la asignatura de **Programación Móvil** (Semana 2).

---

## 🎯 Finalidad del Proyecto

La finalidad de este proyecto es servir como una práctica introductoria para aprender y aplicar conceptos modernos del lenguaje **Dart 3** y el framework **Flutter**, mediante un caso de estudio real: una aplicación para listar y explorar cafeterías de la ciudad de Loja.

A través de este ejercicio se busca:
- Comprender el flujo de una aplicación móvil en Flutter y el ciclo de vida de los widgets.
- Aplicar buenas prácticas en el modelado de datos y tipado estricto.
- Implementar filtrado dinámico en la interfaz según el estado de la aplicación (ej. cafeterías con Wi-Fi).

---

## 🚀 Conceptos Aplicados

### Dart 3
- **Enums enriquecidos:** Definición de barrios (`Barrio`) con atributos como código y nombre.
- **Modelos y Parámetros con nombre:** Clase `Cafe` con valores por defecto y manejo de nulos (*Null Safety*).
- **Extensiones:** Formateo de precios en dólares (`double.usd`).
- **Pattern Matching & Switch Expressions:** Clasificación de calificaciones mediante expresiones `switch`.
- **Records (Tuplas):** Retorno de múltiples valores en funciones de resumen estadístico `(promedio, conWifi)`.

### Flutter
- **Estructura base:** `MaterialApp`, `Scaffold`, `AppBar` y `Column`.
- **Manejo de estado básico:** Uso de `StatefulWidget` para controlar filtros interactivos y contadores de visitas.

---

## 🛠️ Cómo Ejecutar el Proyecto

1. Asegúrate de tener instalado [Flutter](https://docs.flutter.dev/get-started/install).
2. Clona o abre el repositorio en tu entorno local.
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la aplicación en tu emulador o dispositivo:
   ```bash
   flutter run
   ```
