class AppConfig {
  static const String scriptUrl =
      'https://script.google.com/macros/s/AKfycbwjQBsXDpUoCIcIKdWL2BvuMAhpsJb1us_CUVrkoxLYIEKFpcy0z0LTeetd6DjFcQ23/exec';

  static const Map<String, String> vendedoresValidos = {
    'V001':    'Suhail.R',
    'V002':    'Yuly.G',
    'V003':    'Any.L',
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
