import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/cache/get_storage.dart';
import 'package:sams_app/core/helper/app_snack_bar.dart';
import 'package:sams_app/core/utils/assets/app_icons.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/utils/constants/cache_keys.dart';
import 'package:sams_app/features/profile/data/models/user_model.dart';
import 'package:sams_app/features/profile/presentation/logic/image_acquisition.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_state.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/image_preview_dialog.dart';
import 'package:sams_app/features/profile/presentation/views/profile/widgets/shared/image_source_sheet.dart';

//* Profile picture section
class ProfilePicSection extends StatefulWidget {
  const ProfilePicSection({super.key, required this.userModel});
  final UserModel userModel;
  @override
  State<ProfilePicSection> createState() => _ProfilePicSectionState();
}

class _ProfilePicSectionState extends State<ProfilePicSection> {
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth(context);
    final isMobile = SizeConfig.isMobile(context); // ismobile
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UploadProfilePicSuccess ||
            state is DeleteProfilePicLoading) {
          setState(() {
            _pickedImage = null;
          });
        }
        if (state is DeleteProfilePicSuccess) {
          GetStorageHelper.remove(CacheKeys.profilePic);
          AppSnackBar.success(
            context,
            'Profile picture removed successfully',
          );
        }
        if (state is DeleteProfilePicFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      child: Center(
        child: SizedBox(
          width: SizeConfig.screenWidth(context) * .35,
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: ClipOval(
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      buildWhen: (previous, current) =>
                          current is ProfileSuccess ||
                          current is UploadProfilePicSuccess,
                      builder: (context, state) {
                        return _buildProfileImage(state);
                      },
                    ),
                  ),
                ),

                BlocBuilder<ProfileCubit, ProfileState>(
                  buildWhen: (previous, current) =>
                      current is UploadProfilePicLoading ||
                      current is! UploadProfilePicLoading,
                  builder: (context, state) {
                    if (state is UploadProfilePicLoading ||
                        state is DeleteProfilePicLoading) {
                      return _buildLoadingOverlay(); // show loading overlay
                    }
                    return const SizedBox.shrink();
                  },
                ),

                //* control profile picture icon
                Positioned(
                  bottom: 5,
                  right: 0,
                  left: 85,
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    buildWhen: (previous, current) =>
                        current is UploadProfilePicSuccess ||
                        current is DeleteProfilePicSuccess ||
                        current is ProfileSuccess,
                    builder: (context, profileState) {
                      // to show the edit icon if the pic is uploaded or deleted
                      bool hasProfilePic =
                          widget.userModel.profilePic != null &&
                          widget.userModel.profilePic!.isNotEmpty;

                      if (profileState is UploadProfilePicSuccess) {
                        // to show the edit icon if the pic is uploaded
                        hasProfilePic = true;
                      } else if (profileState is DeleteProfilePicSuccess) {
                        // to show the add icon if the pic is deleted
                        hasProfilePic = false;
                      } else if (profileState is ProfileSuccess) {
                        // to set the hasProfilePic variable based on the profileState
                        hasProfilePic =
                            profileState.userModel.profilePic != null &&
                            profileState.userModel.profilePic!.isNotEmpty;
                      }
                      return GestureDetector(
                        onTap: () => _showImageSourceSheet(
                          hasProfilePic,
                        ), // show image source sheet
                        child: _buildImageControlIcon(
                          // build image control icon
                          isMobile,
                          screenWidth,
                          hasProfilePic,
                          profileState,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Pick image
  Future<void> _pickImage(ImageSource source) async {
    final XFile? processedImage = await ImageAcquisition.pickImage(
      context,
      source,
    );

    if (processedImage != null) {
      setState(() {
        _pickedImage = processedImage;
      });

      if (mounted) {
        context.read<ProfileCubit>().uploadProfileImage(processedImage);
      }
    }
  }

  // delete profile image
  Future<void> _deleteProfileImage() async {
    await context.read<ProfileCubit>().deleteProfileImage();
  }

  // Show image source sheet
  void _showImageSourceSheet(bool hasProfilePic) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImageSourceBottomSheet(
        onSourceSelected: _pickImage,
        onRemoveSelected: _deleteProfileImage,
        hasProfilePic: hasProfilePic,
      ),
    );
  }

  // Build image control icon
  Widget _buildImageControlIcon(
    bool isMobile,
    double screenWidth,
    bool hasProfilePic,
    ProfileState profilePicState,
  ) {
    if (profilePicState is UploadProfilePicSuccess) {
      hasProfilePic = true; // to show the edit icon if the pic is uploaded
    }
    if (profilePicState is DeleteProfilePicSuccess) {
      hasProfilePic = false; // to show the add icon if the pic is deleted
    }
    return Container(
      width: isMobile ? screenWidth * .8 : 30,
      height: isMobile
          ? screenWidth * .10
          : screenWidth > 800
          ? 40
          : 35,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: hasProfilePic
          ? SvgPicture.asset(
              AppIcons.iconsEditMaterial,
              colorFilter: const ColorFilter.mode(
                AppColors.whiteLight,
                BlendMode.srcIn,
              ),
            )
          : const Icon(
              Icons.add,
              color: AppColors.whiteLight,
            ),
    );
  }

  // Build loading overlay
  Widget _buildLoadingOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.white,
        ),
      ),
    );
  }

  // Build profile image
  Widget _buildProfileImage(ProfileState state) {
    if (state is UploadProfilePicLoading && _pickedImage != null) {
      return kIsWeb
          ? Image.network(_pickedImage!.path, fit: BoxFit.cover)
          : Image.file(File(_pickedImage!.path), fit: BoxFit.cover);
    }

    UserModel displayUser = widget.userModel;
    if (state is ProfileSuccess) {
      displayUser = state.userModel;
    } else if (state is UploadProfilePicSuccess) {
      displayUser = state.userModel;
      //* cache profile pic after success to display it in home
      GetStorageHelper.write(
        CacheKeys.profilePic,
        displayUser.profilePic,
      );
    }

    if (displayUser.profilePic != null && displayUser.profilePic!.isNotEmpty) {
      return GestureDetector(
        onTap: () => ImagePreviewDialog.open(context, displayUser.profilePic!),
        child: Hero(
          tag: displayUser.profilePic!,
          child: AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              // imageUrl:
              //     '${displayUser.profilePic}?t=${DateTime.now().millisecondsSinceEpoch}',
              imageUrl: displayUser.profilePic!,
              fit: BoxFit.cover,
              key: ValueKey(displayUser.profilePic),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => _buildDefaultProfileIcon(),
            ),
          ),
        ),
      );
    }
    return _buildDefaultProfileIcon();
  }

  // Build default profile icon
  Widget _buildDefaultProfileIcon() {
    return FittedBox(
      child: SvgPicture.asset(
        AppIcons.iconsHomeProfileHeader,
        colorFilter: const ColorFilter.mode(
          AppColors.whiteLight,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
