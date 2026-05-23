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
  final _formKey = GlobalKey<FormState>();

  // Controladores existentes
  final _nombreCtrl      = TextEditingController();
  final _telefonoCtrl    = TextEditingController();
  final _correoCtrl      = TextEditingController();
  final _distritoCtrl    = TextEditingController();
  final _obs1Ctrl        = TextEditingController();
  final _obs2Ctrl        = TextEditingController();
  final _obs3Ctrl        = TextEditingController();
  final _referenciaCtrl  = TextEditingController();

  // Nuevos campos
  String? _tipoSeleccionado;
  String? _asesorSeleccionado;

  bool _enviando = false;
  String? _mensaje;
  bool _exito = false;

  String get _fechaHoy =>
      DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

  // Vendedores disponibles para asesor (excluye al logueado)
  List<String> get _asesoresDisponibles {
    return AppConfig.vendedoresValidos.values
        .where((nombre) => nombre != widget.nombreVendedor)
        .toList();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tipoSeleccionado == null) {
      setState(() {
        _mensaje = '❌ Selecciona el tipo de prospecto';
        _exito = false;
      });
      return;
    }

    setState(() { _enviando = true; _mensaje = null; });

    final obs = [
      if (_obs1Ctrl.text.trim().isNotEmpty)
        '1er contacto: ${_obs1Ctrl.text.trim()}',
      if (_obs2Ctrl.text.trim().isNotEmpty)
        '2do contacto: ${_obs2Ctrl.text.trim()}',
      if (_obs3Ctrl.text.trim().isNotEmpty)
        '3er contacto: ${_obs3Ctrl.text.trim()}',
    ].join(' | ');

    final prospecto = Prospecto(
      nombre:          _nombreCtrl.text.trim(),
      telefono:        _telefonoCtrl.text.trim(),
      correo:          _correoCtrl.text.trim(),
      distrito:        _distritoCtrl.text.trim(),
      observaciones:   obs,
      fecha:           _fechaHoy,
      vendedor:        widget.nombreVendedor,
      codigoVendedor:  widget.codigoVendedor,
      tipo:            _tipoSeleccionado!,
      nombreReferencia: _referenciaCtrl.text.trim(),
      asesor:          _asesorSeleccionado ?? '-',
    );

    final ok = await SheetsService.enviarProspecto(prospecto);

    setState(() {
      _enviando = false;
      _exito = ok;
      _mensaje = ok
          ? '✅ Prospecto registrado en hoja "$_tipoSeleccionado"'
          : '❌ Error al subir datos';
    });

    if (ok) _limpiar();
  }

  void _limpiar() {
    _nombreCtrl.clear();
    _telefonoCtrl.clear();
    _correoCtrl.clear();
    _distritoCtrl.clear();
    _obs1Ctrl.clear();
    _obs2Ctrl.clear();
    _obs3Ctrl.clear();
    _referenciaCtrl.clear();
    setState(() {
      _tipoSeleccionado   = null;
      _asesorSeleccionado = null;
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

                  // ── TIPO DE PROSPECTO ──────────────────────────
                  _seccion('🏷️ Tipo de Prospecto'),
                  _comboTipo(),
                  const SizedBox(height: 16),

                  // ── REFERENCIA (label dinámico) ────────────────
                  if (_tipoSeleccionado != null) ...[
                    _seccion('📌 ${AppConfig.labelReferencia(_tipoSeleccionado!)}'),
                    CustomTextField(
                      label: AppConfig.labelReferencia(_tipoSeleccionado!),
                      controller: _referenciaCtrl,
                      icon: Icons.store_outlined,
                    ),
                  ],

                  // ── ASESOR (solo 4/14 y STAND) ─────────────────
                  if (_tipoSeleccionado != null &&
                      AppConfig.tieneAsesor(_tipoSeleccionado!)) ...[
                    _seccion('👤 Asesor Adicional'),
                    _comboAsesor(),
                    const SizedBox(height: 16),
                  ],

                  // ── DATOS DEL PROSPECTO ────────────────────────
                  _seccion('👥 Datos del Prospecto'),
                  CustomTextField(
                    label: 'Nombre completo',
                    controller: _nombreCtrl,
                    icon: Icons.person_outline,
                  ),
                  CustomTextField(
                    label: 'Teléfono',
                    controller: _telefonoCtrl,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  CustomTextField(
                    label: 'Correo electrónico',
                    controller: _correoCtrl,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    obligatorio: false,
                    hint: 'Opcional',
                  ),
                  CustomTextField(
                    label: 'Distrito',
                    controller: _distritoCtrl,
                    icon: Icons.location_on_outlined,
                  ),

                  // ── INTENTOS DE CONTACTO ───────────────────────
                  _seccion('📝 Intentos de Contacto'),
                  CustomTextField(
                    label: '1er intento de contacto',
                    controller: _obs1Ctrl,
                    icon: Icons.chat_bubble_outline,
                    maxLines: 2,
                    obligatorio: false,
                    hint: 'Ej: Llamó, interesado, cita para el viernes...',
                  ),
                  CustomTextField(
                    label: '2do intento de contacto',
                    controller: _obs2Ctrl,
                    icon: Icons.chat_bubble_outline,
                    maxLines: 2,
                    obligatorio: false,
                    hint: 'Ej: No contestó, dejó mensaje...',
                  ),
                  CustomTextField(
                    label: '3er intento de contacto',
                    controller: _obs3Ctrl,
                    icon: Icons.chat_bubble_outline,
                    maxLines: 2,
                    obligatorio: false,
                    hint: 'Ej: Confirmó reunión...',
                  ),

                  // ── FECHA ──────────────────────────────────────
                  const SizedBox(height: 8),
                  Container(
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
                      Text('Fecha: $_fechaHoy',
                          style: GoogleFonts.poppins(
                              color: Colors.indigo.shade700)),
                    ]),
                  ),
                  const SizedBox(height: 24),

                  // ── MENSAJE ────────────────────────────────────
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

                  // ── BOTÓN ──────────────────────────────────────
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

  // ── WIDGETS AUXILIARES ───────────────────────────────────

  Widget _comboTipo() {
    return DropdownButtonFormField<String>(
      value: _tipoSeleccionado,
      decoration: InputDecoration(
        labelText: 'Tipo de prospecto *',
        prefixIcon: const Icon(Icons.category_outlined, color: Colors.indigo),
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
        _asesorSeleccionado = null; // resetear asesor al cambiar tipo
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
        labelText: 'Asesor adicional (opcional)',
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
          child: Text('Sin asesor adicional',
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
