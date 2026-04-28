import 'package:intl/intl.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/features/assignments/data/model/assignment_item_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/data/model/helper/helper.dart';

class AssignmentModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime dueDate;
  final int points;
  final AssignmentStatus status;
  final bool enablePlagiarismCheck;
  final int? plagiarismThreshold;
  final String classworkId;
  final List<AssignmentItemModel> assignmentItems;
  final String? submissionId;
  final List<AssignmentItemModel> submittedItems;

  const AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    required this.points,
    required this.status,
    required this.enablePlagiarismCheck,
    this.plagiarismThreshold,
    required this.classworkId,
    required this.assignmentItems,
    this.submissionId,
    required this.submittedItems,
  });

  // --- Display Getters ---
  String get formattedDueDate => DateFormat('dd MMM, hh:mm a').format(dueDate);
  String get formattedCreatedAt =>
      DateFormat('dd MMM, hh:mm a').format(createdAt);

  // --- Logic Getter: AssignmentState ---
  AssignmentState get state {
    if (CurrentRole.role == UserRole.student) {
      return switch (status) {
        AssignmentStatus.handedIn => AssignmentState.submitted,
        AssignmentStatus.missed => AssignmentState.missed,
        AssignmentStatus.assigned =>
          DateTime.now().isAfter(dueDate)
              ? AssignmentState.missed
              : AssignmentState.available,
        _ => AssignmentState.unknown,
      };
    } else {
      return switch (status) {
        AssignmentStatus.ongoing => AssignmentState.onGoing,
        AssignmentStatus.closed => AssignmentState.closed,
        _ => AssignmentState.unknown,
      };
    }
  }

  // --- fromJson ---
  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json[ApiKeys.id] as String? ?? '',
      title: json[ApiKeys.title] as String? ?? '',
      description: json[ApiKeys.description] as String? ?? '',
      createdAt: parseDate(json[ApiKeys.createdAt]),
      dueDate: parseDate(json[ApiKeys.dueDate]),
      points: json[ApiKeys.points] as int? ?? 0,
      status: AssignmentStatus.fromString(json[ApiKeys.status] as String?),
      enablePlagiarismCheck:
          json[ApiKeys.enablePlagiarismCheck] as bool? ?? false,
      plagiarismThreshold: json[ApiKeys.plagiarismThreshold] as int?,
      classworkId: json[ApiKeys.classworkId] as String? ?? '',
      assignmentItems: (json[ApiKeys.assignmentItems] as List? ?? [])
          .map((e) => AssignmentItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      submissionId: json[ApiKeys.submissionId] as String?, submittedItems: (json[ApiKeys.submittedItems] as List? ?? [])
          .map((e) => AssignmentItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() => {
    ApiKeys.id: id,
    ApiKeys.title: title,
    ApiKeys.description: description,
    ApiKeys.createdAt: formatToUtcIso(createdAt),
    ApiKeys.dueDate: formatToUtcIso(dueDate),
    ApiKeys.points: points,
    ApiKeys.status: status.name,
    ApiKeys.enablePlagiarismCheck: enablePlagiarismCheck,
    ApiKeys.plagiarismThreshold: plagiarismThreshold,
    ApiKeys.classworkId: classworkId,
    ApiKeys.assignmentItems: assignmentItems.map((e) => e.toJson()).toList(),
    ApiKeys.submissionId: submissionId,
    ApiKeys.submittedItems: submittedItems.map((e) => e.toJson()).toList(),
  };
}
