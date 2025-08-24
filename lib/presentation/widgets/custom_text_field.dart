import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmanager/utils/context_extension.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.suffixIcon,
    this.disabled,
    this.keyboardType,
    this.validator,
    this.hintText,
    this.obscureText = false,
    this.inputFormatters,
  });
  final TextEditingController controller;
  final Icon? suffixIcon;
  final bool? disabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? hintText;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorText;
  late bool _obscureText;

  void _validate(String? value) {
    if (widget.validator != null) {
      final validationResult = widget.validator!(value);
      setState(() {
        errorText = validationResult;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    widget.controller.addListener(() {
      _validate(widget.controller.text);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasPasswordToggle = widget.obscureText;
    return TextField(
      controller: widget.controller,
      readOnly: widget.disabled ?? false,
      enabled: widget.disabled == false || widget.disabled == null,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        filled: true,
        suffixIcon: hasPasswordToggle
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: _toggleObscure,
              )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.colorScheme.primary),
        ),
        errorText: errorText,
        errorStyle: TextStyle(color: Colors.red),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      style: TextStyle(color: Colors.black87),
    );
  }
}
