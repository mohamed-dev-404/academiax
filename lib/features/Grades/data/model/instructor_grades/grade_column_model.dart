import 'package:sams_app/core/utils/constants/api_keys.dart';

class GradeColumnModel {
  final String key;
  final String name;
  final num? points;
  final bool? isVisible;

  GradeColumnModel({
    required this.key,
    required this.name,
    this.points,
    this.isVisible,
  });

  factory GradeColumnModel.fromJson(Map<String, dynamic> json) {
    return GradeColumnModel(
      key: json[ApiKeys.key] as String,
      name: json[ApiKeys.name] as String,
      points: json[ApiKeys.points] as num?,
      isVisible: json[ApiKeys.isVisible] as bool?,
    );
  }
}
