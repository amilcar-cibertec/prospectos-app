class AppConfig {
  static const String scriptUrl = String.fromEnvironment(
    'SCRIPT_URL',
    defaultValue: '',
  );

  static const String tokenSecreto = String.fromEnvironment(
    'TOKEN_SECRETO',
    defaultValue: '',
  );

  static const Map<String, String> vendedoresValidos = {
    'RIOS0029': 'Suhail.R',
    'GUAY0006': 'Yuly.G',
    'LANA0071': 'Any.L',
  };
  
  // Tipos de prospecto disponibles
  static const List<String> tiposProspecto = [
    '4/14',
    'STAND',
    'CAJA',
  ];

  // Etiqueta dinámica según tipo
  static String labelReferencia(String tipo) {
    switch (tipo) {
      case '4/14':  return 'Nombre del Referidor';
      case 'STAND': return 'Nombre del Stand';
      case 'CAJA':  return 'Nombre de la Alianza Comercial';
      default:      return 'Referencia';
    }
  }

  // Tipos que tienen campo Asesor
  static bool tieneAsesor(String tipo) {
    return tipo == '4/14' || tipo == 'STAND';
  }
}
