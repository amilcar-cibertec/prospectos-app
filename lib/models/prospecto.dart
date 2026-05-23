class Prospecto {
  final String nombre;
  final String telefono;
  final String correo;
  final String distrito;
  final String observaciones;
  final String fecha;
  final String vendedor;
  final String codigoVendedor;
  final String tipo;             // 4/14 | STAND | CAJA
  final String nombreReferencia; // Referidor / Stand / Alianza
  final String asesor;           // Solo para 4/14 y STAND

  Prospecto({
    required this.nombre,
    required this.telefono,
    this.correo = '',
    required this.distrito,
    required this.observaciones,
    required this.fecha,
    required this.vendedor,
    required this.codigoVendedor,
    required this.tipo,
    required this.nombreReferencia,
    this.asesor = '-',
  });

  Map<String, dynamic> toJson() => {
        'nombre':          nombre,
        'telefono':        telefono,
        'correo':          correo.isNotEmpty ? correo : '-',
        'distrito':        distrito,
        'observaciones':   observaciones,
        'fecha':           fecha,
        'vendedor':        vendedor,
        'codigoVendedor':  codigoVendedor,
        'tipo':            tipo,
        'nombreReferencia': nombreReferencia,
        'asesor':          asesor.isNotEmpty ? asesor : '-',
      };
}
