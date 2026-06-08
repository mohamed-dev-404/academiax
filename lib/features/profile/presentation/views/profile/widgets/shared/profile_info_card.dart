import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/profile/data/models/user_model.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/mobile/edit_name_buttom_sheet.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/interactive_wrapper.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/logout_dialog.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/logout_item.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/profile_info_item.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/web/edit_name_dialog.dart';

//* A card containing user profile information, including name, email, and ID.
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // Determine responsive width:
    // Max 450px for Web/Desktop and 90% of screen width for Mobile devices
    double cardWidth = width > 800 ? 450 : width * 0.9;

    return Center(
      child: Container(
        // width: double.infinity,
        width: cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        // Reduced vertical padding for a more compact look
        padding: const EdgeInsets.only(
          left: 20,
          right: 16,
          top: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.secondary),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'Personal Data',
              style: AppStyles.mobileButtonMediumSb.copyWith(
                color: AppColors.primaryDarkHover,
              ),
            ),
            const SizedBox(height: 16),
            InteractiveWrapper(
              onTap: () => _showUpdateName(context, userModel.name ?? ''),
              builder: (isHovered) => ProfileInfoItem(
                svgPath: AppIcons.iconsProfileName,
                label: 'Name',
                value: userModel.name ?? '',
                // Icon appears only when hovered
                postfix: isHovered
                    ? IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.primaryDarkHover,
                        ),
                        onPressed: () =>
                            _showUpdateName(context, userModel.name ?? ''),
                      )
                    : null,
              ),
            ),

            ProfileInfoItem(
              svgPath: AppIcons.iconsProfileEmail,
              label: 'Email',
              value: userModel.academicEmail ?? '',
            ),
            ProfileInfoItem(
              svgPath: AppIcons.iconsProfileId,
              label: 'ID',
              value: userModel.academicId ?? '',
            ),
            InteractiveWrapper(
              hoverColor: AppColors.redLightHover,
              onTap: () {
                final profileCubit = context
                    .read<
                      ProfileCubit
                    >(); // Access the ProfileCubit to perform logout action
                showDialog(
                  // Show the logout confirmation dialog
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: profileCubit,
                    child: const LogoutDialog(),
                  ),
                );
              },
              builder: (_) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: LogoutSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateName(BuildContext parentContext, String currentName) {
    bool isMobile = SizeConfig.isMobile(parentContext);

    if (isMobile) {
      showModalBottomSheet(
        context: parentContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => BlocProvider.value(
          value: parentContext.read<ProfileCubit>(),
          child: EditNameButtonSheet(currentName: currentName),
        ),
      );
    } else {
      showDialog(
        context: parentContext,
        builder: (context) => BlocProvider.value(
          value: parentContext.read<ProfileCubit>(),
          child: EditNameDialog(currentName: currentName),
        ),
      );
    }
  }
}
