import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/file_upload_reference.dart';

class SubmitAssignmentRequest {
  final List<FileUploadReference> submittedItems;

  SubmitAssignmentRequest({required this.submittedItems});

  Map<String, dynamic> toJson() => {
    ApiKeys.submittedItems: submittedItems.map((e) => e.toJson()).toList(),
  };
}