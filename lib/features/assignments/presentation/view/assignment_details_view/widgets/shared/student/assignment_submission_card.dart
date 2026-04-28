
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/extentions/filter_files_helper.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/assignments/data/model/assignment_model.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';
import 'package:sams_app/features/assignments/presentation/view/create_assignment_view/widgets/shared/uploading_overlay.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_state.dart';

class AssignmentSubmissionCard extends StatefulWidget {
  final AssignmentModel assignment;
  final String courseId;
  final String assignmentId;
  final String classworkId;
  final bool checkPlagiarism;
  final bool hasPreviousSubmission;

  const AssignmentSubmissionCard({
    super.key,
    required this.assignment,
    required this.courseId,
    required this.assignmentId,
    required this.classworkId,
    required this.checkPlagiarism,
    this.hasPreviousSubmission = false,
  });

  @override
  State<AssignmentSubmissionCard> createState() =>
      _AssignmentSubmissionCardState();
}

class _AssignmentSubmissionCardState extends State<AssignmentSubmissionCard> {
  final List<XFile> _pickedFiles = [];
  OverlayEntry? _overlayEntry;

  void _showLoadingOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: const Center(
          child: Material(
            color: Colors.transparent,
            child: UploadingOverlay(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideLoadingOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideLoadingOverlay();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'ppt', 'pptx'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _pickedFiles.addAll(
          result.files.map((f) => XFile(f.path ?? f.name, name: f.name)),
        );
      });
    }
  }

  void _handleSubmit() {
    if (widget.checkPlagiarism && widget.hasPreviousSubmission) {
      AppToast.error(
        context,
        'Plagiarism active: Please unsubmit previous work first.',
      );
      return;
    }

    if (_pickedFiles.isEmpty) {
      AppToast.warning(context, 'Please attach your work first.');
      return;
    }

    if (widget.checkPlagiarism) {
      if (_pickedFiles.length > 1) {
        AppToast.error(context, 'Plagiarism check: Only ONE file allowed.');
        return;
      }
      final file = _pickedFiles.first;
      final extension = file.name.split('.').last.toLowerCase();
      if (!['doc', 'docx'].contains(extension)) {
        AppToast.error(context, 'Invalid file. Please upload a Word document.');
        return;
      }
    }

    context.read<AssignmentDetailsCubit>().submitAssignment(
      courseId: widget.courseId,
      assignmentId: widget.assignmentId,
      classworkId: widget.classworkId,
      files: _pickedFiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssignmentDetailsCubit, AssignmentDetailsState>(
      listener: (context, state) {
        if (state is StudentSubmissionLoading) {
          _showLoadingOverlay();
        } else {
          _hideLoadingOverlay();
          if (state is StudentSubmissionSuccess) {
            setState(
              () => _pickedFiles.clear(),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Work',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                _buildStatusLabel(),
              ],
            ),
            const SizedBox(height: 20),
            if (_pickedFiles.isNotEmpty)
              Column(
                children: [
                  ..._pickedFiles.asMap().entries.map(
                    (entry) => _buildFileTile(entry.value.name, entry.key),
                  ),
                  const SizedBox(height: 12),
                  _buildAddMoreButton(),
                ],
              )
            else
              _buildInitialAddButton(),
            const SizedBox(height: 24),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileTile(String name, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withAlpha(30)),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(name.fileIcon, color: name.fileColor),
        title: Text(
          name,
          style: AppStyles.mobileLabelMediumRg,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.red, size: 20),
          onPressed: () => setState(() => _pickedFiles.removeAt(index)),
        ),
      ),
    );
  }

  Widget _buildStatusLabel() {
    String text;
    Color color;
    switch (widget.assignment.status) {
      case AssignmentStatus.assigned:
        text = 'Assigned';
        color = const Color(0xFF1B85F3);
        break;
      case AssignmentStatus.missed:
        text = 'Missed';
        color = const Color(0xFFF34141);
        break;
      case AssignmentStatus.handedIn:
        text = 'Handed in';
        color = const Color(0xFF4CAF50);
        break;
      default:
        text = 'Assignment Closed';
        color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: (0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInitialAddButton() {
    return InkWell(
      onTap: _pickFiles,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Add Assignment',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMoreButton() {
    return InkWell(
      onTap: _pickFiles,
      borderRadius: BorderRadius.circular(
        8,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(
            alpha: 0.1,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.primary, size: 18),
            SizedBox(width: 6),
            Text(
              'Add more files',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: _pickedFiles.isEmpty
            ? const Color(0xFFB0D9E7)
            : AppColors.primary,
        foregroundColor: _pickedFiles.isEmpty
            ? const Color(0xFF6A97A8)
            : Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Hand in',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }
}
