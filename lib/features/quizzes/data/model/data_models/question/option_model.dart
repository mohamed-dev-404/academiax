import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';

class OptionModel {
  final String id;
  final String text;
  final bool? isCorrect;
  const OptionModel({
    required this.id,
    required this.text,
    this.isCorrect,
  });

  // Helper to check if we are even allowed to see the answer
  bool get hasAnswerKey => isCorrect != null;

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    bool? parsedIsCorrect;

    // Only parse if the key exists AND the user is an instructor
    if (CurrentRole.role == UserRole.instructor &&
        json.containsKey(ApiKeys.isCorrect)) {
      parsedIsCorrect = json[ApiKeys.isCorrect] as bool?;
    }

    return OptionModel(
      id: json[ApiKeys.id] ?? '',
      text: json[ApiKeys.text] ?? '',
      isCorrect: parsedIsCorrect,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      ApiKeys.id: id,
      ApiKeys.text: text,
    };

    // Only add the key to the map if it isn't null
    if (isCorrect != null) {
      data[ApiKeys.isCorrect] = isCorrect;
    }

    return data;
  }
}
