import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/materials/data/model/material_item_model.dart';
import 'package:sams_app/features/materials/presentation/view/manage_material/widget/shared/file_picker_card.dart';

/// A section responsible for managing file selection, categorizing them into
/// Videos and Documents, and tracking both existing and newly picked files.
class CourseMaterialSection extends StatefulWidget {
  const CourseMaterialSection({super.key, this.initialItems});

  /// Items already associated with this material (used during Edit mode).
  final List<MaterialItemModel>? initialItems;

  @override
  State<CourseMaterialSection> createState() => CourseMaterialSectionState();
}

class CourseMaterialSectionState extends State<CourseMaterialSection> {
  //* State for newly selected files from the device.
  final List<XFile> _pickedVideos = [];
  final List<XFile> _pickedDocuments = [];

  //* State for files that already exist on the server.
  List<MaterialItemModel> _existingVideos = [];
  List<MaterialItemModel> _existingDocuments = [];

  /// Aggregates all locally picked files for the final upload process.
  List<XFile> get allPickedFiles => [..._pickedVideos, ..._pickedDocuments];

  /// Filters out unique keys for remote items that the user has decided to keep.
  List<String> get remainingExistingIds => [
    ..._existingVideos.map((e) => e.key ?? ''),
    ..._existingDocuments.map((e) => e.key ?? ''),
  ].where((k) => k.isNotEmpty).toList();

  @override
  void initState() {
    super.initState();
    //? Distribute initial items into their respective categories based on file type.
    if (widget.initialItems != null) {
      _existingVideos = widget.initialItems!
          .where((item) => item.isVideoItem)
          .toList();
      _existingDocuments = widget.initialItems!
          .where((item) => !item.isVideoItem)
          .toList();
    }
  }

  /// Manually refreshes the existing files state, usually called by a parent/mixin.
  void initializeWithExistingFiles(List<MaterialItemModel> items) {
    setState(() {
      _existingVideos = items.where((item) => item.isVideoItem).toList();
      _existingDocuments = items.where((item) => !item.isVideoItem).toList();
    });
  }

  /// Handles platform-specific file picking logic for both videos and office documents.
  Future<void> handleFileSelection({required bool isVideo}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isVideo ? FileType.video : FileType.custom,
      allowedExtensions: isVideo ? null : ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        //* Map platform files to XFile for consistent handling across the app.
        final newFiles = result.files.map(
          (f) => XFile(f.path ?? f.name, name: f.name),
        );
        if (isVideo) {
          _pickedVideos.addAll(newFiles);
        } else {
          _pickedDocuments.addAll(newFiles);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Course Material', style: AppStyles.mobileBodyLargeSb),
          const SizedBox(height: 20),

          //* Video Category Management
          _buildVideoCard(),

          const SizedBox(height: 16),

          //* Document Category Management
          _buildDocumentCard(),
        ],
      ),
    );
  }

  /// Helper to build the Video picking card.
  Widget _buildVideoCard() {
    return FilePickerCard(
      iconPath: AppIcons.iconsVideo,
      title: 'Material Videos',
      subTitle: 'Upload MP4, MKV or AVI',
      existingFiles: _existingVideos,
      pickedFiles: _pickedVideos,
      onTap: () => handleFileSelection(isVideo: true),
      onRemovePicked: (file) => setState(() => _pickedVideos.remove(file)),
      onRemoveExisting: (item) => setState(() => _existingVideos.remove(item)),
    );
  }

  /// Helper to build the Document picking card.
  Widget _buildDocumentCard() {
    return FilePickerCard(
      iconPath: AppIcons.iconsPdf,
      title: 'Material Documents',
      subTitle: 'Upload PDF, PPTX or DOCX',
      existingFiles: _existingDocuments,
      pickedFiles: _pickedDocuments,
      onTap: () => handleFileSelection(isVideo: false),
      onRemovePicked: (file) => setState(() => _pickedDocuments.remove(file)),
      onRemoveExisting: (item) =>
          setState(() => _existingDocuments.remove(item)),
    );
  }
}
