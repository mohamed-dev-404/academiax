import 'package:flutter/material.dart';
import 'package:sams_app/features/announcements/data/model/announcement_details_model.dart';
import 'package:sams_app/features/announcements/data/model/announcement_model.dart';

@immutable
sealed class AnnouncementsFetchState {}

/// Initial state before any data fetching begins.
final class AnnouncementsFetchInitial extends AnnouncementsFetchState {}

// --- Announcements List Section ---

/// Emitted when the system is fetching the list of announcements from the network (and cache is empty).
final class AnnouncementsFetchLoading extends AnnouncementsFetchState {}

/// Emitted when the announcements list is successfully retrieved.
final class AnnouncementsFetchSuccess extends AnnouncementsFetchState {
  final List<AnnouncementModel> announcements;
  AnnouncementsFetchSuccess(this.announcements);
}

/// Emitted when an error occurs while fetching the announcements list.
final class AnnouncementsFetchFailure extends AnnouncementsFetchState {
  final String errMessage;
  AnnouncementsFetchFailure(this.errMessage);
}

// --- Announcement Details Section ---

/// Base state for individual announcement details.
sealed class AnnouncementDetailsState extends AnnouncementsFetchState {}

/// Emitted while loading full details and comments for a specific announcement.
final class AnnouncementDetailsFetchLoading extends AnnouncementDetailsState {}

/// Emitted when specific announcement details are successfully loaded.
final class AnnouncementFetchDetailsSuccess extends AnnouncementDetailsState {
  final AnnouncementDetailsModel announcementDetails;
  AnnouncementFetchDetailsSuccess(this.announcementDetails);
}

/// Emitted when fetching details for a specific announcement fails.
final class AnnouncementDetailsFetchFailure extends AnnouncementDetailsState {
  final String errMessage;
  AnnouncementDetailsFetchFailure(this.errMessage);
}
