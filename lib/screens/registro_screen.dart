import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';
import '../models/prospecto.dart';
import '../services/sheets_service.dart';
import '../widgets/custom_text_field.dart';

class RegistroScreen extends StatefulWidget {
  final String nombreVendedor;
  final String codigoVendedor;

  const RegistroScreen({
    super.key,
    required this.nombreVendedor,
    required this.codigoVendedor,
  });

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey          = GlobalKey<FormState>();
  final _nombreCtrl       = TextEditingController();
  final _telefonoCtrl     = TextEditingController();
  final _distritoCtrl     = TextEditingController();
  final _informacionCtrl  = TextEditingController();
  final _referenciaCtrl   = TextEditingController();

  String? _tipoSeleccionado;
  String? _asesorSeleccionado;

  bool    _enviando = false;
  String? _mensaje;
  bool    _exito    = false;

  // 1. Nueva variable para guardar la fecha seleccionada
  DateTime _fechaSeleccionada = DateTime.now();

  // 2. Formatea la fecha elegida y le añade la hora actual
  String get _fechaFormateada {
    final date = DateFormat('dd/MM/yyyy').format(_fechaSeleccionada);
    final time = DateFormat('HH:mm').format(DateTime.now());
    return '$date $time';
  }

  List<String> get _asesoresDisponibles =>
      AppConfig.vendedoresValidos.values
          .where((n) => n != widget.nombreVendedor)
          .toList();

