import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/features/profile/data/models/user_model.dart';

//* Abstract contract for profile data operations
abstract class ProfileRepo {
  //* Returns current user data or failure message
  Future<Either<String, UserModel>> getUserProfile();

  //* Update user name
  Future<Either<String, UserModel>> updateName(String name);

  //? Process image and upload — multi-step operation
  Future<Either<String, UserModel>> uploadProfilePicture(XFile imageFile);

  //! Delete profile picture
  Future<Either<String, UserModel>> deleteProfilePicture();

  //! Logout user and return success or error message
  Future<Either<String, String>> logout();
}
