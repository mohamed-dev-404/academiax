import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/cache/get_storage.dart';
import 'package:sams_app/core/cache/secure_storage.dart';
import 'package:sams_app/core/utils/mixins/cubit_message_mixin.dart';
import 'package:sams_app/core/utils/mixins/safe_emit_mixin.dart';
import 'package:sams_app/features/profile/data/models/user_model.dart';
import 'package:sams_app/features/profile/data/repos/profile_repo.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_state.dart';

//* Manages profile state — fetch user data and handle profile picture upload
class ProfileCubit extends HydratedCubit<ProfileState>
    with CubitMessageMixin, SafeEmitMixin {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  //* Fetch user profile — skips loading state if data already exists
  Future<void> getUserProfile() async {
    if (state is! ProfileSuccess) {
      emit(ProfileLoading());
    }

    final result = await profileRepo.getUserProfile();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (state is ProfileSuccess) {
          emitMessage(failure); // show error without clearing existing data
        } else {
          emit(ProfileFailure(failure));
        }
      },
      (userModel) => emit(ProfileSuccess(userModel)),
    );
  }

  @override
  Future<void> close() {
    closeMessages();
    return super.close();
  }

  // Persist only on success
  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    if (state is ProfileSuccess) {
      return state.userModel.toMap();
    }
    if (state is UploadProfilePicSuccess) {
      return state.userModel.toMap();
    }
    if (state is DeleteProfilePicSuccess) {
      return state.userModel.toMap();
    }
    if (state is UpdateNameSuccess) return state.userModel.toMap();
    return null;
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    try {
      final user = UserModel.fromMap(json);
      return ProfileSuccess(user);
    } catch (_) {
      return null;
    }
  }

  //? Pick image → process → upload to S3 → update profile
  //? Emits loading first, then success or failure based on result
  Future<void> uploadProfileImage(XFile imageFile) async {
    emit(UploadProfilePicLoading(0));

    if (isClosed) return;

    final result = await profileRepo.uploadProfilePicture(imageFile);

    result.fold(
      (failure) {
        emit(UploadProfilePicFailure(failure));
      },
      (user) {
        emit(UploadProfilePicSuccess(user));
      },
    );
  }

  //! Delete profile picture
  Future<void> deleteProfileImage() async {
    emit(DeleteProfilePicLoading());

    final result = await profileRepo.deleteProfilePicture();

    if (isClosed) return;

    result.fold(
      (failure) => emit(DeleteProfilePicFailure(failure)),
      (user) {
        emit(DeleteProfilePicSuccess(user));
        emit(ProfileSuccess(user));
      },
    );
  }

  //* edit user name in profile
  Future<void> updateName(String newName) async {
    emit(UpdateNameLoading());

    final result = await profileRepo.updateName(newName);

    result.fold(
      (failure) => emit(UpdateNameFailure(failure)),
      (user) {
        emit(UpdateNameSuccess(user));
        emit(ProfileSuccess(user));
      },
    );
  }

  //! Logout user and clear all cached data and tokens.
  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await profileRepo.logout();

    await result.fold(
      (failure) async {
        emit(LogoutFailure(failure));
      },
      (successMsg) async {
        //  Clear all cached data and tokens on logout
        await SecureStorageService.instance.clearAll();
        await GetStorageHelper.erase();

        emit(LogoutSuccess(successMsg));
      },
    );
  }
}
