import 'package:sams_app/core/utils/constants/api_keys.dart';

class ClassworkItemModel {
  final String id;
  final String name;
  final num points;
  final bool isVisible;

  const ClassworkItemModel({
    required this.id,
    required this.name,
    required this.points,
    required this.isVisible,
  });

  //! --- Serialization ---

  factory ClassworkItemModel.fromJson(Map<String, dynamic> json) {
    return ClassworkItemModel(
      id: json[ApiKeys.id] ?? '',
      name: json[ApiKeys.name] ?? '',
      points: json[ApiKeys.points] ?? 0,
      isVisible: json[ApiKeys.isVisible] ?? false,
    );
  }
}
