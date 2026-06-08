import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/logout_dialog.dart';

//* A widget representing a logout option in the profile page.
class LogoutSection extends StatelessWidget {
  const LogoutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SvgPicture.asset(
              AppIcons.iconsProfileLogout,
            ),
            const SizedBox(width: 16),
            Text(
              'Log Out',
              style: AppStyles.mobileBodySmallSb.copyWith(color: AppColors.red),
            ),
          ],
        ),
      ),
    );
  }
}
