import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.controller,
    this.textInputType,
    this.sufixIcon,
    this.obscureText = false,
    this.validator,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.readonly = false,
    this.onTap,
  });
  final TextEditingController controller;
  final String? hintText;
  final Icon? prefixIcon;
  final Widget? sufixIcon;
  final bool isPassword;
  final TextInputType? textInputType;
  final bool readonly;
  final String? Function(String?)? validator;
  void Function()? onTap;
  bool obscureText;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(),
      keyboardType: widget.textInputType,
      validator: widget.validator,
      obscureText: widget.obscureText,
      readOnly: widget.readonly,
      onTap: widget.onTap,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                },
                icon: widget.obscureText
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: const TextStyle(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
