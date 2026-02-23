import '../core/api_client.dart';
import '../models/announcement.dart';

class AnnouncementService {
  static Future<List<Announcement>> list() async {
    final data = await ApiClient.get('/announcements');
    return (data as List)
        .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Announcement> create(Announcement announcement) async {
    final data = await ApiClient.post('/announcements', announcement.toJson());
    return Announcement.fromJson(data as Map<String, dynamic>);
  }

  static Future<void> delete(int id) => ApiClient.delete('/announcements/$id');
}
