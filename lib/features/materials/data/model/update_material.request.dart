import 'package:sams_app/core/utils/constants/api_keys.dart';

class UpdateMaterialRequest {
  final String? title;
  final String? description;

  UpdateMaterialRequest({this.title, this.description});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data[ApiKeys.title] = title;
    if (description != null) data[ApiKeys.description] = description;
    return data;
  }
}