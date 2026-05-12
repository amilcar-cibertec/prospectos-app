import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sheets_service.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  String? _error;

  void _validar() {
  setState(() { _loading = true; _error = null; });
  final nombre = SheetsService.validarVendedor(_ctrl.text);
  Future.delayed(const Duration(milliseconds: 400), () {
    if (!mounted) return; // ← fix del warning
    setState(() => _loading = false);
    if (nombre != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => RegistroScreen(
          nombreVendedor: nombre,
          codigoVendedor: _ctrl.text.toUpperCase().trim(),
        ),
      ));
    } else {
      setState(() => _error = 'Código inválido. Contacta a tu supervisor.');
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.store_rounded, size: 64, color: Colors.indigo),
                  const SizedBox(height: 12),
                  Text('Gestión de Prospectos',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const SizedBox(height: 6),
                  Text('Ingresa tu código de vendedor',
                    style: GoogleFonts.poppins(color: Colors.grey)),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _ctrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Código de vendedor',
                      prefixIcon: const Icon(Icons.badge_outlined, color: Colors.indigo),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onSubmitted: (_) => _validar(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(_error!, style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _validar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _loading
                          ? const SizedBox(height: 20, width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Ingresar', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}