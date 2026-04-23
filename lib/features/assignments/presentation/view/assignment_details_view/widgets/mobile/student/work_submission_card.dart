import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/assignments/data/model/helper/assignment_status_enum.dart';

class WorkSubmissionCard extends StatelessWidget {
  final AssignmentStatus status; // Current assignment status (assigned, ongoing, etc.)
  final VoidCallback? onActionPressed;  // Callback for bottom action button

  // Callback to send selected files back to parent
  final Function(List<PlatformFile>)? onFilesPicked;

  // List of files selected by the user (passed from parent)
  final List<PlatformFile> pickedFiles;

  // Callback to remove a file by index
  final Function(int index)? onRemoveFile;

  const WorkSubmissionCard({
    super.key,
    required this.status,
    this.onActionPressed,
    this.onFilesPicked,
    this.pickedFiles = const [], 
    this.onRemoveFile,
  });

  // Opens file picker and allows multiple file selection
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      allowMultiple: true, 
    );
     
     // If user selected files and callback exists → send files to parent
    if (result != null && onFilesPicked != null) {
      onFilesPicked!(result.files); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          /// Header section (Title + Status)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Work',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              _buildStatusLabel(), 
            ],
          ),
          const SizedBox(height: 20),

          /// Dynamic content (files or buttons)
          _buildStateContent(),

          const SizedBox(height: 24),

         /// Bottom action button
          _buildActionButton(),
        ],
      ),
    );
  }
 
  /// Builds the status label based on assignment status
  Widget _buildStatusLabel() {
    String text;
    Color color;
    switch (status) {
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
      case AssignmentStatus.ongoing:
        text = 'Ongoing';
        color = Colors.orange;
        break;
      case AssignmentStatus.closed:
        text = 'Closed';
        color = Colors.grey;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
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
 
 /// Builds UI content depending on selected files or status
  Widget _buildStateContent() {
     // Case 1: If user already selected files → show them
    if (pickedFiles.isNotEmpty) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, 
        children: [
          // Display all selected files
          ...pickedFiles.asMap().entries.map((entry) {
            int index = entry.key;
            PlatformFile file = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildFileItem(
                file.name,
                index,
              ), 
            );
          }).toList(),

          const SizedBox(height: 12),
          // Button to add more files
          _buildAddMoreButton(),
        ],
      );
    }

    // Case 2: No files yet → show initial add button
    if (status == AssignmentStatus.assigned ||
        status == AssignmentStatus.ongoing) {
      return _buildInitialAddButton();
    }

     // Case 3: No UI needed
    return const SizedBox();
  }

 // Single file UI item with remove button
  Widget _buildFileItem(String fileName, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () => onRemoveFile?.call(index),
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

 /// Initial big button for adding files
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

  /// Small button to add more files
  Widget _buildAddMoreButton() {
    return InkWell(
      onTap: _pickFiles,
      child: const Row(
        children: [
          Icon(Icons.add, color: AppColors.primary, size: 18),
          SizedBox(width: 4),
          Text(
            "Add more files",
            style: TextStyle(color: AppColors.primary, fontSize: 13),
          ),
        ],
      ),
    );
  }

 /// Shows bottom sheet for file submission
  Widget _buildActionButton() {
    String text;
    Color bgColor;
    Color textColor = Colors.white;

    switch (status) {
      case AssignmentStatus.assigned:
      case AssignmentStatus.ongoing:
        text = 'Mark as Done';
        bgColor = const Color(0xFFB0D9E7); 
        textColor = const Color(0xFF6A97A8);
        break;
      case AssignmentStatus.missed:
        text = 'Unsubmit';
        bgColor = const Color(0xFFF9D5E0); 
        textColor = const Color(0xFFD67389);
        break;
      case AssignmentStatus.handedIn:
        text = 'Hand in';
        bgColor = AppColors.primary; 
        break;
      case AssignmentStatus.closed: 
        text = 'Assignment Closed';
        bgColor = Colors.grey.shade300;
        textColor = Colors.grey;
        break;
    }

    return ElevatedButton(
      onPressed: onActionPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }
}
