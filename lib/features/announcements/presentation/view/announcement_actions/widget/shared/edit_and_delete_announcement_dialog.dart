// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sams_app/core/utils/colors/app_colors.dart';
// import 'package:sams_app/core/utils/styles/app_styles.dart';
// import 'package:sams_app/core/widgets/base/app_button.dart';
// import 'package:sams_app/core/models/app_button_style_model.dart';
// import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/add_announcement_section.dart';
// import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
// import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_state.dart';
// import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
// import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_state.dart';

// class EditAndDeleteAnnouncementDialog extends StatefulWidget {
//   // final String courseId;
//   final String announcementId;
//   final String initialTitle;
//   final String initialContent;

//   const EditAndDeleteAnnouncementDialog({
//     super.key,
//     // required this.courseId,
//     required this.announcementId,
//     //  required courseId,
//     required this.initialTitle,
//     required this.initialContent,
//   });

//   @override
//   State<EditAndDeleteAnnouncementDialog> createState() =>
//       _EditAndDeleteAnnouncementDialogState();
// }

// class _EditAndDeleteAnnouncementDialogState
//     extends State<EditAndDeleteAnnouncementDialog> {
//   late final TextEditingController _titleController;
//   late final TextEditingController _contentController;
//   final _formKey = GlobalKey<FormState>();
//   String _currentServerTitle = '';
//   String _currentServerContent = '';

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.initialTitle);
//     _contentController = TextEditingController(text: widget.initialContent);
//     // context.read<AnnouncementsFetchCubit>().fetchAnnouncementDetails(
//     //   announcementId: widget.announcementId,
//     // );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener<AnnouncementsActionsCubit, AnnouncementsActionsState>(
//             listener: (context, state) {
//              if (state is UpdateAnnouncementSuccess) {
//       Navigator.pop(context, 'updated');
//     } else if (state is DeleteAnnouncementSuccess) {
//       Navigator.pop(context, 'deleted');
//     }
//             },
//           ),
//           BlocListener<AnnouncementsFetchCubit, AnnouncementsFetchState>(
//             listener: (context, state) {
//               if (state is AnnouncementFetchDetailsSuccess) {
//                 _titleController.text = state.announcementDetails.title;
//                 _contentController.text = state.announcementDetails.content;
//                 _currentServerTitle = state.announcementDetails.title;
//                 _currentServerContent = state.announcementDetails.content;
//               }
//             },
//           ),
//         ],
//         child: Container(
//           width: 550,
//           padding: const EdgeInsets.all(28),
//           child: BlocBuilder<AnnouncementsFetchCubit, AnnouncementsFetchState>(
//             builder: (context, state) {
//               if (state is AnnouncementDetailsFetchLoading) {
//                 return const SizedBox(
//                   height: 300,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//               return Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Edit Announcement',
//                       style: AppStyles.webTitleMediumSb.copyWith(
//                         color: AppColors.primaryDarkHover,
//                         fontSize: 18,
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     AnnouncementFormSection(
//                       titleController: _titleController,
//                       contentController: _contentController,
//                       isEdit: true,
//                     ),

//                     const SizedBox(height: 32),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: AppButton(
//                             model: AppButtonStyleModel(
//                               label: 'Update',
//                               onPressed: () {
//                                 if (_titleController.text ==
//                                         _currentServerTitle&&
//                                     _contentController.text ==
//                                         _currentServerContent) {
//                                   Navigator.pop(context);
//                                   return;
//                                 }

//                                 if (_formKey.currentState!.validate()) {
//                                   context
//                                       .read<AnnouncementsActionsCubit>()
//                                       .updateAnnouncement(
//                                         announcementId: widget.announcementId,
//                                         title: _titleController.text,
//                                         content: _contentController.text,
//                                       );
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: AppButton(
//                             model: AppButtonStyleModel(
//                               label: 'Delete',
//                               backgroundColor: Colors.redAccent,
//                               onPressed: () {
//                                 context
//                                     .read<AnnouncementsActionsCubit>()
//                                     .deleteAnnouncement(
//                                       announcementId: widget.announcementId,
//                                     );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/announcement_form_section.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_state.dart';

class EditAndDeleteAnnouncementDialog extends StatefulWidget {
  final String announcementId;
  final String initialTitle;
  final String initialContent;

  const EditAndDeleteAnnouncementDialog({
    super.key,
    required this.announcementId,
    required this.initialTitle,
    required this.initialContent,
  });

  @override
  State<EditAndDeleteAnnouncementDialog> createState() =>
      _EditAndDeleteAnnouncementDialogState();
}

class _EditAndDeleteAnnouncementDialogState
    extends State<EditAndDeleteAnnouncementDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();

  late final String _originalTitle;
  late final String _originalContent;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);

    _originalTitle = widget.initialTitle;
    _originalContent = widget.initialContent;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: BlocListener<AnnouncementsActionsCubit, AnnouncementsActionsState>(
        listener: (context, state) {
          if (state is UpdateAnnouncementSuccess) {
            Navigator.pop(context, 'updated');
          } else if (state is DeleteAnnouncementSuccess) {
            Navigator.pop(context, 'deleted');
          } else if (state is UpdateAnnouncementFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state is DeleteAnnouncementFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: Container(
          width: 550,
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Announcement',
                  style: AppStyles.webTitleMediumSb.copyWith(
                    color: AppColors.primaryDarkHover,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                AnnouncementFormSection(
                  titleController: _titleController,
                  contentController: _contentController,
                  isEdit: true,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        model: AppButtonStyleModel(
                          label: 'Update',
                          onPressed: () {
                            bool isChanged =
                                _titleController.text != _originalTitle ||
                                _contentController.text != _originalContent;

                            if (!isChanged) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No changes made'),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                              // Navigator.pop(context);
                              return;
                            }

                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<AnnouncementsActionsCubit>()
                                  .updateAnnouncement(
                                    announcementId: widget.announcementId,
                                    title: _titleController.text,
                                    content: _contentController.text,
                                  );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // زر الحذف
                    Expanded(
                      child: AppButton(
                        model: AppButtonStyleModel(
                          label: 'Delete',
                          backgroundColor: Colors.redAccent,
                          onPressed: () {
                            context
                                .read<AnnouncementsActionsCubit>()
                                .deleteAnnouncement(
                                  announcementId: widget.announcementId,
                                );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
