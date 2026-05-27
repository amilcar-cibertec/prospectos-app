import 'dart:async';
// ignore: deprecated_member_use
import 'dart:js' as js;
import '../config/app_config.dart';
import '../models/prospecto.dart';

class SheetsService {
  static int _callbackCounter = 0;

  static Future<bool> enviarProspecto(Prospecto prospecto) async {
    try {
      final params = [
        'token=${Uri.encodeComponent(AppConfig.tokenSecreto)}',  // ← nuevo
        'fecha=${Uri.encodeComponent(prospecto.fecha)}',
        'vendedor=${Uri.encodeComponent(prospecto.vendedor)}',
        'codigoVendedor=${Uri.encodeComponent(prospecto.codigoVendedor)}',
        'nombre=${Uri.encodeComponent(prospecto.nombre)}',
        'telefono=${Uri.encodeComponent(prospecto.telefono)}',
        'informacion=${Uri.encodeComponent(prospecto.informacion)}',
        'distrito=${Uri.encodeComponent(prospecto.distrito)}',
        'tipo=${Uri.encodeComponent(prospecto.tipo)}',
        'nombreReferencia=${Uri.encodeComponent(prospecto.nombreReferencia)}',
        'asesor=${Uri.encodeComponent(prospecto.asesor)}',
      ].join('&');

      _callbackCounter++;
      final callbackName = 'jsonpCallback$_callbackCounter';
      final urlFinal = '${AppConfig.scriptUrl}?$params&callback=$callbackName';

      final completer = Completer<bool>();

      js.context[callbackName] = js.allowInterop((response) {
  String status;
  if (response is js.JsObject) {
    status = response['status']?.toString() ?? '';
  } else {
    status = js.JsObject.fromBrowserObject(response)['status']?.toString() ?? '';
  }
  completer.complete(status == 'success');
  js.context.callMethod('eval', ['''
    delete window["$callbackName"];
    var s = document.getElementById("$callbackName");
    if(s) s.remove();
  ''']);
});

      js.context.callMethod('eval', ['''
        var script = document.createElement("script");
        script.id = "$callbackName";
        script.src = "$urlFinal";
        script.onerror = function() {
          console.error("Error JSONP");
        };
        document.head.appendChild(script);
      ''']);

      return completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => false,
      );

    } catch (e) {
      return false;
    }
  }

  static String? validarVendedor(String codigo) {
    return AppConfig.vendedoresValidos[codigo.toUpperCase().trim()];
  }
}