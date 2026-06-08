import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/announcement_form_section.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_state.dart';

class AddAnnouncementDialog extends StatefulWidget {
  const AddAnnouncementDialog({super.key, required this.courseId});
  final String courseId;

  @override
  State<AddAnnouncementDialog> createState() => _AddAnnouncementDialogState();
}

class _AddAnnouncementDialogState extends State<AddAnnouncementDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AnnouncementsActionsCubit>(),
      child: Builder(
        builder: (newContext) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                BlocListener<
                  AnnouncementsActionsCubit,
                  AnnouncementsActionsState
                >(
                  listener: (context, state) {
                    // TODO: implement listener
                    if (state is AddAnnouncementSuccess) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.green,
                        ),
                      );
                      Navigator.pop(context, true);
                    } else if (state is AddAnnouncementFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errMessage),
                          backgroundColor: Colors.red,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ── Title ──
                          Center(
                            child: Text(
                              'Announcement Information',
                              style: AppStyles.webTitleMediumSb.copyWith(
                                color: AppColors.primaryDarkHover,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ── Announcement Title Field ──
                          // AddAnnouncementSection(
                          //   titleController: _titleController,
                          //   contentController: _descriptionController,
                          // ),
                          AnnouncementFormSection(
                            titleController: _titleController,
                            contentController: _descriptionController,
                          ),
                          const SizedBox(height: 30),
                          // ── Submit Button ──
                          AppButton(
                            model: AppButtonStyleModel(
                              height: 40,
                              width: 250,
                              label: 'Add Announcement',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // TODO: context.read<AnnouncementsCubit>().addAnnouncement(...)
                                  newContext
                                      .read<AnnouncementsActionsCubit>()
                                      .addAnnouncement(
                                        courseId: widget.courseId,
                                        title: _titleController.text,
                                        content: _descriptionController.text,
                                      );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          );
        },
      ),
    );
  }
}
