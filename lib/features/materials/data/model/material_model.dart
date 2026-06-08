import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/materials/data/model/material_item_model.dart';

class MaterialModel {
  final String id;
  final String title;
  final String description;
  final List<MaterialItemModel> materialItems;

  MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.materialItems,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json[ApiKeys.id] as String? ?? '',
      title: json[ApiKeys.title] as String? ?? '',
      description: json[ApiKeys.description] as String? ?? '',
      materialItems: (json[ApiKeys.materialItems] as List? ?? [])
          .map(
            (item) => MaterialItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    ApiKeys.id: id,
    ApiKeys.title: title,
    ApiKeys.description: description,
    ApiKeys.materialItems: materialItems.map((item) => item.toJson()).toList(),
  };
}
