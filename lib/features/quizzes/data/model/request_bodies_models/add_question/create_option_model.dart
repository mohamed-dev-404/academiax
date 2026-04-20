import 'package:sams_app/core/utils/constants/api_keys.dart';

class CreateOptionModel {
  final String text;
  final bool isCorrect;

  const CreateOptionModel({
    required this.text,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.text: text,
      ApiKeys.isCorrect: isCorrect,
    };
  }
}
