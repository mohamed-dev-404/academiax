import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/materials/data/model/file_upload_reference.dart';

class MaterialAttachmentRequest {
  final String title;
  final String description;
  final List<FileUploadReference> materialItems;

  MaterialAttachmentRequest({
    required this.title,
    required this.description,
    required this.materialItems,
  });

  Map<String, dynamic> toJson() => {
    ApiKeys.title: title,
    ApiKeys.description: description,
    ApiKeys.materialItems: materialItems.map((e) => e.toJson()).toList(),
  };
}
