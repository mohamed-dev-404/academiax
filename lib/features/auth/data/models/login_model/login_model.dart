import 'package:equatable/equatable.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';

import 'user.dart';

class LoginModel extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final User? user;

  const LoginModel({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    accessToken: json[ApiKeys.accessToken] as String?,
    refreshToken: json[ApiKeys.refreshToken] as String?,
    expiresIn: json[ApiKeys.expiresIn] as int?,
    user: json[ApiKeys.user] == null
        ? null
        : User.fromJson(json[ApiKeys.user] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    ApiKeys.accessToken: accessToken,
    ApiKeys.refreshToken: refreshToken,
    ApiKeys.expiresIn: expiresIn,
    ApiKeys.user: user?.toJson(),
  };

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn, user];
}
