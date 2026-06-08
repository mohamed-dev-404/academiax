import 'package:get_storage/get_storage.dart';
import 'package:sams_app/features/announcements/data/model/announcement_model.dart';

//* Local cache for announcements using GetStorage
class AnnouncementLocalDataSource {
  final _storage = GetStorage();

  static const String _announcementsKey = 'CACHED_ANNOUNCEMENTS';

  //? Serialize and write announcements list to local storage
  Future<void> cacheAnnouncements(List<AnnouncementModel> announcements) async {
    final jsonList = announcements.map((item) => item.toJson()).toList();
    await _storage.write(_announcementsKey, jsonList);
  }

  //* Read and deserialize cached announcements — returns empty list if not found
  List<AnnouncementModel> getCachedAnnouncements() {
    final List<dynamic>? data = _storage.read(_announcementsKey);
    if (data != null) {
      return data.map((json) => AnnouncementModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> clearCache() async {
    await _storage.remove(_announcementsKey);
  }
}
