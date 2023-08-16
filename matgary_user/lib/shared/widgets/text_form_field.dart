import 'package:flutter/material.dart';

import '../utils/responsive.dart';

// ignore: must_be_immutable
class MyTextFormField extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  final String? Function(String? text)? validator;
  final TextInputType keyboardType;
  bool? isSecure;
  Widget? suffix;
  double? width;

  MyTextFormField({
    super.key,
    required this.labeltext,
    required this.validator,
    this.isSecure,
    this.suffix,
    this.width,
    required this.keyboardType,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? rwidth(context),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          errorMaxLines: 2,
          labelText: labeltext,
          suffixIcon: suffix,
        ),
        validator: validator,
        keyboardType: keyboardType,
        obscureText: isSecure ?? false,
      ),
    );
  }
}
