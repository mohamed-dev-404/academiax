import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';

//* Main User Entity with Equatable for optimized state rebuilds
class UserModel extends Equatable {
  final String? id;
  final String? name;
  final String? academicEmail;
  final String? academicId;
  final String? profilePic;

  const UserModel({
    this.id,
    this.name,
    this.academicEmail,
    this.academicId,
    this.profilePic,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
    id: data[ApiKeys.id] as String?,
    name: data[ApiKeys.name] as String?,
    academicEmail: data[ApiKeys.academicEmail] as String?,
    academicId: data[ApiKeys.academicId] as String?,
    profilePic: data[ApiKeys.profilePic] as String?,
  );

  Map<String, dynamic> toMap() => {
    ApiKeys.id: id,
    ApiKeys.name: name,
    ApiKeys.academicEmail: academicEmail,
    ApiKeys.academicId: academicId,
    ApiKeys.profilePic: profilePic,
  };

  factory UserModel.fromJson(String data) {
    return UserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  UserModel copyWith({
    String? id,
    String? name,
    String? academicEmail,
    String? academicId,
    String? profilePic,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      academicEmail: academicEmail ?? this.academicEmail,
      academicId: academicId ?? this.academicId,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  List<Object?> get props => [id, name, academicEmail, academicId, profilePic];
}
