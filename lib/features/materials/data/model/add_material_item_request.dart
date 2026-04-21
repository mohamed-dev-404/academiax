import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/materials/data/model/file_upload_reference.dart';

class AddMaterialItemsRequest {
  final List<FileUploadReference> materialItems;

  AddMaterialItemsRequest({required this.materialItems});

  Map<String, dynamic> toJson() => {
    ApiKeys.materialItems : materialItems.map((e) => e.toJson()).toList(),
  };
}