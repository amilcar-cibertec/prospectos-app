class Prospecto {
  final String nombre;
  final String telefono;
  final String correo;
  final String distrito;
  final String observaciones;
  final String fecha;
  final String vendedor;
  final String codigoVendedor;

  Prospecto({
    required this.nombre,
    required this.telefono,
    this.correo = '',
    required this.distrito,
    required this.observaciones,
    required this.fecha,
    required this.vendedor,
    required this.codigoVendedor,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'telefono': telefono,
        'correo': correo,
        'distrito': distrito,
        'observaciones': observaciones,
        'fecha': fecha,
        'vendedor': vendedor,
        'codigoVendedor': codigoVendedor,
      };
}