  // 3. Función del DatePicker con límites de 7 días atrás y HOY como máximo
  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final fechaElegida = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: hoy.subtract(const Duration(days: 7)), // Máximo 7 días atrás
      lastDate: hoy, // Nada en el futuro
    );

    if (fechaElegida != null) {
      setState(() {
        _fechaSeleccionada = fechaElegida;
      });
    }
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tipoSeleccionado == null) {
      setState(() {
        _mensaje = '❌ Selecciona el tipo de prospecto';
        _exito   = false;
      });
      return;
    }

    setState(() { _enviando = true; _mensaje = null; });

    final prospecto = Prospecto(
      nombre:           _nombreCtrl.text.trim(),
      telefono:         _telefonoCtrl.text.trim(),
      informacion:      _informacionCtrl.text.trim(),
      distrito:         _distritoCtrl.text.trim(),
      fecha:            _fechaFormateada, // Usa la nueva fecha formateada
      vendedor:         widget.nombreVendedor,
      codigoVendedor:   widget.codigoVendedor,
      tipo:             _tipoSeleccionado!,
      nombreReferencia: _referenciaCtrl.text.trim(),
      asesor:           _asesorSeleccionado ?? '-',
    );

    final ok = await SheetsService.enviarProspecto(prospecto);

    setState(() {
      _enviando = false;
      _exito    = ok;
      _mensaje  = ok
          ? '✅ Prospecto registrado en hoja "$_tipoSeleccionado"'
          : '❌ Error al subir datos';
    });

    if (ok) _limpiar();
  }

  void _limpiar() {
    _nombreCtrl.clear();
    _telefonoCtrl.clear();
    _distritoCtrl.clear();
    _informacionCtrl.clear();
    _referenciaCtrl.clear();
    setState(() {
      _tipoSeleccionado   = null;
      _asesorSeleccionado = null;
      _fechaSeleccionada  = DateTime.now(); // Resetea la fecha al limpiar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Text('Nuevo Prospecto',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Chip(
              avatar: const Icon(Icons.person, size: 16, color: Colors.white),
              label: Text(widget.nombreVendedor,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
              backgroundColor: Colors.indigo.shade700,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 1. TIPO
                  _seccion('🏷️ Tipo de Prospecto'),
                  _comboTipo(),
                  const SizedBox(height: 16),

                  // 2. REFERENCIA
                  if (_tipoSeleccionado != null) ...[
                    _seccion('📌 ${AppConfig.labelReferencia(_tipoSeleccionado!)}'),
                    CustomTextField(
                      label: AppConfig.labelReferencia(_tipoSeleccionado!),
                      controller: _referenciaCtrl,
                      icon: Icons.store_outlined,
                    ),
                  ],

                  // 3. TELÉFONO
                  _seccion('📞 Teléfono'),
                  CustomTextField(
                    label: 'Teléfono',
                    controller: _telefonoCtrl,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),

                  // 4. NOMBRE Y APELLIDO
                  _seccion('👤 Nombre y Apellido del Prospecto'),
                  CustomTextField(
                    label: 'Nombre y apellido',
                    controller: _nombreCtrl,
                    icon: Icons.person_outline,
                  ),

                  // 5. INFORMACIÓN
                  _seccion('📝 Información'),
                  CustomTextField(
                    label: 'Información',
                    controller: _informacionCtrl,
                    icon: Icons.info_outline,
                    maxLines: 3,
                    obligatorio: false,
                    hint: 'Notas, observaciones, seguimiento...',
                  ),

                  // 6. DISTRITO
                  _seccion('📍 Distrito'),
                  CustomTextField(
                    label: 'Distrito',
                    controller: _distritoCtrl,
                    icon: Icons.location_on_outlined,
                  ),

                  // 7. ASESOR 2
                  if (_tipoSeleccionado != null &&
                      AppConfig.tieneAsesor(_tipoSeleccionado!)) ...[
                    _seccion('👥 Asesor 2'),
                    _comboAsesor(),
                    const SizedBox(height: 16),
                  ],

                  // 8. FECHA (Seleccionable mediante InkWell)
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _seleccionarFecha,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo.shade100),
                      ),
                      child: Row(children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.indigo, size: 18),
                        const SizedBox(width: 10),
                        Text('Fecha: $_fechaFormateada',
                            style: GoogleFonts.poppins(
                                color: Colors.indigo.shade700)),
                        const Spacer(), // Empuja el ícono de edición a la derecha
                        Icon(Icons.edit_calendar, color: Colors.indigo.shade300, size: 20),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MENSAJE
                  if (_mensaje != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _exito ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: _exito
                                ? Colors.green.shade300
                                : Colors.red.shade300),
                      ),
                      child: Text(_mensaje!,
                          style: TextStyle(
                            color: _exito
                                ? Colors.green[800]
                                : Colors.red[800],
                            fontWeight: FontWeight.w500,
                          )),
                    ),

                  // BOTÓN REGISTRAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _enviando ? null : _enviar,
                      icon: _enviando
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.cloud_upload_outlined),
                      label: Text(
                        _enviando ? 'Enviando...' : 'Registrar Prospecto',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _comboTipo() {
    return DropdownButtonFormField<String>(
      value: _tipoSeleccionado,
      decoration: InputDecoration(
        labelText: 'Tipo de prospecto *',
        prefixIcon:
            const Icon(Icons.category_outlined, color: Colors.indigo),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      items: AppConfig.tiposProspecto.map((tipo) {
        return DropdownMenuItem(
          value: tipo,
          child: Row(children: [
            Icon(_iconTipo(tipo), size: 18, color: Colors.indigo),
            const SizedBox(width: 10),
            Text(tipo, style: GoogleFonts.poppins()),
          ]),
        );
      }).toList(),
      onChanged: (val) => setState(() {
        _tipoSeleccionado   = val;
        _asesorSeleccionado = null;
        _referenciaCtrl.clear();
      }),
      validator: (val) =>
          val == null ? 'Selecciona el tipo de prospecto' : null,
    );
  }

  Widget _comboAsesor() {
    return DropdownButtonFormField<String>(
      value: _asesorSeleccionado,
      decoration: InputDecoration(
        labelText: 'Asesor 2 (opcional)',
        prefixIcon:
            const Icon(Icons.people_outline, color: Colors.indigo),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
      ),
      items: [
        DropdownMenuItem(
          value: null,
          child: Text('Sin Asesor 2',
              style: GoogleFonts.poppins(color: Colors.grey)),
        ),
        ..._asesoresDisponibles.map((nombre) => DropdownMenuItem(
              value: nombre,
              child: Text(nombre, style: GoogleFonts.poppins()),
            )),
      ],
      onChanged: (val) => setState(() => _asesorSeleccionado = val),
    );
  }

  IconData _iconTipo(String tipo) {
    switch (tipo) {
      case '4/14':  return Icons.groups_outlined;
      case 'STAND': return Icons.storefront_outlined;
      case 'CAJA':  return Icons.handshake_outlined;
      default:      return Icons.label_outline;
    }
  }

  Widget _seccion(String titulo) => Padding(
        padding: const EdgeInsets.only(bottom: 14, top: 8),
        child: Text(titulo,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.indigo.shade800)),
      );
}