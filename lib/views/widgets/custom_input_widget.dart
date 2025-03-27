import 'package:flutter/material.dart';

class CustomInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomInputWidget({
    Key? key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}