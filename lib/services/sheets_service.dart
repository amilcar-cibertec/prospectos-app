import 'dart:async';
// ignore: deprecated_member_use
import 'dart:js' as js;
import '../config/app_config.dart';
import '../models/prospecto.dart';

class SheetsService {
  static int _callbackCounter = 0;

  static Future<bool> enviarProspecto(Prospecto prospecto) async {
    try {
      final partes = prospecto.observaciones.split(' | ');
      String obs1 = '-', obs2 = '-', obs3 = '-';

      for (final p in partes) {
        if (p.startsWith('1er contacto: ')) {
          obs1 = p.replaceFirst('1er contacto: ', '');
        } else if (p.startsWith('2do contacto: ')) {
          obs2 = p.replaceFirst('2do contacto: ', '');
        } else if (p.startsWith('3er contacto: ')) {
          obs3 = p.replaceFirst('3er contacto: ', '');
        }
      }

      final params = [
        'fecha=${Uri.encodeComponent(prospecto.fecha)}',
        'vendedor=${Uri.encodeComponent(prospecto.vendedor)}',
        'codigoVendedor=${Uri.encodeComponent(prospecto.codigoVendedor)}',
        'nombre=${Uri.encodeComponent(prospecto.nombre)}',
        'telefono=${Uri.encodeComponent(prospecto.telefono)}',
        'correo=${Uri.encodeComponent(prospecto.correo)}',
        'distrito=${Uri.encodeComponent(prospecto.distrito)}',
        'tipo=${Uri.encodeComponent(prospecto.tipo)}',
        'nombreReferencia=${Uri.encodeComponent(prospecto.nombreReferencia)}',
        'asesor=${Uri.encodeComponent(prospecto.asesor)}',
        'obs1=${Uri.encodeComponent(obs1)}',
        'obs2=${Uri.encodeComponent(obs2)}',
        'obs3=${Uri.encodeComponent(obs3)}',
      ].join('&');

      _callbackCounter++;
      final callbackName = 'jsonpCallback$_callbackCounter';
      final urlFinal = '${AppConfig.scriptUrl}?$params&callback=$callbackName';

      final completer = Completer<bool>();

      js.context[callbackName] = (js.JsObject response) {
        final status = response['status'];
        completer.complete(status == 'success');
        js.context.callMethod('eval', ['''
          delete window["$callbackName"];
          var s = document.getElementById("$callbackName");
          if(s) s.remove();
        ''']);
      };

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
