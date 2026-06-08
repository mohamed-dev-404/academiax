import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sams_app/core/cache/get_storage.dart';
import 'package:sams_app/core/cache/secure_storage.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/constants/cache_keys.dart';
import 'package:sams_app/features/auth/data/models/login_model/login_model.dart';
import 'package:sams_app/features/auth/data/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer api;

  AuthRepoImpl(this.api);

  //! login request
  @override
  Future<Either<String, LoginModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      // hit login request
      Map<String, dynamic> response = await api.post(
        EndPoints.login,
        data: {
          ApiKeys.academicEmail: email,
          ApiKeys.password: password,
        },
      );

      //parsing and initialize loginModel and decodedToken
      final dataJson = response[ApiKeys.data];
      LoginModel loginModel = LoginModel.fromJson(dataJson);
      final decodedToken = JwtDecoder.decode(loginModel.accessToken!);

      //cache tokens and role and required data to display in home
      await _cacheUserData(loginModel, decodedToken);

      return Right(loginModel); // success case, return loginModel
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  //! signup request
  @override
  Future<Either<String, String>> signUp({
    required String academicEmail,
    required String academicId,
    required String fullName,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // hit signUp request
      Map<String, dynamic> response = await api.post(
        EndPoints.register,
        data: {
          ApiKeys.name: fullName,
          ApiKeys.academicEmail: academicEmail,
          ApiKeys.academicId: academicId,
          ApiKeys.password: password,
          ApiKeys.confirmPassword: confirmPassword,
        },
      );
      //parsing and extract success message
      final String successMessage = response[ApiKeys.message];
      return Right(successMessage); // success case, return loginModel
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  //! forget password Flow

  //? (1) forget password request
  @override
  Future<Either<String, void>> forgotPassword({required String email}) async {
    try {
      //hit forget password request
      await api.post(
        EndPoints.forgetPassword,
        data: {
          ApiKeys.academicEmail: email,
        },
      );
      return const Right(null); //success case
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  //? (2) verify password request
  @override
  Future<Either<String, String>> verifyOtp({
    required String email,
    required String otp,
    required String action,
  }) async {
    try {
      //hit virfyOTP request
      final Map<String, dynamic> response = await api.post(
        EndPoints.verifyOTP,
        data: {
          ApiKeys.academicEmail: email,
          ApiKeys.code: otp,
          ApiKeys.action: action,
        },
      );

      //* parsing and extract reset token or success message (according to action)
      if (action == ApiValues.resetPassword) {
        final resetToken = response[ApiKeys.data][ApiKeys.resetToken];
        return Right(resetToken); //success case, return reset token
      } else {
        // then: action is == {ApiValues.activateAccount}
        final successMessage = response[ApiKeys.message];
        return Right(successMessage); //success case, return success message
      }
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  //? (3) reset password request
  @override
  Future<Either<String, String>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      //hit reset password request
      final Map<String, dynamic> response = await api.patch(
        EndPoints.resetPassword,
        data: {
          ApiKeys.resetToken: resetToken,
          ApiKeys.newPassword: newPassword,
          ApiKeys.confirmNewPassword: confirmNewPassword,
        },
      );
      //parsing and extract seccess message
      final successMessage = response[ApiKeys.message];

      return Right(successMessage); //seccess case
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  //* resend otp
  @override
  Future<Either<String, void>> resendOTP({
    required String email,
    required String action,
  }) async {
    try {
      //hit resend otp request
      await api.post(
        EndPoints.resendOTP,
        data: {ApiKeys.academicEmail: email, ApiKeys.action: action},
      );
      return const Right(null); //success case
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage); // failure case
    } catch (e) {
      return Left(e.toString()); // failure case
    }
  }

  //* helper methods
  Future<void> _cacheUserData(
    LoginModel loginModel,
    Map<String, dynamic> decodedToken,
  ) async {
    //? cache tokens and user data
    await SecureStorageService.instance.saveAccessToken(
      loginModel.accessToken ?? '',
    );
    await SecureStorageService.instance.saveRefreshToken(
      loginModel.refreshToken ?? '',
    );
    await GetStorageHelper.write(
      CacheKeys.name,
      loginModel.user?.name ?? '',
    );
    await GetStorageHelper.write(
      CacheKeys.academicEmail,
      loginModel.user?.academicEmail ?? '',
    );
    await GetStorageHelper.write(
      CacheKeys.profilePic,
      loginModel.user?.profilePic ?? '',
    );

    //? init and cache role helper values
    String role = decodedToken[ApiKeys.roles][0];
    bool isStudent = (role == ApiKeys.student);

    await GetStorageHelper.write(CacheKeys.role, role);
    await GetStorageHelper.write(CacheKeys.isStudent, isStudent);
  }
}
