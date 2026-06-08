import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/models/app_button_style_model.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/core/widgets/base/app_button.dart';
import 'package:sams_app/features/announcements/presentation/view/announcement_actions/widget/shared/announcement_form_section.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_state.dart';

class AddAnnouncementMobileViewBody extends StatefulWidget {
  const AddAnnouncementMobileViewBody({super.key, required this.courseId});
  final String courseId;

  @override
  State<AddAnnouncementMobileViewBody> createState() =>
      _AddAnnouncementMobileViewBodyState();
}

class _AddAnnouncementMobileViewBodyState
    extends State<AddAnnouncementMobileViewBody> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnnouncementsActionsCubit, AnnouncementsActionsState>(
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
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: AppColors.primaryDarkHover,
                      size: 32,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Announcement',
                        style: AppStyles.mobileTitleLargeMd.copyWith(
                          color: AppColors.primaryDarkHover,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // AddAnnouncementSection(
              //   titleController: _titleController,
              //   contentController: _contentController,
              // ),
              AnnouncementFormSection(
                titleController: _titleController,
                contentController: _contentController,
              ),
              const SizedBox(height: 80),
              AppButton(
                model: AppButtonStyleModel(
                  height: 50,
                  width: 294,
                  label: 'Add Announcement',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AnnouncementsActionsCubit>().addAnnouncement(
                        courseId: widget.courseId,
                        title: _titleController.text,
                        content: _contentController.text,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
