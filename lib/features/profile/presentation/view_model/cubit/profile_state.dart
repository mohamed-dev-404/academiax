import 'package:sams_app/features/profile/data/models/user_model.dart';

//* Base state for Profile feature.
sealed class ProfileState {}

/// Initial state when the profile page is first created.
final class ProfileInitial extends ProfileState {}

//? Emitted while fetching user profile data from the server.
final class ProfileLoading extends ProfileState {}

//* Emitted when user profile data is retrieved successfully.
//* Contains the [UserModel] with all user details.
final class ProfileSuccess extends ProfileState {
  final UserModel userModel;
  ProfileSuccess(this.userModel);
}

//! Emitted when fetching profile data fails.
//! Contains the [errMessage] to be displayed to the user.
final class ProfileFailure extends ProfileState {
  final String errMessage;
  ProfileFailure(this.errMessage);
}




//* Base state for profile actions (upload, update, etc.)
sealed class ProfileActionState extends ProfileState {}


//? Emitted while uploading profile picture.
final class UploadProfilePicLoading extends ProfileActionState {
  final double progress;
  UploadProfilePicLoading(this.progress);
}

//* Emitted when profile picture upload is successful.
//* Contains the [UserModel] with updated profile picture.
final class UploadProfilePicSuccess extends ProfileActionState {
  final UserModel userModel;
  UploadProfilePicSuccess(this.userModel);
}

//! Emitted when profile picture upload fails.
//! Contains the [errMessage] to be displayed to the user.
final class UploadProfilePicFailure extends ProfileActionState {
  final String errMessage;
  UploadProfilePicFailure(this.errMessage);
}

//? Emitted while deleting profile picture.
final class DeleteProfilePicLoading extends ProfileActionState {}

//* Emitted when profile picture delete is successful.
final class DeleteProfilePicSuccess extends ProfileActionState {
  final UserModel userModel;
  DeleteProfilePicSuccess(this.userModel);
}

//! Emitted when profile picture delete fails.
final class DeleteProfilePicFailure extends ProfileActionState {
  final String errMessage;
  DeleteProfilePicFailure(this.errMessage);
}

//? Emitted while logging out.
final class LogoutLoading extends ProfileActionState {}

//* Emitted when logout is successful.
final class LogoutSuccess extends ProfileActionState {
  final String message;
  LogoutSuccess(this.message);
}

//! Emitted when logout fails.
final class LogoutFailure extends ProfileActionState {
  final String errMessage;
  LogoutFailure(this.errMessage);
}

//? Emitted while updating name.
final class UpdateNameLoading extends ProfileActionState {}

//* Emitted when name update is successful.
final class UpdateNameSuccess extends ProfileActionState {
  final UserModel userModel;
  UpdateNameSuccess(this.userModel);
}

//! Emitted when name update fails.
final class UpdateNameFailure extends ProfileActionState {
  final String errMessage;
  UpdateNameFailure(this.errMessage);
}
