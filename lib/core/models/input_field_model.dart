import 'package:flutter/widgets.dart';
import 'package:sams_app/core/enums/text_field_type.dart';

class InputFieldData {
  final String label;
  final String hint;
  final TextFieldType type;
  final TextEditingController controller;

  InputFieldData({
    required this.label,
    required this.hint,
    required this.controller,
    this.type = TextFieldType.normal,
  });
}