import 'package:flutter/material.dart';

@immutable
sealed class AnnouncementsActionsState {}

final class AnnouncementsActionsInitial extends AnnouncementsActionsState {}

// --- Add Announcement States ---
sealed class AddAnnouncementState extends AnnouncementsActionsState {}

// final class AddAnnouncementLoading extends AddAnnouncementState {}
final class AddAnnouncementSuccess extends AddAnnouncementState {
  final String message;
  AddAnnouncementSuccess(this.message);
}

final class AddAnnouncementFailure extends AddAnnouncementState {
  final String errMessage;
  AddAnnouncementFailure(this.errMessage);
}

// --- Update Announcement States ---
sealed class UpdateAnnouncementState extends AnnouncementsActionsState {}

// final class UpdateAnnouncementLoading extends UpdateAnnouncementState {}
final class UpdateAnnouncementSuccess extends UpdateAnnouncementState {
  final String message;
  UpdateAnnouncementSuccess(this.message);
}

final class UpdateAnnouncementFailure extends UpdateAnnouncementState {
  final String errMessage;
  UpdateAnnouncementFailure(this.errMessage);
}

// --- Delete Announcement States ---
sealed class DeleteAnnouncementState extends AnnouncementsActionsState {}

// final class DeleteAnnouncementLoading extends DeleteAnnouncementState {}
final class DeleteAnnouncementSuccess extends DeleteAnnouncementState {
  final String message;
  DeleteAnnouncementSuccess(this.message);
}

final class DeleteAnnouncementLoading extends DeleteAnnouncementState {}

final class DeleteAnnouncementFailure extends DeleteAnnouncementState {
  final String errMessage;
  DeleteAnnouncementFailure(this.errMessage);
}
