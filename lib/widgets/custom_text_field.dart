import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obligatorio;
  final TextInputType keyboardType;
  final int maxLines;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obligatorio = true,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: obligatorio ? '$label *' : label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, color: Colors.indigo) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
        ),
        validator: obligatorio
            ? (val) => (val == null || val.trim().isEmpty)
                ? 'El campo $label es obligatorio'
                : null
            : null,
      ),
    );
  }
}