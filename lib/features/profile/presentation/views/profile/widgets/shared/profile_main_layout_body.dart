import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';
import 'package:sams_app/features/profile/data/models/user_model.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_state.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/profile_info_card.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/profile_pic_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

//* The main layout for the profile page.
class ProfileMainLayoutBody extends StatefulWidget {
  const ProfileMainLayoutBody({
    super.key,
  });

  @override
  State<ProfileMainLayoutBody> createState() => _ProfileMainLayoutBodyState();
}

class _ProfileMainLayoutBodyState extends State<ProfileMainLayoutBody> {
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _messageSubscription = context.read<ProfileCubit>().messageStream.listen((
      msg,
    ) {
      if (mounted) {
        AppSnackBar.warning(context, msg);
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = SizeConfig.isMobile(context);
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          current is ProfileFailure ||
          current is UploadProfilePicSuccess ||
          current is UploadProfilePicFailure ||
          current is LogoutSuccess ||
          current is LogoutFailure ||
          current is UpdateNameSuccess ||
          current is UpdateNameFailure,

      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.goNamed(RoutesName.login);
        }

        if (state is LogoutFailure) {
          AppSnackBar.error(context, state.errMessage);
        }

        if (state is ProfileFailure) {
          AppSnackBar.error(context, state.errMessage);
        }

        if (state is UploadProfilePicSuccess) {
          AppSnackBar.success(
            context,
            'Your profile picture Updated successfully ✓',
          );
        }

        if (state is UploadProfilePicFailure) {
          AppSnackBar.error(context, state.errMessage);
        }

        if (state is UpdateNameSuccess) {
          AppSnackBar.success(context, 'Name updated successfully!');
        }

        if (state is UpdateNameFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      buildWhen: (previous, current) => current is! ProfileActionState,
      builder: (context, state) {
        final bool isLoading = state is! ProfileSuccess;
        final user = state is ProfileSuccess ? state.userModel : _dummyUser;
        if (state is ProfileSuccess) {
          return Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                  child: SvgPicture.asset(
                    AppImages.imagesHeaderCard,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Column(
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 5,
                    child: ProfilePicSection(
                      userModel: state.userModel,
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Flexible(
                    flex: 12,
                    child: ProfileInfoCard(
                      userModel: state.userModel,
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  const Expanded(
                    flex: 5,
                    child: SizedBox(width: double.infinity),
                  ),
                ],
              ),
            ],
          );
        }
        if (state is ProfileFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.red),
                const SizedBox(height: 16),
                Text(state.errMessage),
                TextButton(
                  onPressed: () =>
                      context.read<ProfileCubit>().getUserProfile(),
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }
        return Skeletonizer(
          enabled: isLoading,
          enableSwitchAnimation: true,
          child: Column(
            children: [
              // Variable top spacing based on device type
              SizedBox(height: isMobile ? 40 : 20),

              // Profile Picture Section
              ProfilePicSection(userModel: user),

              // Intermediate spacing
              SizedBox(height: isMobile ? 40 : 20),

              // User Information Card
              ProfileInfoCard(userModel: user),

              // Decorative background illustration
              Expanded(
                flex: 7,
                child: Align(
                  alignment: isMobile
                      ? Alignment.bottomCenter
                      : Alignment.bottomRight,
                  child: SvgPicture.asset(
                    AppImages.imagesHeaderCard,
                    fit: BoxFit.contain,
                    width: isMobile
                        ? double.infinity
                        : MediaQuery.sizeOf(context).width * 0.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dummy model used only to let Skeletonizer draw UI bones
  UserModel get _dummyUser => const UserModel(
    id: 'dummy-id',
    name: 'User Full Name',
    academicEmail: 'username@academic.edu.eg',
    academicId: '202XXXXXXX',
    profilePic: '',
  );
}
